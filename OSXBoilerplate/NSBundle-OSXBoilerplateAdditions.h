//
// Copyright (c) 2011 Christian Kienle
//

#import <Foundation/Foundation.h>

@interface NSBundle (OSXBoilerplateAdditions)

#pragma mark Properties
@property (nonatomic, readonly) NSString *osb_name; // returns the "human-readable name of the bundle" - see also: kCFBundleNameKey

@end
