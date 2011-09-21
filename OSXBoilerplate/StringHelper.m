#import "StringHelper.h"
#import "DataHelper.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (OSXBoilerplateAdditions)

- (NSString *)osb_substringFrom:(NSInteger)a to:(NSInteger)b {
   NSRange r;
	r.location = a;
	r.length = b - a;
	return [self substringWithRange:r];
}

- (NSInteger)osb_indexOf:(NSString *)substring from:(NSInteger)starts { // should return NSNotFound instead of -1.
   NSRange r;
	r.location = starts;
	r.length = [self length] - r.location;
	
	NSRange index = [self rangeOfString:substring options:NSLiteralSearch range:r];
	if(index.location == NSNotFound) {
      return -1;
	}
	return index.location + index.length;
}

- (NSString *)osb_trim {
   return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)osb_startsWith:(NSString *)s {
   if([self length] < [s length]) {
      return NO;  
   }
	return [s isEqualToString:[self substringFrom:0 to:[s length]]];
}

- (BOOL)osb_containsString:(NSString *)aString{
   NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString *)osb_urlEncode {
	return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

- (NSString *)osb_sha1 {
   NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
	CC_SHA1(data.bytes, data.length, digest);
	NSData *d = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
	return [d hexString];
}

@end

@implementation NSString (DeprecatedOSXBoilerplateAdditions)

- (NSString*)substringFrom:(NSInteger)a to:(NSInteger)b {
   return [self osb_substringFrom:a to:b];
}

- (NSInteger)indexOf:(NSString*)substring from:(NSInteger)starts {
   return [self osb_indexOf:substring from:starts];
}

- (NSString*)trim {
   return [self osb_trim];
}

- (BOOL)startsWith:(NSString *)s {
   return [self startsWith:s];
}

- (BOOL)containsString:(NSString *)aString {
   return [self osb_containsString:aString];
}

- (NSString *)urlEncode {
   return [self osb_urlEncode];
}

- (NSString *)sha1 {
   return [self osb_sha1];
}

@end
