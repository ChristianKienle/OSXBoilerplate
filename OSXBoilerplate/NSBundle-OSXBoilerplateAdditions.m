#import "NSBundle-OSXBoilerplateAdditions.h"

@implementation NSBundle (OSXBoilerplateAdditions)

#pragma mark Properties
- (NSString *)osb_name {
   return [self.infoDictionary objectForKey:(NSString *)kCFBundleNameKey];
}

@end
