//
//  SynchViewController.h
//  searchbar
//
//  Created by Jeremy Gould on 12/8/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macroinvAppDelegate.h"

@interface SynchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UILabel *textOut;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property macroinvAppDelegate * delegate;

- (void) triggerSynch;
- (UILabel *) getLabel;

@end
