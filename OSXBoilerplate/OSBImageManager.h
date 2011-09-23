//
// Copyright (c) 2011 Christian Kienle
//
// Based on ImageManager from IOSBoilerplate (kudos to Alberto Gimeno Brieba)
// Modifications made: 
//  - decoupled ImageManager from the app delegate
//  - added the OSB-prefix
//  - UIImage -> NSImage
//  - introduction of the OSBIMageManagerDelegate protocol + renamed the delegate method
//  - using the correct API for getting the cache directory
//  - suggestion: remove the caching since NSImage and UIImages are already being cached
//  - suggestion: do not implement this class as a singleton

#import <Foundation/Foundation.h>
#import "OSBDownloadImageOperationDelegate.h"

@protocol OSBImageManagerDelegate;
@interface OSBImageManager : NSObject <OSBDownloadImageOperationDelegate> {
   @private
   NSMutableArray* pendingImages;
	NSMutableDictionary* loadedImages;
	NSOperationQueue *downloadQueue;
}

#pragma mark Loading images
+ (NSImage *)loadImage:(NSURL *)url;
- (NSImage *)loadImage:(NSURL *)url;

#pragma mark Working with the cache
+ (void)clearMemoryCache;
- (void)clearMemoryCache;
+ (void)clearCache;
- (void)clearCache;
- (NSString *)cacheDirectory;

#pragma mark Singleton-specific
+ (OSBImageManager *)sharedImageManager;

#pragma mark Properties
@property (nonatomic, weak) IBOutlet id<OSBImageManagerDelegate> delegate;

@end
