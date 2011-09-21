// 
// Copyright (c) 2011 Christian Kienle
//
// Offers an application specific Core Data stack - based on the default Xcode 4 template.
// This class helps to cleanup the application delegate.
// 


#import <Foundation/Foundation.h>

@interface OSBApplicationCoreDataStack : NSObject

#pragma mark Properties
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
