//
//  Invertebrate.h
//  StreamTable
//
//  Created by Lara Nargozian on 10/30/13.
//  Copyright (c) 2013 Lara Nargozian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Invertebrate : NSObject

@property NSString *name;
@property NSString *genus;
@property NSString *family;
@property NSString *order;
@property NSString *text;
@property NSString *imageFile;
@property NSString *imageRevDate;

// newer additions
@property NSString *commonName;
@property NSString *flyName;

- (NSString *) toString;


@end
