//
//  SyncTableVC_New.m
//  macroinvertebrates
//
//  Created by Bijay Koirala on 11/13/15.
//  Copyright © 2015 mmai. All rights reserved.

// NOTE TO SELF: it now pulls all streams

#import "SyncTableVC_New.h"
#import "InvertebrateData.h"

@interface SyncTableVC_New ()

@end

@implementation SyncTableVC_New
@synthesize delegate;
@synthesize streamArray;

//NSMutableArray *selectedStreams = [NSMutableArray];

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate = (macroinvAppDelegate *) [[UIApplication sharedApplication] delegate]; // to refer to
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Vermont EPSCOR"
                                                     message:@"Tap on the streams you are intersted in. If you sync all, it might take a few minutes, please be patient."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [alert show];
    //*selectedStreams = [NSMutableArray array];
    [self syncStreams];
    streamArray = [delegate.webData getAllStreams];
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) syncStreams{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[self view] setNeedsDisplay];
    BOOL success = [delegate.webData synchStreams];
    
    if(success){
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Sync Complete"
                                                         message:@"Congratulations, Sync Complete"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        
    }
    else{
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Sync Failed"
                                                         message:@"We apologize. Sync failed. Please check Network Connection and try again"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }
    [NSThread detachNewThreadSelector:@selector(threadStopAnimating:) toTarget:self withObject:nil];
    
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return streamArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Stream *stream = nil;
    stream = [streamArray objectAtIndex:indexPath.row];
    
    /*
    uncomment these later
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        stream = [filteredArray objectAtIndex:indexPath.row];
    } else {
        stream = [streamArray objectAtIndex:indexPath.row];
    }
    
    */
    // Configure the cell
    cell.textLabel.text = stream.title;
   // cell.accessoryType = UITableViewCellAccessoryCheckmark;
   // [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) threadStartAnimating:(id)data {
    //[activity startAnimating];
    NSLog(@"Started Animating");
}

- (void) threadStopAnimating:(id)data {
    //[activity stopAnimating];
    NSLog(@"Stopped Animating");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to stream detail
    //[self performSegueWithIdentifier:@"mList" sender:tableView];
    NSString *streamUnderConsideration = [[streamArray objectAtIndex:[indexPath row]] title];
   
    
    NSArray *allbugs = [delegate.webData getPopulationWeb:streamUnderConsideration];
    [delegate.webData selectiveSync:allbugs];
    //[self syncStreams];
   
    for (int i =0; i < allbugs.count ; i++){
        NSString *currentName = [allbugs objectAtIndex:i];
        currentName = [NSString stringWithFormat:@"Template:%@", currentName];
       // NSLog(currentName);
        
        
        // TODO
        
        // api call garne to each thing
        // getting image, saving image, putting it in coredata
        
        // end
        
        
    }
    
    // if the user clicked it, make it tick
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
}
@end
