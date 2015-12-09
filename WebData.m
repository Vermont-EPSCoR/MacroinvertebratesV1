//
//  WebData.m
//  Scrape Test
//
//  Created by Jeremy Gould on 11/25/13.
//  Copyright (c) 2013 edu.self. All rights reserved.
//

#import "WebData.h"
#import "UIImage+Resize.h"

@implementation WebData


@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;
@synthesize feedbackLabel;




// Constructor with no arguments
- (id) initWithContext: (NSManagedObjectContext *) cxt{
    self = [super init];
    if (self){
        managedObjectContext = cxt;
    }
    return self;
}

/* ====================================================
setFeedbackLabel - pjc
 
 ====================================================

- (void) setFeedbackLabel:(UILabel *)feedbackLabelIn {
    feedbackLabel = feedbackLabelIn;
}
 */

/* ====================================================
 getFeedbackLabel
 
 ====================================================

- (UILabel *) getFeedbackLabel {
    return feedbackLabel;
}
  */

/* ====================================================
 getStreamWeb
 
 ====================================================
 */

- (Stream *) getStreamWeb:(NSString *) stream{
    Stream * result;
    NSString *url = [NSString stringWithFormat:@"http://wikieducator.org/index.php?title=%@&action=raw", stream];
    NSURL *urlRequest = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData* data = [NSData dataWithContentsOfURL:
                    urlRequest];
    
    NSString *streamString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //////NSLog(streamString);
    
    NSMutableArray * mstr = [NSMutableArray arrayWithArray: [streamString componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"{}|"]]];
    
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] '='"];
    [mstr filterUsingPredicate:sPredicate];
    
    result = [[Stream alloc] init];
    
    NSArray * prop;
    NSString * label;
    NSString * value;
    for (NSString * object in mstr) {
        prop = [object componentsSeparatedByString:@"="];
        //////NSLog([prop componentsJoinedByString:@"&\n"]);
        if ([prop count] > 1) {
            label = [prop objectAtIndex:0];
            value = [prop objectAtIndex:1];
            if ([label isEqualToString:@"Stream "] && (label != nil)) {
                result.title = value;
            }
            else if ([label isEqualToString:@"Latitude "]) {
                result.latitude = value;
            }
            else if ([label isEqualToString:@"Longitude "]) {
                result.longitude = value;
            }
            else if ([label isEqualToString:@"State or Province"]) {
                result.stateOrProvince = value;
            }
            else if ([label isEqualToString:@"Country "]) {
                result.country = value;
            }
        }
    } // end iteration through mstr
    
    //////NSLog([result toString]);
    
    return result;
}




/* ====================================================
    getBugWeb
 
 ====================================================
 */

- (Invertebrate *) getBugWeb:(NSString *) bug{
    Invertebrate * result;
    NSString *url = [NSString stringWithFormat:@"http://wikieducator.org/index.php?title=%@&action=raw", bug];
    NSURL *urlRequest = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData* data = [NSData dataWithContentsOfURL:
                    urlRequest];
    
    NSString *bugString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSMutableArray * mstr = [NSMutableArray arrayWithArray: [bugString componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"{}|"]]];
    
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] '='"];
    [mstr filterUsingPredicate:sPredicate];
    
    result = [[Invertebrate alloc] init];
    
    NSArray * prop;
    NSString * label;
    NSString * value;
    for (NSString * object in mstr) {
        prop = [object componentsSeparatedByString:@"="];
        if ([prop count] > 1) {
            ////////NSLog([prop objectAtIndex:0]);
            ////////NSLog([prop objectAtIndex:1]);
            label = [prop objectAtIndex:0];
            value = [prop objectAtIndex:1];
            if ([label isEqualToString:@"name"]) {
                ////////NSLog(@"NAMED");
                result.name = value;
            }
            else if ([label isEqualToString:@"order"]) {
                ////////NSLog(@"ORDERED");
                result.order = value;
            }
            else if ([label isEqualToString:@"family"]) {
                ////////NSLog(@"FAMILIED");
                result.family = value;
            }
            else if ([label isEqualToString:@"genus"]) {
                ////////NSLog(@"GENUSED");
                result.genus = value;
            }
            else if ([label isEqualToString:@"image"]) {
                ////////NSLog(@"GENUSED");
                result.imageFile = value;
            }
            
            // new additions Bijay
            else if ([label isEqualToString:@"common name"]) {
                result.commonName = value;
            }
            else if ([label isEqualToString:@"tied fly"]) {
                result.flyName = value;
            }
            
            
            else if ([label isEqualToString:@"text"]) {
                ////////NSLog(@"TEXTED");
                value = [value stringByReplacingOccurrencesOfString:@"[" withString:@""];
                value = [value stringByReplacingOccurrencesOfString:@"]" withString:@""];
                result.text = value;
                
                // Bijay: added this to accomodate stop signs
                if ([value rangeOfString:@"<!--Stop-->"].location == NSNotFound) {
                    result.text = value;
                    
                } else {
                    NSArray *arrayWithTwoStrings = [value componentsSeparatedByString:@"<!--Stop-->"];
                    result.text = [arrayWithTwoStrings objectAtIndex:0];
                    NSLog([arrayWithTwoStrings objectAtIndex:0]);
                }
                
                
            }
        }
    } // end iteration through mstr

    return result;
}


