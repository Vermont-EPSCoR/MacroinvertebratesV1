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
    
    NSString *estimated_sec = [self findWhatKindOfInternet];
    //NSLog(@"%@",estimated_sec);
    NSString *str = [NSString stringWithFormat: @"Select the streams you would like to download to your device. Syncing all of the streams will take ~%@ seconds.", estimated_sec];
    NSString *firstRunMessage = [NSString stringWithFormat: @"Thank you for downloading the VT EPSCoR Macroinvertebrate app.  You must download the macroinvertebrate data from the Internet before using this program.\n\nSelect the streams you would like to download to your device. Syncing all of the streams will take ~%@ seconds.", estimated_sec];
    if([estimated_sec isEqualToString:@"No Internet"]){
        firstRunMessage = [NSString stringWithFormat: @"Thank you for downloading the VT EPSCoR Macroinvertebrate app.  You must download the macroinvertebrate data from the Internet before using this program.\n\nPlease sync after connecting to the Internet."];
    }
    [self fetchRestData];
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Vermont EPSCOR"
                                                     message:([delegate isFirstRun]) ? firstRunMessage : str
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [alert show];
    [self updateLabelBarButton];
    
    NSArray *allStreams = [delegate.webData getAllStreams];
    //NSLog(@"HERE%@", [delegate.webData getAllStreams]);
    for (StreamData *stream in allStreams){
        [self.selectionsArray addObject:[stream.title stringByTrimmingCharactersInSet:
                                         [NSCharacterSet whitespaceCharacterSet]]];
        [self.defaultsSelectionsArray addObject:[stream.title stringByTrimmingCharactersInSet:
                                                 [NSCharacterSet whitespaceCharacterSet]]];
        //NSLog(@"In List %@", stream.title);
    }
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

- (void)fetchRestData {
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
                                   
                                   if([delegate isFirstRun])
                                       [self selectAll];
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
    //NSLog(@"CELL has %@, I have %@", [self selectionsArray], item);
    if ([self.selectionsArray containsObject:item]){
        //NSLog(@"have to tick this %@", item);
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
    //NSLog(@"Show Indicator");
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getThemAll];
    });
    /*
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Your code to run on the main queue/thread
        [self getThemAll];
        [SVProgressHUD dismiss];
    }];
     */
}

- (void)setProgressStatus:(NSString*)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        //[SVProgressHUD dismiss];
        [SVProgressHUD setStatus:status];
    });
}

- (void)dismissProgressStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)showAlert:(NSString*)title text:(NSString*)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:title
                                                         message:text
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
    });
}

- (BOOL) getThemAll {
    NSLog(@"Have to pull %@", self.selectionsArray);
    //spinner.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    // [delegate.window addSubview:spinner];
    
    [delegate.webData clearBugs];
    [delegate.webData clearStreams];
    
    // if none of the items are selected, pull all of them otherwise perform selective sync
    //if ([self updateLabelBarButton]){
    //    BOOL success = false;
        
        [self setProgressStatus:@"Downloading About Page"];
        [delegate.webData syncAppAbout];
        
        [self setProgressStatus:@"Downloading Streams"];
        NSDictionary *streamsAndPopulations = [delegate.webData getStreamsWeb:self.selectionsArray];
        NSMutableSet<NSString *> *allbugNames = [[NSMutableSet<NSString *> alloc] init];
        for(NSArray* bugs in [streamsAndPopulations allValues])
            [allbugNames addObjectsFromArray:bugs];
        [self setProgressStatus:@"Downloading Bugs"];
        NSArray<Invertebrate *> *allBugs = [delegate.webData getBugsWeb:[allbugNames allObjects]];
        [self setProgressStatus:@"Linking Bugs to Streams"];
        [delegate.webData linkBugsToStreams:allBugs :streamsAndPopulations];
//        NSDictionary *allBugsWithImageURLs = [delegate.webData getBugImageURLsWeb:allbugNames];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSLog(@"Getting Image URLs");
            NSMutableArray<NSDictionary *> *bugImages = [delegate.webData getBugImageURLs:allbugNames];
            [delegate.webData saveBugImages:bugImages];
        });
        
        /*
        NSLog(@"Getting Image URLs");
        NSMutableArray<NSDictionary *> *bugImages = [delegate.webData getBugImageURLs:allbugNames];
        NSLog(@"Done syncing... getting pictures");
        //[delegate.webData storeImagesFromURLs:allBugsWithImageURLs];
        NSThread* imageDLThread = [[NSThread alloc] initWithTarget:delegate.webData
                                                     selector:@selector(saveBugImages:)
                                                       object:bugImages];
        double thisPriority = [[NSThread currentThread] threadPriority];
        [imageDLThread setThreadPriority:(thisPriority*.5)];
        [imageDLThread start];  // Actually start the thread
         */
        [self dismissProgressStatus];
        /*
        for(NSString *bug in allbugNames) {
            NSLog(@"Getting Image for: %@",bug);
            [delegate.webData storeBugImageWeb:bug];
        }
 */
        //success = [delegate.webData getSelectedStreamsOnly:streamUnderConsideration];
/*        for (NSString *streamUnderConsideration in self.selectionsArray){
            NSArray *allbugs = [delegate.webData getPopulationWeb:streamUnderConsideration];
            //[delegate.webData getStreamWeb:streamUnderConsideration];
            [delegate.webData selectiveSync:allbugs];
            success = [delegate.webData getSelectedStreamsOnly:streamUnderConsideration];
            [SVProgressHUD setStatus:@"Updating message ..." ];
            NSLog(@"Update Message pop here");
        }
*/
        [self showAlert:@"Sync Complete" text:@"Sync Complete.\nImages will continue to download in the background."];
 /*
        else{
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Sync Failed"
                                                             message:@"Please select some and try again. Also, make sure you have a proper internet connection."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
        }

    }
  */
    /*
     else{
        
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [[self view] setNeedsDisplay];
        [delegate.webData synchBugs];
        BOOL success = [delegate.webData synchStreams];
        
        if(success){
            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Sync Complete"
                                                             message:@"Sync complete."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
            
        }
        else{
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Sync Failed"
                                                             message:@"Sync failed. Please check your Internet connection and try again."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
        }
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
     */
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
    //NSLog(@"STREAM! %@", self.selectionsArray);
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
    [self selectAll];
}

- (void)selectAll {
    // First, remove all streams from selectionsArray so we don't get duplicates
    [self.selectionsArray removeAllObjects];
    
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
