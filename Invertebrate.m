//
//  Invertebrate.m
//  StreamTable
//
//  Created by Lara Nargozian on 10/30/13.
//  Copyright (c) 2013 Lara Nargozian. All rights reserved.
//

#import "Invertebrate.h"

@implementation Invertebrate

@synthesize name;
@synthesize genus;
@synthesize family;
@synthesize order;
@synthesize text;
@synthesize imageFile;
@synthesize imageRevDate;
// newer additions
@synthesize commonName;
@synthesize flyName;

// Constructor with no arguments
-(id) init{
    self = [super init];
    if (self){
        name = Nil;
        genus = Nil;
        family = Nil;
        order = Nil;
        text = Nil;
        imageFile = Nil;
        commonName = Nil;
        flyName = Nil;
        
    }
    return self;
}

- (NSString *) toString{
    
    NSString *s = [NSString stringWithFormat:@"NAME = %@\nGENUS = %@\nFAMILY = %@\nORDER = %@\nTEXT = %@\n",name,genus,family,order,text];
    return s;
    
}




@end