/* ====================================================
 getAllBugsWeb
 
 ====================================================
 */

- (NSArray *) getAllBugsWeb{
    NSArray * results;
    NSMutableArray * intermediateResults = [[NSMutableArray alloc] init];
    
    NSString *url = @"http://wikieducator.org/api.php?action=query&list=categorymembers&cmtitle=Category:Aquatic%20Invertebrate&cmlimit=500&format=json&cmprop=ids%7Ctitle";
    NSURL *urlRequest = [NSURL URLWithString:url];
    NSError *err = nil;
    NSData* data = [NSData dataWithContentsOfURL:
                    urlRequest];
    
    //pjc - Fail gracefully
    if(data == nil)
        return nil;
    
    NSDictionary *bugs = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&err];
    if(err)
    {
        //Handle
    }
    
    // Intemediate steps to get inside nested dictionary
    NSDictionary * bugs1 = [bugs objectForKey:(@"query")];
    NSArray * bugs2 = [bugs1 objectForKey:(@"categorymembers")];
    
    NSDictionary *currentBug;
    NSString * currentName;
    Invertebrate * currentInvertebrate;
    for (int i = 0; i < [bugs2 count]; i++) {
        currentBug = [bugs2 objectAtIndex:i];
        //////NSLog([currentBug description]);
        currentName = [currentBug objectForKey:@"title"];
        //////NSLog(currentName);
        if (currentName != nil){
            currentInvertebrate = [self getBugWeb:currentName];
            if (currentInvertebrate != nil){
                [intermediateResults addObject:currentInvertebrate];
            }
        }
    }
    results = [NSArray arrayWithArray:intermediateResults];
    
    return results;
    
}

/* ====================================================
    getAllStreamsWeb
 
    ====================================================
*/

- (NSArray *) getAllStreamsWeb{
    NSArray * results;
    NSMutableArray * intermediateResults = [[NSMutableArray alloc] init];
    
    NSString *url = @"http://wikieducator.org/api.php?action=query&list=categorymembers&cmtitle=Category:Stream&cmlimit=500&format=json&cmprop=ids%7Ctitle";
    NSURL *urlRequest = [NSURL URLWithString:url];
    NSError *err = nil;
    NSData* data = [NSData dataWithContentsOfURL:
                    urlRequest];
    
    //pjc - Fail gracefully
    if(data == nil)
        return nil;
    
    NSDictionary *streams = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&err];
    if(err)
    {
        //Handle
    }
    
    // Intemediate steps to get inside nested dictionary
    NSDictionary * streams1 = [streams objectForKey:(@"query")];
    NSArray * streams2 = [streams1 objectForKey:(@"categorymembers")];
    
    NSDictionary *currentStreamDictionary;
    NSString * currentName;
    // TODO point 1
    Stream * currentStream;
    for (int i = 0; i < [streams2 count]; i++) {
        currentStreamDictionary = [streams2 objectAtIndex:i];
        //////NSLog([currentBug description]);
        currentName = [currentStreamDictionary objectForKey:@"title"];
        //////NSLog(currentName);
        if (currentName != nil){
            currentStream = [self getStreamWeb:currentName];
            if (currentStream != nil){
                [intermediateResults addObject:currentStream];
            }
        }
    }
    results = [NSArray arrayWithArray:intermediateResults];
    
    return results;
    
}
//*****************************************************************************
//*****************************************************************************

