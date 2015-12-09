//
//  StreamData.h
//  searchbar
//
//  Created by Jeremy Gould on 12/8/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StreamData : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * stateOrProvince;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *contains;
@end

@interface StreamData (CoreDataGeneratedAccessors)

- (void)addContainsObject:(NSManagedObject *)value;
- (void)removeContainsObject:(NSManagedObject *)value;
- (void)addContains:(NSSet *)values;
- (void)removeContains:(NSSet *)values;

@end
