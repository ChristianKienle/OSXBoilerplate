//
// Copyright (c) 2011 Christian Kienle
//
// Based on the default Xcode project template.
//

#import <Cocoa/Cocoa.h>
#import "OSBImageManagerDelegate.h"

@interface OSBAppDelegate : NSObject <NSApplicationDelegate, OSBImageManagerDelegate>

#pragma mark Properties
@property (assign) IBOutlet NSWindow *window;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

#pragma mark Actions
- (IBAction)saveAction:(id)sender;

@end
