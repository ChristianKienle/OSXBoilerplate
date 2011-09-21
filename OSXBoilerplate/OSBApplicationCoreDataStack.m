#import "OSBApplicationCoreDataStack.h"

#import "NSBundle-OSXBoilerplateAdditions.h"
#import "NSFileManager-OSXBoilerplateAdditions.h"

@interface OSBApplicationCoreDataStack ()

#pragma mark Properties
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation OSBApplicationCoreDataStack

#pragma mark Properties

@synthesize managedObjectModel;

- (NSManagedObjectModel *)managedObjectModel {
   if(managedObjectModel) {
      return managedObjectModel;
   }
	
   NSURL *modelURL = [[NSBundle mainBundle] URLForResource:[[NSBundle mainBundle] osb_name] withExtension:@"momd"];
   self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];   
   return managedObjectModel;
}

@synthesize persistentStoreCoordinator;

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
   if(persistentStoreCoordinator) {
      return persistentStoreCoordinator;
   }
   
   NSManagedObjectModel *mom = [self managedObjectModel];
   if(!mom) {
      NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
      return nil;
   }
   
   NSFileManager *fileManager = [NSFileManager defaultManager];
   NSURL *applicationFilesDirectory = [[NSFileManager defaultManager] osb_applicationFilesDirectory];
   NSError *error = nil;
   
   NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
   
   if(!properties) {
      BOOL ok = NO;
      if([error code] == NSFileReadNoSuchFileError) {
         ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
      }
      if(!ok) {
         [[NSApplication sharedApplication] presentError:error];
         return nil;
      }
   }
   else {
      if ([[properties objectForKey:NSURLIsDirectoryKey] boolValue] != YES) {
         // Customize and localize this error.
         NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]]; 
         
         NSMutableDictionary *dict = [NSMutableDictionary dictionary];
         [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
         error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
         
         [[NSApplication sharedApplication] presentError:error];
         return nil;
      }
   }
   
   NSURL *url = [[applicationFilesDirectory URLByAppendingPathComponent:[[NSBundle mainBundle] osb_name]] URLByAppendingPathExtension:@"storedata"];
   NSNumber *yes = [NSNumber numberWithBool:YES];
   NSDictionary *storeOptions = [NSDictionary dictionaryWithObjectsAndKeys:yes, NSMigratePersistentStoresAutomaticallyOption, yes, NSInferMappingModelAutomaticallyOption, nil];

   NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
   if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:storeOptions error:&error]) {
      [[NSApplication sharedApplication] presentError:error];
      return nil;
   }
   self.persistentStoreCoordinator = coordinator;
   
   return persistentStoreCoordinator;
}

@synthesize managedObjectContext;

- (NSManagedObjectContext *)managedObjectContext {
   if (managedObjectContext) {
      return managedObjectContext;
   }
   
   NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
   if (!coordinator) {
      NSMutableDictionary *dict = [NSMutableDictionary dictionary];
      [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
      [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
      NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
      [[NSApplication sharedApplication] presentError:error];
      return nil;
   }
   self.managedObjectContext = [[NSManagedObjectContext alloc] init];
   [self.managedObjectContext setPersistentStoreCoordinator:coordinator];
   
   return managedObjectContext;
}

@end
