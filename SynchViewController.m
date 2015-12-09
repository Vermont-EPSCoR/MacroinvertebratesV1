//
//  SynchViewController.m
//  searchbar
//
//  Created by Jeremy Gould on 12/8/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//

#import "SynchViewController.h"

@interface SynchViewController ()

@end

@implementation SynchViewController


@synthesize activity;
@synthesize textOut;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    delegate = (macroinvAppDelegate *) [[UIApplication sharedApplication] delegate]; // to refer to AppDelegate methods

}
- (IBAction)goClicked:(id)sender {
    //textOut.text = @"Connecting to Server...";
    //NSLog(@"GO");
    //[activity startAnimating]; // Start the spinner
    //textOut.text = @"Getting Invertebrate Data...";
    //NSLog(@"BUGS");
    //[delegate.webData synchBugs: activity with: textOut];
    //NSLog(@"STREAMS");
    //textOut.text = @"Getting Stream Data...";
    //[delegate.webData synchStreams:  activity with: textOut];
    //[activity stopAnimating];  // stop spinner
    //textOut.text = @"Process Complete";
    [self triggerSynch];
}

- (void) triggerSynch{
    //pjc - fix - Figure out how to update label with sync status
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    //pjc - Prevent device from sleeping and terminating sync
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    //[activity startAnimating];
    
    //[delegate.webData setFeedbackLabel:textOut];
    [textOut setNumberOfLines:2];
    [textOut setText:@"Getting Invertebrate Data"];
    [[self view] setNeedsDisplay];
    [delegate.webData synchBugs];
    [textOut setText:@"Getting Stream Data"];
    BOOL success = [delegate.webData synchStreams];
    
    if(success){
        [textOut setText:@"Sync Complete."];
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Sync Complete"
                                                         message:@"Congratulations, Sync Complete"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        
    }
    else{
        [textOut setText:@"Sync Failed.\nCheck Network Connection."];
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

- (void) threadStartAnimating:(id)data {
   [activity startAnimating];
}

- (void) threadStopAnimating:(id)data {
    [activity stopAnimating];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)getLabel {
    return textOut;
}
@end
