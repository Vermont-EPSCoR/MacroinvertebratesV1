//
//  MacroTableViewController.h
//  searchbar
//
//  Created by mmai on 11/27/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MacroListCell.h"
#import "Invertebrate.h"
#import "Stream.h"
#import "macroinvAppDelegate.h"

@interface MacroTableViewController : UITableViewController

@property macroinvAppDelegate *delegate;

@property Stream *stream;

@property NSMutableArray *allBugs;
@property Invertebrate *bugA;
@property Invertebrate *bugB;

@end
