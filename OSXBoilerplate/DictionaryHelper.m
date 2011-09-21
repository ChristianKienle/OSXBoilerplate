#import "DictionaryHelper.h"

@implementation NSDictionary (OSXBoilerplateAdditions)

#pragma mark Accessing Keys and Values
- (NSString *)osb_stringForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSString class]]) {
		return nil;
	}
	return s;
}

- (NSNumber *)osb_numberForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSNumber class]]) {
		return nil;
	}
	return s;
}

- (NSMutableDictionary *)osb_dictionaryForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSMutableDictionary class]]) {
		return nil;
	}
	return s;
}

- (NSMutableArray *)osb_arrayForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSMutableArray class]]) {
		return nil;
	}
	return s;
}

@end

@implementation NSDictionary (DeprecatedOSXBoilerplateAdditions)

#pragma mark Accessing Keys and Values
- (NSString *)stringForKey:(id)key {
   return [self osb_stringForKey:key];
}

- (NSNumber *)numberForKey:(id)key {
   return [self osb_numberForKey:key];
}

- (NSMutableDictionary *)dictionaryForKey:(id)key {
   return [self osb_dictionaryForKey:key];
}

- (NSMutableArray *)arrayForKey:(id)key {
   return [self osb_arrayForKey:key];
}

@end
