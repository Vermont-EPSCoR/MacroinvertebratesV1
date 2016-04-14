//
//  SyncTableVC_New.h
//  macroinvertebrates
//
//  Created by Bijay Koirala on 11/13/15.
//  Copyright © 2015 mmai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macroinvAppDelegate.h"

@interface SyncTableVC_New : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@property macroinvAppDelegate * delegate;
@property (strong,nonatomic) NSArray *streamArray;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property IBOutlet UISearchBar *searchBar;


@end