//
//  MacroTableViewController.m
//  searchbar
//
//  Created by mmai on 11/27/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//

#import "MacroTableViewController.h"
#import "MacroListCell.h"
#import "Invertebrate.h"
#import "Stream.h"
#import "DetailsViewController.h"

@interface MacroTableViewController ()

@end

@implementation MacroTableViewController
@synthesize stream;
@synthesize bugA;
@synthesize bugB;
@synthesize allBugs;

@synthesize delegate;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailsViewController *destViewController = segue.destinationViewController;
        destViewController.bug = [allBugs objectAtIndex:indexPath.row];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to bug detail
    [self performSegueWithIdentifier:@"showDetails" sender:tableView];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //pjc - Set Navigation Title
    self.navigationItem.title = stream.title;
    
    delegate = (macroinvAppDelegate *) [[UIApplication sharedApplication] delegate]; // to refer to AppDelegate methods

    allBugs = [NSMutableArray arrayWithArray:[delegate.webData getPopulation:(stream.title)]];
    //NSLog([allBugs description]);
    
    /* // TEST DATA
    bugA = [[Invertebrate alloc] init ];
    bugB = [[Invertebrate alloc] init ];
    
    bugB.order = @"Ephemeroptera";
    bugB.family = @"Baetidae";
    bugB.genus = @"Baetis";
    bugB.text = @"This mayfly has three 'tails' and a unique head shape. Its gills are oval shaped and insert dorsally. More mature nymphs have long, dark wing pads.";
    bugB.imageFile = @"bugB.jpg";
    
    bugA.imageFile = @"bugA.jpg";
    bugA.order = @"Ephemeroptera";
    bugA.family = @"Baetidae";
    bugA.genus = @"Baetis";
    bugA.text = @"This mayfly has three 'tails' and a unique head shape. Its gills are oval shaped and insert dorsally. More mature nymphs have long, dark wing pads.";
   
    
    
    if ([stream.title isEqualToString:@"Jug River"]){
        allBugs = [NSMutableArray arrayWithObjects:bugB, bugA, bugA, nil];
    }
    else{
        allBugs = [NSMutableArray arrayWithObjects:bugB,bugB,bugA, nil];
    }
    */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [allBugs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"macroListCell";
    MacroListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    InvertebrateData *currentBug = [allBugs objectAtIndex:indexPath.row];
    
    NSString *s = [currentBug.imageFile stringByReplacingOccurrencesOfString:@"File:" withString:@""];
    NSArray * se = [s componentsSeparatedByString:@"."];
    UIImage *image;
    if ([se count] > 1){
        image = [delegate.webData loadImage:[se objectAtIndex:0] ofType:[se objectAtIndex:1]];
    } else {
        image = nil;
    }
    //NSLog(@"Loaded %@ from %@",[image description], currentBug.imageFile);

    
    //    LOOK HERE TO TEST MacroTableView
    //    Uncomment the line below to test
    //    image = nil;
    
    if(image != nil){
        //UIImage *image = [UIImage imageNamed: bug.imageFile];
        cell.macroImage.contentMode = UIViewContentModeScaleAspectFit;
        [cell.macroImage setImage:image];
    } else {
        UIImage *image = [UIImage imageNamed: @"bugA.jpg"];
        cell.macroImage.contentMode = UIViewContentModeScaleAspectFit;
        [cell.macroImage setImage:image];
        
    }
    
    return cell;
}

// BK - NOV- 14

- (IBAction)downloadBugsInStream:(UIBarButtonItem *)sender {
    NSLog(@"Downloading Stuff for that stream %@", stream.title);
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