//  CORE DATA STUFF

//*****************************************************************************
//*****************************************************************************
/* 
 ====================================================
 synchBugs
 
 ====================================================
 */
- (void) synchBugs
{
    //[aiv startAnimating];
    //label.text = @"Connecting to Server...";
    
    // Check and conditionally add initial object to database
    NSManagedObjectContext *context = [self managedObjectContext];
    // pull object context
    
    
    if (context != nil){
        [self clearBugs];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; //2
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"InvertebrateData"        inManagedObjectContext:context];  //3
        [fetchRequest setEntity:entity]; //4
        NSError *error; 
    
        NSArray *bugs = [self getAllBugsWeb];
       //pjc - Fail gracefully
        if(bugs == nil)
            return;
    
        InvertebrateData *bug;
        int i=0;
 
        for (Invertebrate *thisBug in bugs) {
 
            if ((thisBug.name != NULL) && ! [self myIsNil:thisBug.name]){
                bug = [NSEntityDescription
                       insertNewObjectForEntityForName:@"InvertebrateData"
                       inManagedObjectContext:context];
        
                bug.name = [self myStripper:thisBug.name];
                //label.text = [NSString stringWithFormat:@"Reading %@ files...",bug.name];
                bug.genus = thisBug.genus;
                bug.family = thisBug.family;
                bug.order = thisBug.order;
                bug.text = thisBug.text;
                bug.imageFile = thisBug.imageFile;
                
                // new additions bijay
                bug.commonName = thisBug.commonName;
                bug.flyName = thisBug.flyName;
                
                //pjc added release pool
                @autoreleasepool {
                    ////NSLog(thisBug.imageFile);
                    // Download bug image
                    i++;
                    //[feedbackLabel setText:[NSString stringWithFormat:@"Downloading Image %d of %d",i,bugs.count]];
                    UIImage *img = [self getImageWeb:[thisBug.imageFile stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
                    //NSLog([img description]);
                    if (img!= nil){
                        NSString *s = [thisBug.imageFile stringByReplacingOccurrencesOfString:@"File:" withString:@""];
                        NSArray * se = [s componentsSeparatedByString:@"."];
                        if ([se count] > 1){
                            //pjc - debug image size, and duplicates - fix - make this a second thread
                            NSLog(@"Saving %@ -- size: %0.0f, %0.0f -- %d of %d", s, [img size].height, [img size].width, i, bugs.count);
                            [self saveImage:img withFileName:[se objectAtIndex:0] ofType:[se objectAtIndex:1]];
                        }
                    }
                } // end autoreleasepool
    
                
            }// end of outer if
            
        }// end of for loop
  
    
        if (![context save:&error]) {
            NSLog(@"Error Saving Invertebrate Data: %@", [error localizedDescription]);
        }
    }
}
/*
 ====================================================
 synchStreams
 
 ====================================================
 */
- (BOOL) synchStreams
{
    // Check and conditionally add initial object to database
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context != nil){
        [self clearStreams];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"StreamData"        inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error;
        
        // TODO point 2
        NSArray *streams = [self getAllStreamsWeb];
        
        //pjc - Fail gracefully
        if(streams == nil)
            return false;
        
        StreamData * stream;
        NSArray * inhabitants;
        
        for (Stream * thisStream in streams) {
            
            if ((thisStream.title != NULL) && ! [self myIsNil:thisStream.title] &&
                ! [thisStream.title isEqualToString:@" "]){
                stream = [NSEntityDescription
                       insertNewObjectForEntityForName:@"StreamData"
                       inManagedObjectContext:context];
                
                //////NSLog(thisStream.title);
                stream.title = [self myStripper:thisStream.title];
                //label.text = [NSString stringWithFormat:@"Reading %@ files...",stream.title];
                stream.country = [self myStripper:thisStream.country];
                //NSLog(thisStream.stateOrProvince);
                stream.stateOrProvince = [self myStripper:thisStream.stateOrProvince];
                stream.latitude = [self myStripper:thisStream.latitude];
                stream.longitude = [self myStripper:thisStream.longitude];
                //NSLog(stream.stateOrProvince);
                
                //inhabitants = [NSSet setWithArray:[self getPopulationWeb:thisStream.title]];;
                //Download inhabitants for each stream
                inhabitants = [self getPopulationWeb:thisStream.title];
                //NSMutableArray * result = [[NSMutableArray alloc] init];
                InvertebrateData * inv;
                for (NSString * n in inhabitants){
                    inv = [self getBugData:n];
                    if (inv != nil){
                        //[result addObject:(Invertebrate*)inv];
                        [stream addContainsObject:inv];
                    } else {
                        NSLog(@"No data found for inhabitant %@ in stream %@!", [n description], stream.title);
                    }
                }
                
                //pjc - Debug stream inhabitants
                //NSLog(@"%@", [thisStream.title description]);
                //NSLog(@"%@", [inhabitants description]);
                
                /*
                if(inhabitants.count==0)
                    NSLog(@"%@ has no inhabitants!", [thisStream.title description]);
                */
                
                //NSLog([result description]);
                //stream.contains = [NSSet setWithArray:result];
            }
        }
        
        if (![context save:&error]) {
            NSLog(@"Error Saving Stream Data: %@", [error localizedDescription]);
        }
    }
    //label.text = @"Synch Complete.";
    //[aiv stopAnimating];
    return true;
}
/* 
 ====================================================
 getAllBugs
 
 ====================================================
 */
