//
//  sbAppDelegate.h
//  searchbar
//
//  Created by mmai on 11/12/13.
//  Copyright (c) 2013 mmai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebData.h"

@interface macroinvAppDelegate : UIResponder <UIApplicationDelegate>


@property WebData * webData;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;




- (NSString *)applicationDocumentsDirectory;



- (void)saveContext;

@end
