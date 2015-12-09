//
//  GpsOrLocationViewController.m
//  searchbar
//
//  Created by mmai on 12/6/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//

#import "GpsOrLocationViewController.h"

@interface GpsOrLocationViewController ()

@end

@implementation GpsOrLocationViewController

@synthesize locationPicker;
@synthesize locationArray;

@synthesize delegate;


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"locationSegue"]) {
        NSInteger row = [locationPicker selectedRowInComponent:0];
        NSString * str = [locationArray objectAtIndex:row];
        //NSLog(str);
        StreamViewController *destViewController = segue.destinationViewController;
        
        if (row == 0){
            destViewController.streamArray = [delegate.webData getAllStreams];
           
        }else{
            destViewController.streamArray = [delegate.webData getAllStreamsByLocation: str];
        }
    }
}



// returns the number of 'columns' to display.

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
    
}

// returns the # of rows in each component..

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component{
    return [locationArray count];
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
    
    // Do any additional setup after loading the view, typically from a nib.
    delegate = (macroinvAppDelegate *) [[UIApplication sharedApplication] delegate]; // to refer to AppDelegate methods
    
    //self.locationArray  = [[NSArray alloc]         initWithObjects:@"Any", @"Vermont", @"New York", @"Puerto Rico" , nil];
    self.locationArray = delegate.webData.getAllStates;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.locationArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    //self.locationPicker.text = [locationArray objectAtIndex:row];
}




@end