- (NSArray *) getAllBugs{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                               entityForName:@"InvertebrateData" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;

    NSArray *allBugs = [context executeFetchRequest:fetchRequest error:&error];

    return allBugs;
    
}
/*
 ====================================================
 getAllStreams
 
 ====================================================
 */
- (NSArray *) getAllStreams{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"StreamData" inManagedObjectContext:context];
    //fetchRequest.returnsDistinctResults = YES;
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSArray *allStreams = [context executeFetchRequest:fetchRequest error:&error];
    
    //pjc - Fix - Alphabetize Array
    /*
     NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES comparator:^NSComparisonResult(StreamData obj1, StreamData obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
    }];
    */
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    return [allStreams sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    //return allStreams;
    
}
/*
====================================================
getAllStreamsByLocation

====================================================
*/
- (NSArray *) getAllStreamsByLocation: (NSString *) location{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"StreamData" inManagedObjectContext:context];
    //NSString *str = [NSString stringWithFormat:@"(country == '%@') OR (stateOrProvince == '%@')", location, location];
    NSString *str = [NSString stringWithFormat:@"stateOrProvince == ' %@'", location];
   // NSLog(str);
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:str]];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *allStreams = [context executeFetchRequest:fetchRequest error:&error];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    return [allStreams sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    //NSLog([allStreams description]);
    //return allStreams;
    
}
/*
 ====================================================
 getBug
 
 ====================================================
 */
- (Invertebrate *) getBug:(NSString *) bug{
    
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"InvertebrateData" inManagedObjectContext:context];
    NSString *str = [NSString stringWithFormat:@"name == '%@'", bug];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:str]];
    NSError *error;
    
    NSArray *bugData = [context executeFetchRequest:fetchRequest error:&error];
    
    
    if ([bugData count] > 0){
        Invertebrate * matchingBug = [[Invertebrate alloc] init];
        InvertebrateData * matchingRecord = [bugData objectAtIndex:0]; // always return first match
    
        matchingBug.name = matchingRecord.name;
        matchingBug.genus = matchingRecord.genus;
        matchingBug.family = matchingRecord.family;
        matchingBug.order = matchingRecord.order;
        matchingBug.text = matchingRecord.text;
        matchingBug.imageFile = matchingRecord.imageFile;
        matchingBug.imageRevDate = matchingRecord.imageRevDate;
        
        // new additions
        matchingBug.commonName = matchingRecord.commonName;
        matchingBug.flyName = matchingRecord.flyName;
    
        return matchingBug;
    }
    else{
        return nil;
    }
    
    
    
}
/*
 ====================================================
 getBugData
 
 ====================================================
 */
