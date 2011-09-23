//
// Copyright (c) 2011 Christian Kienle
//

#import <Foundation/Foundation.h>

@protocol OSBDownloadImageOperationDelegate;

@interface OSBDownloadImageOperation : NSOperation

#pragma mark Creation
- (id)initWithURL:(NSURL *)initialURL delegate:(id<OSBDownloadImageOperationDelegate>)initialDelegate;

#pragma mark Properties
@property (nonatomic, readonly, weak) id<OSBDownloadImageOperationDelegate> delegate;
@property (nonatomic, readonly, strong) NSURL *URL;
@property (nonatomic, readonly, strong) NSImage *downloadedImage;

@end
