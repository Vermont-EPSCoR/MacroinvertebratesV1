//
//  Stream.h
//  Scrape Test
//
//  Created by Jeremy Gould on 11/25/13.
//  Copyright (c) 2013 edu.self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stream : NSObject

@property NSString *title;
@property NSString *latitude;
@property NSString *longitude;
@property NSString *stateOrProvince;
@property NSString *country;


- (NSString *) toString;
@end
