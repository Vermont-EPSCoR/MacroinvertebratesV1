//
//  WebData.h
//  Scrape Test
//
//  Created by Jeremy Gould on 11/25/13.
//  Copyright (c) 2013 edu.self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "sbAppDelegate.h"
#import "Invertebrate.h"
#import "Stream.h"
#import "InvertebrateData.h"
#import "StreamData.h"

@interface WebData : NSObject

//@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property UILabel *feedbackLabel;
@property NSDateFormatter *dateFormatter;
@property BOOL downloadInProgress;

@property NSRegularExpression *wikiStyleLink;

/*
 //pjc
- (void)setFeedbackLabel:(UILabel *) feedbackLabelIn;

- (UILabel *)getFeedbackLabel;
*/

- (id)initWithContext:(NSManagedObjectContext *) cxt;

- (NSURL *)applicationDocumentsDirectory;

- (Invertebrate *) getBugWebOld:(NSString *) bug;

- (Invertebrate *) getBugWeb:(NSString *) bug;

- (NSArray<Invertebrate *> *) getBugsWeb:(NSArray<NSString *> *) bug;

- (Invertebrate *) parseBug:(NSString *) insectSection;

- (Stream *) getStreamWeb:(NSString *) stream;

- (NSArray *) getAllStreamsWeb;

- (NSDictionary *) getStreamsWeb: (NSArray<NSString *> *) streams;

- (Stream *) parseStreamInfo:(NSString *) streamString;

- (NSArray<NSString *> *) parseStreamBugs:(NSString *) streamString;

- (BOOL) linkBugsToStreams:(NSArray<Invertebrate *> *) bugs :(NSDictionary *) streams;

- (NSArray *) getAllBugsWeb;

- (void) synchBugs;

- (BOOL) synchStreams;

- (BOOL) saveStream:(Stream *) stream;

- (BOOL) saveBug:(Invertebrate *) bug;

- (NSArray *) getAllBugs;

- (NSArray *) getAllStreams;

- (Invertebrate *) getBug: (NSString *) bug;

- (InvertebrateData *) getBugData: (NSString *) bug;

- (Stream *) getStream: (NSString *) stream;

- (StreamData *) getStreamData: (NSString *) stream;

- (void) clearBugs;

- (void) clearStreams;

- (NSArray *) getPopulationWeb: (NSString *) stream;

- (NSArray *) getPopulation:(NSString *) stream;

- (BOOL) myIsNil: (NSString *) str;

- (NSString *) myStripper: (NSString *) str;

//- (void) storeBugImageWeb:(NSString *) bugName;

//- (void) storeImagesFromURLs:(NSDictionary *) bugsAndURLs;

- (UIImage *) getImageWeb:(NSString *) file;

//- (NSDictionary*) getBugImageURLsWeb:(NSSet<NSString *> *) bugNames;

- (void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension;

- (UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension;

- (NSArray *) getAllStreamsByLocation: (NSString *) location;

- (void) selectiveSync:(NSArray *)particularStream;

- (NSArray *) getSelectiveBugsWeb: (NSArray *) particularStream;

- (BOOL) getSelectedStreamsOnly:(NSString *) selectedStreams;

- (NSArray *) getAllStates;

- (void) setLastUpdateDate;

- (NSDate *) getLastSyncDate;

- (NSMutableArray<NSDictionary*> *) getBugImageURLs:(NSSet<NSString *> *) bugNames;

- (void) saveBugImages:(NSMutableArray<NSDictionary*> *) bugImages;

- (void) syncAppAbout;

- (NSString *) fixWikiStyleLinks: (NSString *) description;

@end
