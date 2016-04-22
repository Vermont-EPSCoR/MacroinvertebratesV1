//
//  AboutViewController.m
//  searchbar
//
//  Created by pclemins on 08/18/14.
//  Copyright (c) 2014 pclemins. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@end

@implementation AboutViewController

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) { // if iOS 7
        self.edgesForExtendedLayout = UIRectEdgeNone; //layout adjustements
    }
    
    // Tags are integers? Really?
    UITextView *label = [self.view viewWithTag:1];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *aboutContent = [userDefaults stringForKey:@"about"];
    
    // Protect against the content not being set
    if([aboutContent length] > 0) {
        label.text = aboutContent;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
