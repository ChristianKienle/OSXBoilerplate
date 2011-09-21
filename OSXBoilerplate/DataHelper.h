//
// Copyright (c) 2011 Christian Kienle
//
// Based on DataHelper from IOSBoilerplate. Kudos to Alberto Gimeno Brieba.
// Improvements:
//  - Prefixed the category methods (but keeping the non-prefixed methods for compatibility) 
//  - Minor adjustments.
//

#import <Foundation/Foundation.h>

@interface NSData (OSXBoilerplateAdditions)

- (NSString*)osb_hexString;

@end


@interface NSData (DeprecatedOSXBoilerplateAdditions)

- (NSString*)hexString;

@end