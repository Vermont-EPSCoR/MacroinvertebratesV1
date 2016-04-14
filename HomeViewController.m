//
//  HomeViewController.m
//  searchbar
//
//  Created by mmai on 12/1/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//

#import "HomeViewController.h"
#import "SyncV3tvc.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize delegate;

-(IBAction)exit{
    exit(0);
    
}

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
//    delegate = (macroinvAppDelegate *) [[UIApplication sharedApplication] delegate];
//    [SyncV3tvc get
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