- (InvertebrateData *) getBugData:(NSString *) bug{
    
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"InvertebrateData" inManagedObjectContext:context];
    NSString *str = [NSString stringWithFormat:@"name == '%@'", bug];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:str]];
    NSError *error;
    
    NSArray *bugData = [context executeFetchRequest:fetchRequest error:&error];
    
    
    if ([bugData count] > 0){
        InvertebrateData * matchingRecord = [bugData objectAtIndex:0]; // always return first match
        return matchingRecord;
    }
    else{
        return nil;
    }
    
    
    
}
/*
 ====================================================
 getStream
 
 ====================================================
 */
- (Stream *) getStream:(NSString *) stream{
    
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"StreamData" inManagedObjectContext:context];
    NSString *str = [NSString stringWithFormat:@"title == %@", stream];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:str]];
    NSError *error;
    
    NSArray *streamData = [context executeFetchRequest:fetchRequest error:&error];
    
    
    Stream * matchingStream = [[Stream alloc] init];
    StreamData * matchingRecord = [streamData objectAtIndex:0]; // always return first match
    
    matchingStream.title = matchingRecord.title;
    matchingStream.country = matchingRecord.country;
    matchingStream.stateOrProvince = matchingRecord.stateOrProvince;
    matchingStream.latitude = matchingRecord.latitude;
    matchingStream.longitude = matchingRecord.longitude;
    
    
    return matchingStream;
    
}
/*
 ====================================================
 clearBugs
 
 ====================================================
 */
-(void) clearBugs{
    NSFetchRequest * allBugs = [[NSFetchRequest alloc] init];
    [allBugs setEntity:[NSEntityDescription entityForName:@"InvertebrateData" inManagedObjectContext:managedObjectContext]];
    [allBugs setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError * error = nil;
    NSArray * bugs = [managedObjectContext executeFetchRequest:allBugs error:&error];
    
    for (NSManagedObject * bug in bugs) {
        [managedObjectContext deleteObject:bug];
    }
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    //more error handling here
}
/*
 ====================================================
 clearStreams
 
 ====================================================
 */
-(void) clearStreams{
    NSFetchRequest * allStreams = [[NSFetchRequest alloc] init];
    [allStreams setEntity:[NSEntityDescription entityForName:@"StreamData" inManagedObjectContext:managedObjectContext]];
    [allStreams setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * streams = [managedObjectContext executeFetchRequest:allStreams error:&error];
    
    for (NSManagedObject * stream in streams) {
        [managedObjectContext deleteObject:stream];
    }
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    //more error handling here
}
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
/*
====================================================
getPopulationWeb

====================================================
*/
-(NSArray *) getPopulationWeb: (NSString *) stream{
    // Working - pjc
    // Downloads data for stream from web using API and creates NSMutatable array of strings with all of the templates associated with stream.  Format is Acroneuria, Anotcha, etc., WITHOUT the preceeding "Template:"
    
    NSString *url = [NSString stringWithFormat:@"http://wikieducator.org/api.php?action=query&prop=templates&titles=%@&tllimit=40&format=json", [self myStripper:stream]];
    NSURL *urlRequest = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData* data = [NSData dataWithContentsOfURL:
                    urlRequest];
    
    NSString *streamString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //////NSLog(streamString);
    
    NSMutableArray * mstr = [NSMutableArray arrayWithArray: [streamString componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"\""]]];
    
    
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] 'Template:'"];
    [mstr filterUsingPredicate:sPredicate];
    NSMutableArray * mstr1 = [[NSMutableArray alloc] init];
    NSString * sr;
    //////NSLog([mstr description]);
    for (NSString * s in mstr){
        sr = [s stringByReplacingOccurrencesOfString:@"Template:" withString:@""];
        sr = [self myStripper:sr];
        // Exclude default templates - pjc
        if(!([sr isEqualToString:@"Infobox stream"] || [sr isEqualToString:@"InsectSection"] ||
           [sr isEqualToString:@"OrderFamilyGenus"] || [sr isEqualToString:@"ProjectNav"] ||
           [sr isEqualToString:@"Rivers\\/ProjectNav"] || [sr isEqualToString:@"Vbar"]))
        [mstr1 addObject:sr];
    }
    //////NSLog([mstr1 description]);
    return mstr1;
}
/*
====================================================
getPopulation

====================================================
*/
-(NSArray *) getPopulation: (NSString *) stream{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"StreamData" inManagedObjectContext:context];
    NSString *str = [NSString stringWithFormat:@"title == '%@'", [self myStripper:stream]];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:str]];
    NSError *error;
    
    NSArray *streamData = [context executeFetchRequest:fetchRequest error:&error];
    
    StreamData * matchingRecord = [streamData objectAtIndex:0]; // always return first match
    return [matchingRecord.contains allObjects];
    
}

