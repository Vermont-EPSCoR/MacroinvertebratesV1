//
//  InvertebrateData.h
//  searchbar
//
//  Created by Jeremy Gould on 12/8/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StreamData;

@interface InvertebrateData : NSManagedObject

@property (nonatomic, retain) NSString * family;
@property (nonatomic, retain) NSString * genus;
@property (nonatomic, retain) NSString * imageFile;
@property (nonatomic, retain) NSDate * imageRevDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * order;
@property (nonatomic, retain) NSString * text;

// new additions
@property (nonatomic, retain) NSString * commonName;
@property (nonatomic, retain) NSString * flyName;


@property (nonatomic, retain) NSSet *livesIn;
@end

@interface InvertebrateData (CoreDataGeneratedAccessors)

- (void)addLivesInObject:(StreamData *)value;
- (void)removeLivesInObject:(StreamData *)value;
- (void)addLivesIn:(NSSet *)values;
- (void)removeLivesIn:(NSSet *)values;

@end
