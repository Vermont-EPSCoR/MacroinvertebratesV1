//
//  GpsOrLocationViewController.h
//  searchbar
//
//  Created by mmai on 12/6/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StreamViewController.h"
#import "macroinvAppDelegate.h"

@interface GpsOrLocationViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;

@property NSArray * locationArray;

@property macroinvAppDelegate * delegate;

@end
