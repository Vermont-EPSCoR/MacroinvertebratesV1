//
//  SyncV3tvc.h
//  
//
//  Created by Bijay Koirala on 11/28/15.
//
//

#import <UIKit/UIKit.h>
#import "macroinvAppDelegate.h"

@interface SyncV3tvc : UITableViewController

@property macroinvAppDelegate * delegate;
@property (nonatomic, retain) NSMutableArray *streamsArray;
@property (nonatomic, retain) NSMutableArray *selectionsArray;
@property (nonatomic, strong) IBOutlet UILabel *restId;
@property (nonatomic, strong) IBOutlet UILabel *restContent;
@property (nonatomic, strong) NSMutableArray *defaultsSelectionsArray;

@end
