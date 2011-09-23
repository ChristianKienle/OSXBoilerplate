#import "OSBImageManager.h"
#import "OSBImageManagerDelegate.h"
#import "OSBDownloadImageOperation.h"

@interface OSBImageManager ()

#pragma mark Properties
@property (nonatomic, strong, readwrite) NSMutableArray *pendingImages;
@property (nonatomic, strong, readwrite) NSMutableDictionary *loadedImages;
@property (nonatomic, strong, readwrite) NSOperationQueue *downloadQueue;

@end

@implementation OSBImageManager

#pragma mark Properties
@synthesize pendingImages, loadedImages, downloadQueue;

- (id)init {
   self = [super init];
   if(self) {
      self.pendingImages = [NSMutableArray array];
      self.loadedImages = [NSMutableDictionary dictionary];
      self.downloadQueue = [[NSOperationQueue alloc] init];
      [self.downloadQueue setMaxConcurrentOperationCount:3];
      self.delegate = nil;
   }
    
   return self;
}

static OSBImageManager *sharedSingleton;

+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
        sharedSingleton = [[OSBImageManager alloc] init];
    }
}

- (NSString *)cacheDirectory {
   return [[[[NSFileManager alloc] init] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSImage *)loadImage:(NSURL *)url {
   return [sharedSingleton loadImage:url];
}

- (NSImage *)loadImage:(NSURL *)url {
   NSImage * image = [loadedImages objectForKey:url];
   if(image) {
      return image;
   }
    
   if([pendingImages containsObject:url]) {
      return nil;
   }
    
   [pendingImages addObject:url];
   
   OSBDownloadImageOperation *operation = [[OSBDownloadImageOperation alloc] initWithURL:url delegate:self];
   [downloadQueue addOperation:operation];
    return nil;
}

- (void)didDownloadImage:(NSImage *)image fromURL:(NSURL *)URL {
	if (!image) {
		return;
	}
   
	[pendingImages removeObject:URL];
	[loadedImages setObject:image forKey:URL];
   
	SEL selector = @selector(imageManager:didLoadImage:withURL:);
   if(self.delegate != nil && [self.delegate respondsToSelector:selector]) {
      [self.delegate imageManager:self didLoadImage:image withURL:URL];
   }
}

+ (void)clearMemoryCache {
    [sharedSingleton clearMemoryCache];
}

- (void)clearMemoryCache {
	[loadedImages removeAllObjects];
	[pendingImages removeAllObjects];
}

+ (void)clearCache {
    [sharedSingleton clearCache];
}

- (void)clearCache {
   NSFileManager* fs = [NSFileManager defaultManager];
   [fs removeItemAtPath:[self cacheDirectory] error:NULL];    
}

+ (OSBImageManager *)sharedImageManager {
   return sharedSingleton;
}

#pragma mark Properties
@synthesize delegate;

#pragma mark OSBDownloadImageOperationDelegate
- (void)downloadImageOperation:(OSBDownloadImageOperation *)operation didDownloadImage:(NSImage *)image fromURL:(NSURL *)URL {
	if(!image) {
		return;
	}
   
	[pendingImages removeObject:URL];
	[loadedImages setObject:image forKey:URL];
   
	SEL selector = @selector(imageManager:didLoadImage:withURL:);
   if(self.delegate != nil && [self.delegate respondsToSelector:selector]) {
      [self.delegate imageManager:self didLoadImage:image withURL:URL];
   }
}

@end
