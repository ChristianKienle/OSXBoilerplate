//
// Copyright (c) 2011 Christian Kienle
//
// Based on DictionaryHelper from IOSBoilerplate. Kudos to Alberto Gimeno Brieba.
// Improvements:
//  - Prefixed the category methods (but keeping the non-prefixed methods for compatibility) 
//

#import <Foundation/Foundation.h>

@interface NSDictionary (OSXBoilerplateAdditions)

#pragma mark Accessing Keys and Values
- (NSString *)osb_stringForKey:(id)key;
- (NSNumber *)osb_numberForKey:(id)key;
- (NSMutableDictionary *)osb_dictionaryForKey:(id)key;
- (NSMutableArray *)osb_arrayForKey:(id)key;

@end

@interface NSDictionary (DeprecatedOSXBoilerplateAdditions)

#pragma mark Accessing Keys and Values
- (NSString *)stringForKey:(id)key;
- (NSNumber *)numberForKey:(id)key;
- (NSMutableDictionary *)dictionaryForKey:(id)key;
- (NSMutableArray *)arrayForKey:(id)key;

@end