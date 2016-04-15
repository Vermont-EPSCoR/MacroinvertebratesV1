//
//  DetailsViewController.h
//  searchbar
//
//  Created by mmai on 11/27/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macroinvAppDelegate.h"
#import "Invertebrate.h"
#import "InvertebrateData.h"

@interface DetailsViewController : UIViewController

@property macroinvAppDelegate * delegate;

@property InvertebrateData *bug;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *invertebrateImage;
@property (weak, nonatomic) IBOutlet UILabel *nameOfBug;

@end
