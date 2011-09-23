//
// Copyright (c) 2011 Christian Kienle
//

#import <Foundation/Foundation.h>

@class OSBDownloadImageOperation;
@protocol OSBDownloadImageOperationDelegate <NSObject>

@optional
- (void)downloadImageOperation:(OSBDownloadImageOperation *)operation didDownloadImage:(NSImage *)image fromURL:(NSURL *)URL;

@end
