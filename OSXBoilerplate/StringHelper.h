//
// Copyright (c) 2011 Christian Kienle
//
// Based on StringHelper from IOSBoilerplate. Kudos to Alberto Gimeno Brieba.
// Improvements:
//  - Prefixed the category methods (but keeping the non-prefixed methods for compatibility) 
//  - This category is now ARC-compatible.
//  - Minor adjustments.
//


#import <Foundation/Foundation.h>

@interface NSString (OSXBoilerplateAdditions)

- (NSString *)osb_substringFrom:(NSInteger)a to:(NSInteger)b;
- (NSInteger)osb_indexOf:(NSString *)substring from:(NSInteger)starts;
- (NSString *)osb_trim;
- (BOOL)osb_startsWith:(NSString *)s;
- (BOOL)osb_containsString:(NSString *)aString;
- (NSString *)osb_urlEncode;
- (NSString *)osb_sha1;

@end

@interface NSString (DeprecatedOSXBoilerplateAdditions)

#pragma mark Accessing Keys and Values
- (NSString *)substringFrom:(NSInteger)a to:(NSInteger)b;
- (NSInteger)indexOf:(NSString *)substring from:(NSInteger)starts;
- (NSString *)trim;
- (BOOL)startsWith:(NSString *)s;
- (BOOL)containsString:(NSString *)aString;
- (NSString *)urlEncode;
- (NSString *)sha1;

@end

