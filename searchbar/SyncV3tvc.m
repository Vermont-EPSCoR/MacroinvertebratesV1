//
//  SyncV3tvc.m
//  
//
//  Created by Bijay Koirala on 11/28/15.
//
//

#import "SyncV3tvc.h"
#import "SVProgressHUD.h"

#define weburl @"http://wikieducator.org/api.php?action=query&list=categorymembers&cmtitle=Category:Stream&cmlimit=500&format=json&cmprop=ids%7Ctitle"
#define debug 1

@interface SyncV3tvc ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@end

@implementation SyncV3tvc
@synthesize streamsArray = _streamsArray;
@synthesize selectionsArray = _selectionsArray;
@synthesize defaultsSelectionsArray = _defaultsSelectionsArray;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectionsArray = [[NSMutableArray alloc] init];
    self.defaultsSelectionsArray = [[NSMutableArray alloc] init];
    delegate = (macroinvAppDelegate *) [[UIApplication sharedApplication] delegate]; // to refer to
    
    
    //[SVProgressHUD show];
    NSArray *allStreams = [delegate.webData getAllStreams];
    NSLog(@"HERE%@", [delegate.webData getAllStreams]);
    for (StreamData *stream in allStreams){
        [self.selectionsArray addObject:[stream.title stringByTrimmingCharactersInSet:
                                         [NSCharacterSet whitespaceCharacterSet]]];
        [self.defaultsSelectionsArray addObject:[stream.title stringByTrimmingCharactersInSet:
                                         [NSCharacterSet whitespaceCharacterSet]]];
        NSLog(@"In List %@", stream.title);
    }
    
    NSString *estimated_sec = [self findWhatKindOfInternet];
    NSLog(estimated_sec);
    NSString *str = [NSString stringWithFormat: @"Tap on the streams you are interested in. For each stream you sync, it will take ~ %@ seconds", estimated_sec];
    //NSString *showing =  @"Tap on the streams you are interested in. For each stream you sync, it will take ~ " estimated_sec  @" seconds.";
    [self fetchRestData];
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Vermont EPSCOR"
                                                     message:str
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [alert show];
    [self updateLabelBarButton];
    
    }

- (NSString *)findWhatKindOfInternet{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            NSLog(@"No wifi or cellular");
            return @"No Internet";
            break;
            
        case 1:
            NSLog(@"2G");
            return @"40";
            break;
            
        case 2:
            NSLog(@"3G");
            return @"30";
            break;
            
        case 3:
            NSLog(@"4G");
            return @"20";
            break;
            
        case 4:
            NSLog(@"LTE");
            return @"20";
            break;
            
        case 5:
            NSLog(@"Wifi");
            return @"20";
            break;
            
            
        default:
            return @"none";
            break;
            
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchRestData; {
    NSURL *url = [NSURL URLWithString:weburl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError) {
                               
                               if (data.length > 0 && connectionError == nil) {
                                   
                                   NSDictionary *rest_data = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:0
                                                                                               error:NULL];
                                   
                                   self.streamsArray = [NSMutableArray array];
                                  // NSDictionary *news;
                                   NSDictionary *temp = [rest_data objectForKey:@"query"];
                                   NSArray * streams2 = [temp objectForKey:(@"categorymembers")];
                                   
                                   int realCount = 0;
                                   
                                   for (int count = 0; count < [streams2 count]; count++){
                                       NSDictionary *current = [streams2 objectAtIndex:count];
                                       NSString *title = [current objectForKey:@"title"];
                                       
                                       if (![title containsString:@"Template"]){
                                           [self.streamsArray insertObject:title atIndex:realCount];
                                           realCount += 1;
                                       }
                                       
                                       
                                       
                                   }
                                   
                                   [self.tableView reloadData];
                                   [self.tableView numberOfRowsInSection:[_streamsArray count]];
                                   //[self.tableView reloadRowsAtIndexPaths:0 withRowAnimation:UITableViewRowAnimationLeft];
                                   // [SVProgressHUD dismiss];
                               }
                               
                           }];
   
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_streamsArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return false;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString* item = self.streamsArray[indexPath.row];
    cell.textLabel.text = item;
    NSLog(@"CELL has %@, I have %@", [self selectionsArray], item);
    if ([self.selectionsArray containsObject:item]){
        NSLog(@"have to tick this %@", item);
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (IBAction)pullSelectedStreams:(UIBarButtonItem *)sender {
    NSLog(@"Show Indicator");
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"Downloading Streams ..."];

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Your code to run on the main queue/thread
        if ([self getThemAll]){
            [SVProgressHUD dismiss];
            
        }
    }];
    
    
    
}

- (BOOL) getThemAll {
    NSLog(@"Have to pull %@", self.selectionsArray);
    //spinner.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    // [delegate.window addSubview:spinner];
    
    [delegate.webData clearBugs];
    
    [delegate.webData clearStreams];
    
    
    // if none of the items are selected, pull all of them otherwise perform selective sync
    if ([self updateLabelBarButton]){
        BOOL success = false;
        
        for (NSString *streamUnderConsideration in self.selectionsArray){
            NSArray *allbugs = [delegate.webData getPopulationWeb:streamUnderConsideration];
            //[delegate.webData getStreamWeb:streamUnderConsideration];
            [delegate.webData selectiveSync:allbugs];
            success = [delegate.webData getSelectedStreamsOnly:streamUnderConsideration];
            [SVProgressHUD setStatus:@"Updating message ..." ];
            NSLog(@"Update Message pop here");
        }
        
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
                                                             message:@"Please select some and try again. Also, make sure you have a proper internet connection."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
        }

    }
    else{
        
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [[self view] setNeedsDisplay];
        [delegate.webData synchBugs];
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
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
    return true;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to stream detail
    //[self performSegueWithIdentifier:@"mList" sender:tableView];
    NSString *streamUnderConsideration = [self.streamsArray objectAtIndex:[indexPath row]];
    if ([self.selectionsArray containsObject:streamUnderConsideration]){
        // remove the object - basically uncheck it
        [self.selectionsArray removeObject:streamUnderConsideration];
        // if the user clicked it, make it tick
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        [self.selectionsArray addObject:streamUnderConsideration];
        // if the user clicked it, make it tick
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    NSLog(@"STREAM! %@", self.selectionsArray);
    [self.tableView numberOfRowsInSection:[_streamsArray count]];
   // [self.tableView reloadRowsAtIndexPaths:0 withRowAnimation:UITableViewRowAnimationLeft];
    [self updateLabelBarButton];

}

- (IBAction)defaultSelection:(UIBarButtonItem *)sender {
    [self.selectionsArray removeAllObjects];
    for (NSString *stream in self.defaultsSelectionsArray){
        [self.selectionsArray addObject:stream];
    }
    [self.tableView reloadData];
}

- (IBAction)selectAll:(UIBarButtonItem *)sender {
    for (NSString *stream in self.streamsArray){
        [self.selectionsArray addObject:stream];
    }
    [self.tableView reloadData];
}

- (IBAction)selectNone:(UIBarButtonItem *)sender {
    [self.selectionsArray removeAllObjects];
    [self.tableView reloadData];
}

- (BOOL) updateLabelBarButton {
    return true;
//     if ([self.selectionsArray count] == 0){
//            self.barButton.title = @"Sync All";
//         return false;
//        }
//     else {
//         self.barButton.title = @"Pull";
//         return true;
//     }
//    
}



@end