/*
 ====================================================
 myIsNil
 
 ====================================================
 */
-(BOOL) myIsNil: (NSString *) str{
    str = [self myStripper:str];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [str isEqualToString:@""];
}

/*
 ====================================================
 myStripper
 
 ====================================================
 */
-(NSString *) myStripper: (NSString *) str{
    //str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
   // str = [str stringByReplacingOccurrencesOfString:@"'" withString:@""];
    return str;
}
/*
 ====================================================
 getImageWeb
 
 ====================================================
 */
-(UIImage *) getImageWeb:(NSString *) file {
    //pjc - large images gumming up works, but now fixed
    /*
    if([[self myStripper:file] isEqualToString:@"File:Aeshna_cyanea_Nymph.jpg"] ||
       [[self myStripper:file] isEqualToString:@"file:Phylocentropus_larva.jpg"] ||
       [[self myStripper:file] isEqualToString:@"File:Valvata_2_species.jpg"])
        file = @"File:Acroneuria_cover.jpg";
    NSLog(@"'%@'", file);
    */
    
    // OLD FILE ALL WORKING!!! BIJAY IMP
    //NSString *url = [NSString stringWithFormat:@"http://wikieducator.org/api.php?action=query&prop=imageinfo&iiprop=url&format=json&titles=%@", file];
    
    // The awesome new 400 px images
    NSString *url = [NSString stringWithFormat:@"http://wikieducator.org/api.php?action=query&iiurlwidth=400&prop=imageinfo&iiprop=url&format=json&titles=%@", file];
    NSLog(@"File %@ : and URL %@", file, url);
    NSURL *urlRequest = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //NSURL *urlRequest = [NSURL URLWithString:url];
   ////NSLog([[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] description]);
    NSData* data = [NSData dataWithContentsOfURL:
                    urlRequest];

    ////NSLog([data description]);
    NSString *bugString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ////NSLog(bugString);

    NSMutableArray * mstr = [NSMutableArray arrayWithArray: [bugString componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"\""]]];
    ////NSLog([mstr description]);

    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF contains[c] 'File:')"];
    [mstr filterUsingPredicate:sPredicate];
    sPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] 'http'"];
    [mstr filterUsingPredicate:sPredicate];
    ////NSLog([mstr description]);
    if ([mstr count] > 0){
        NSString *url1 = [mstr objectAtIndex:0];
        url1 = [url1 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        //NSLog(url1);
        UIImage * result;
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url1]];
        result = [UIImage imageWithData:data];
        
        //pjc
        //data=nil;
        
        return result;
    }
    else{
        return nil;
    }
}

