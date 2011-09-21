//
// Copyright (c) 2011 Christian Kienle
//

#import <Foundation/Foundation.h>

@class OSBImageManager;
@protocol OSBImageManagerDelegate <NSObject>

@optional
- (void)imageManager:(OSBImageManager *)imageManager didLoadImage:(NSImage *)image withURL:(NSURL *)URL;

@end
