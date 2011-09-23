#import "OSBDownloadImageOperation.h"
#import "OSBDownloadImageOperationDelegate.h"

@interface OSBDownloadImageOperation ()

#pragma mark Properties
@property (nonatomic, readwrite, weak) id<OSBDownloadImageOperationDelegate> delegate;
@property (nonatomic, readwrite, strong) NSURL *URL;
@property (nonatomic, readwrite, strong) NSImage *downloadedImage;

@end

@implementation OSBDownloadImageOperation

#pragma mark Creation
- (id)initWithURL:(NSURL *)initialURL delegate:(id<OSBDownloadImageOperationDelegate>)initialDelegate {
   self = [super init];
   if(self) {
      self.URL = initialURL;
      self.delegate = initialDelegate;
      self.downloadedImage = nil;
   }
   return self;
}

#pragma mark Properties
@synthesize URL, delegate, downloadedImage;


#pragma mark NSOperation
- (void)main {
   @try {
      @autoreleasepool {
         if(self.URL == nil) {
            NSLog(@"Cannot download image because URL is nil.");
            return;
         }
         self.downloadedImage = [[NSImage alloc] initWithContentsOfURL:self.URL];
         [self performSelectorOnMainThread:@selector(informDelegateAboutDownloadedImage) withObject:nil waitUntilDone:YES];
      }
   }
   @catch (NSException *exception) {
      // Do nothing - intentional.
   }
}

#pragma mark Notify the delegate - to be executed on the main thread.
- (void)informDelegateAboutDownloadedImage {
   if(self.delegate == nil) {
      return;
   }

   SEL didDownloadAction = @selector(downloadImageOperation:didDownloadImage:fromURL:);
   if([self.delegate respondsToSelector:didDownloadAction]) {
      [self.delegate downloadImageOperation:self didDownloadImage:self.downloadedImage fromURL:self.URL];
   }
}

@end