/*
 ====================================================
 saveImage
 
 ====================================================
 */
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension{
    //NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *resourcePath = [arrayPaths objectAtIndex:0];
    
    //NSLog(@"%@",resourcePath);
    
    extension = [self myStripper:extension];
    imageName = [self myStripper:imageName];
    
    //pjc - Replace _ & " "
    imageName = [imageName stringByReplacingOccurrencesOfString:@"_" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@" " withString:@""];
   
    extension = [extension lowercaseString];
    extension = [extension stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSLog(@"saveImage:%@.%@:",imageName,extension);
    
    //pjc - Resizing Code
    /*
    if([image size].height > 480 || [image size].width < 640) {
        NSLog(@"Old size: %f, %f", [image size].width, [image size].height);
        image = [image resizedImage:CGSizeMake(640,480) interpolationQuality:kCGInterpolationMedium];
        NSLog(@"New size: %f, %f", [image size].width, [image size].height);
    }
     */
    
    //pjc - Capture and print errors during file access
    NSError* writeError=nil;
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/bugImages/", resourcePath]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/bugImages/", resourcePath] withIntermediateDirectories:NO
                                   attributes:nil
                                   error:&writeError];
        if(writeError != nil)
            NSLog(@"Error creating directory: %@",writeError);
    }
    
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"bugImages/%@.%@", imageName, @"png"]] options:NSDataWritingAtomic error:&writeError];
    } else if ([extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"bugImages/%@.%@", imageName, extension]] options:NSDataWritingAtomic error:&writeError];
    } else {
        //NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
    if(writeError != nil)
        NSLog(@"Error writing image %@ to file: %@",imageName, writeError);
}
/*
 ====================================================
 loadImage
 
 ====================================================
 */
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension{
    extension = [self myStripper:extension];
    fileName = [self myStripper:fileName];
    
    //pjc - Replace _ with spaces
    fileName = [fileName stringByReplacingOccurrencesOfString:@"_" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    extension = [extension lowercaseString];
    extension = [extension stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //NSLog(@"loadImage:%@.%@:",fileName,extension);
    
    //pjc - replaced bad resource path
    //NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *resourcePath = [arrayPaths objectAtIndex:0];

    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/bugImages/%@.%@", resourcePath, fileName, extension]];
    
    return result;
}


- (void) selectiveSync:(NSArray *)particularStream
{
    NSManagedObjectContext *context = [self managedObjectContext];
    if (context != nil){
        //[self clearBugs];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; //2
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"InvertebrateData"        inManagedObjectContext:context];  //3
        [fetchRequest setEntity:entity]; //4
        NSError *error;
        
        NSArray *bugs = [self getSelectiveBugsWeb: particularStream];
        //pjc - Fail gracefully
        if(bugs == nil)
            return;
        
        InvertebrateData *bug;
        int i=0;
        
        for (Invertebrate *thisBug in bugs) {
            
            if ((thisBug.name != NULL) && ! [self myIsNil:thisBug.name]){
                bug = [NSEntityDescription
                       insertNewObjectForEntityForName:@"InvertebrateData"
                       inManagedObjectContext:context];
                
                bug.name = [self myStripper:thisBug.name];
                //label.text = [NSString stringWithFormat:@"Reading %@ files...",bug.name];
                bug.genus = thisBug.genus;
                bug.family = thisBug.family;
                bug.order = thisBug.order;
                bug.text = thisBug.text;
                bug.imageFile = thisBug.imageFile;
                
                // new additions bijay
                bug.commonName = thisBug.commonName;
                bug.flyName = thisBug.flyName;
                
                //pjc added release pool
                @autoreleasepool {
                    ////NSLog(thisBug.imageFile);
                    // Download bug image
                    i++;
                    //[feedbackLabel setText:[NSString stringWithFormat:@"Downloading Image %d of %d",i,bugs.count]];
                    UIImage *img = [self getImageWeb:[thisBug.imageFile stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
                    //NSLog([img description]);
                    if (img!= nil){
                        NSString *s = [thisBug.imageFile stringByReplacingOccurrencesOfString:@"File:" withString:@""];
                        NSArray * se = [s componentsSeparatedByString:@"."];
                        if ([se count] > 1){
                            //pjc - debug image size, and duplicates - fix - make this a second thread
                            NSLog(@"Saving %@ -- size: %0.0f, %0.0f -- %d of %d", s, [img size].height, [img size].width, i, bugs.count);
                            [self saveImage:img withFileName:[se objectAtIndex:0] ofType:[se objectAtIndex:1]];
                        }
                    }
                } // end autoreleasepool
                
                
            }// end of outer if
            
        }// end of for loop
        
        
        if (![context save:&error]) {
            NSLog(@"Error Saving Invertebrate Data: %@", [error localizedDescription]);
        }
    }
}

- (NSArray *) getSelectiveBugsWeb: (NSArray *) particularStream{
    NSArray * results;
    NSMutableArray * intermediateResults = [[NSMutableArray alloc] init];
    
    NSLog(@"%@", particularStream);
    NSString *currentBug;
    Invertebrate * currentInvertebrate;
    for (int i = 0; i < [particularStream count]; i++) {
        currentBug = [particularStream objectAtIndex:i];
        if (currentBug != nil){
            
            // BIJAY check if you already have that bug in your tables -> check if the text field of it is nil TODO Work pending here
            InvertebrateData *inv = [self getBugData:currentBug];
            if ([self getBugData:currentBug] == (InvertebrateData *)nil){
            NSLog(@"BUG to deal with : %@", currentBug);
            // if it is not there pull it
            currentBug = [NSString stringWithFormat:@"Template:%@", currentBug];
            currentInvertebrate = [self getBugWeb:currentBug];
            if (currentInvertebrate != nil){
                [intermediateResults addObject:currentInvertebrate];
            }
            }
            else{
                NSLog(@"The bug was already there = %@", currentBug);
            }
        }
    }
    results = [NSArray arrayWithArray:intermediateResults];
    
    return results;
}

// TODO 3
- (BOOL) getSelectedStreamsOnly:(NSString *) selectedStream{
    Stream *thisStream = [self getStreamWeb:selectedStream];
    
    // TODO put this stream inside coredata now
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; //2
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"InvertebrateData"        inManagedObjectContext:context];  //3
    [fetchRequest setEntity:entity]; //4
    NSError *error;
    
    
    StreamData * stream;
    NSArray * inhabitants;
    
        
        if ((thisStream.title != NULL) && ! [self myIsNil:thisStream.title] &&
            ! [thisStream.title isEqualToString:@" "]){
            stream = [NSEntityDescription
                      insertNewObjectForEntityForName:@"StreamData"
                      inManagedObjectContext:context];
            
            //////NSLog(thisStream.title);
            stream.title = [self myStripper:thisStream.title];
            //label.text = [NSString stringWithFormat:@"Reading %@ files...",stream.title];
            stream.country = [self myStripper:thisStream.country];
            //NSLog(thisStream.stateOrProvince);
            stream.stateOrProvince = [self myStripper:thisStream.stateOrProvince];
            stream.latitude = [self myStripper:thisStream.latitude];
            stream.longitude = [self myStripper:thisStream.longitude];
            //NSLog(stream.stateOrProvince);
            
            //inhabitants = [NSSet setWithArray:[self getPopulationWeb:thisStream.title]];;
            //Download inhabitants for each stream
            inhabitants = [self getPopulationWeb:thisStream.title];
            //NSMutableArray * result = [[NSMutableArray alloc] init];
            InvertebrateData * inv;
            for (NSString * n in inhabitants){
                inv = [self getBugData:n];
                if (inv != nil){
                    //[result addObject:(Invertebrate*)inv];
                    [stream addContainsObject:inv];
                } else {
                    NSLog(@"No data found for inhabitant %@ in stream %@!", [n description], stream.title);
                }
            }
        }
    
    
    if (![context save:&error]) {
        NSLog(@"Error Saving Stream Data: %@", [error localizedDescription]);
    }
    return true;
}

- (NSArray *) getAllStates{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"StreamData" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *data = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *allStates = [[NSMutableArray alloc]init];
    [allStates addObject:@"Any"];
    
    for (StreamData *sData in data){
        NSLog(@"DISPLAYING!!! %@",sData.stateOrProvince);
        NSString *trimmed = [sData.stateOrProvince stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [allStates addObject:trimmed];
    }
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:allStates];
    NSSet *uniqueStates = [orderedSet set];
    
    
    return [uniqueStates allObjects];

    
}


@end
