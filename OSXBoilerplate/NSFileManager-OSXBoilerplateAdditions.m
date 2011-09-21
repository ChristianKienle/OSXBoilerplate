#import "NSFileManager-OSXBoilerplateAdditions.h"
#import "NSBundle-OSXBoilerplateAdditions.h"

@implementation NSFileManager (OSXBoilerplateAdditions)

#pragma mark Properties
- (NSURL *)osb_applicationFilesDirectory {
   NSFileManager *fileManager = [NSFileManager defaultManager];
   NSURL *libraryURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
   NSString *bundleName = [[NSBundle mainBundle] osb_name];
   return [libraryURL URLByAppendingPathComponent:bundleName];
}


@end
