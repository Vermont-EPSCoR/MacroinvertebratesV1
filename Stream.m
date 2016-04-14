//
//  Stream.m
//  Scrape Test
//
//  Created by Jeremy Gould on 11/25/13.
//  Copyright (c) 2013 edu.self. All rights reserved.
//

#import "Stream.h"

@implementation Stream

@synthesize title;
@synthesize latitude;
@synthesize longitude;
@synthesize stateOrProvince;
@synthesize country;


// Constructor with no arguments
/*-(id) init{
    self = [super init];
    if (self){
        title = Nil;
        latitude = Nil;
        longitude = Nil;
        stateOrProvince = Nil;
        country = Nil;
        
    }
    return self;
}*/


- (NSString *) toString{
    
    NSString *s = [NSString stringWithFormat:@"TITLE = %@\nLATITUDE = %@\nLONGITUDE = %@\nSTATE OR PROVINCE = %@\nCOUNTRY = %@\n",title, latitude, longitude, stateOrProvince, country];
    return s;
    
}
@end
