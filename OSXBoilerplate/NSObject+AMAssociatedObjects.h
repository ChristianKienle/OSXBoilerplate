//
//  NSObject+AssociatedObjects.h
//
//  Created by Andy Matuschak on 8/27/09.
//  Public domain because I love you.
//

#import <Cocoa/Cocoa.h>

@interface NSObject (AMAssociatedObjects)
- (void)associateValue:(id)value withKey:(void *)key; // Retains value.
- (void)weakAssociateValue:(id)value withKey:(void *)key;
- (id)associatedValueForKey:(void *)key;
@end
