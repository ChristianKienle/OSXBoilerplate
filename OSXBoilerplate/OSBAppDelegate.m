#import "OSBAppDelegate.h"
#import "OSBApplicationCoreDataStack.h"

@interface OSBAppDelegate ()

#pragma mark Properties
@property (readwrite, strong, nonatomic) OSBApplicationCoreDataStack *coreDataStack;

@end


@implementation OSBAppDelegate


#pragma mark NSApplicationDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)didFinishNotification {
}

#pragma mark Creating
- (id)init {
   self = [super init];
   if(self) {
      self.coreDataStack = [[OSBApplicationCoreDataStack alloc] init];
   }
   return self;
}

#pragma mark Properties
@synthesize window, coreDataStack;

- (NSManagedObjectModel *)managedObjectModel {
   return self.coreDataStack.managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
   return self.coreDataStack.persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
   return self.coreDataStack.managedObjectContext;
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}

#pragma mark Actions
- (IBAction)saveAction:(id)sender {
    NSError *error = nil;
    
    if(![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }

    if(![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

#pragma mark NSApplicationDelegate
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.

    if(!self.managedObjectContext) {
        return NSTerminateNow;
    }

    if(![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }

    if(![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    NSError *error = nil;
    if(![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end


