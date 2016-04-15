//
//  StreamViewController.h
//  searchbar
//
//  Created by mmai on 11/12/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macroinvAppDelegate.h"
#import "MacroTableViewController.h"

@interface StreamViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@property macroinvAppDelegate * delegate;

//@property (strong,nonatomic) NSMutableArray *streamArray;
@property (strong,nonatomic) NSArray *streamArray;

@property (strong, nonatomic) NSMutableArray *filteredArray;
@property IBOutlet UISearchBar *searchBar;


@end
