#import "DataHelper.h"

@implementation NSData (OSXBoilerplateAdditions)

- (NSString*)osb_hexString {
	NSMutableString *str = [NSMutableString stringWithCapacity:64];
	NSUInteger length = [self length];
	char *bytes = malloc(sizeof(char) * length);
	
	[self getBytes:bytes length:length];
	
	int i = 0;
	
	for (; i < length; i++) {
		[str appendFormat:@"%02.2hhx", bytes[i]];
	}
	free(bytes);
	
	return str;
}

@end

@implementation NSData (DeprecatedOSXBoilerplateAdditions)

- (NSString*)hexString {
   return [self osb_hexString];
}

@end
