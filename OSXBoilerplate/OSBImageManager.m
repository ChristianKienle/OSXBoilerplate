#import "OSBImageManager.h"
#import "ASIHTTPRequest.h"
#import "OSBImageManagerDelegate.h"

@implementation OSBImageManager

- (id)init
{
   self = [super init];
   if (self) {
      pendingImages = [[NSMutableArray alloc] initWithCapacity:10];
      loadedImages = [[NSMutableDictionary alloc] initWithCapacity:50];
      downloadQueue = [[NSOperationQueue alloc] init];
      [downloadQueue setMaxConcurrentOperationCount:3];
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

- (NSString*) cacheDirectory {
   return [[[[NSFileManager alloc] init] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSImage*)loadImage:(NSURL *)url {
    return [sharedSingleton loadImage:url];
}

- (NSImage*)loadImage:(NSURL *)url {
	// NSLog(@"url = %@", url);
	NSImage* img = [loadedImages objectForKey:url];
    if (img) {
        return img;
    }
    
    if ([pendingImages containsObject:url]) {
        // already being downloaded
        return nil;
    }
    
    [pendingImages addObject:url];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    /*
     Here you can configure a cache system
     
     if (!cache) {
     ASIDownloadCache* _cache = [[ASIDownloadCache alloc] init];
     self.cache = _cache;
     [_cache release];
     [cache setStoragePath:[self cacheDirectory]];
     }
     // [request setDownloadCache:cache];
     // [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
     // [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
     
     */
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(imageDone:)];
    [request setDidFailSelector:@selector(imageWentWrong:)];
    [downloadQueue addOperation:request];
    return nil;
}

- (void)imageDone:(ASIHTTPRequest*)request {
	NSImage* image = [[NSImage  alloc] initWithData:[request responseData]];
	if (!image) {
		return;
	}
		
	[pendingImages removeObject:request.originalURL];
	[loadedImages setObject:image forKey:request.originalURL];

	SEL selector = @selector(imageManager:didLoadImage:withURL:);
   if(self.delegate != nil && [self.delegate respondsToSelector:selector]) {
      [self.delegate imageManager:self didLoadImage:image withURL:request.originalURL];
   }
}

- (void)imageWentWrong:(ASIHTTPRequest*)request {
	NSLog(@"image went wrong %@", [[request error] localizedDescription]);
	[pendingImages removeObject:request.originalURL]; // TODO should not try to load the image again for a while
}

+ (void) clearMemoryCache {
    [sharedSingleton clearMemoryCache];
}

- (void) clearMemoryCache {
	[loadedImages removeAllObjects];
	[pendingImages removeAllObjects];
}

+ (void) clearCache {
    [sharedSingleton clearCache];
}

- (void) clearCache {
    NSFileManager* fs = [NSFileManager defaultManager];
	// BOOL b = 
	[fs removeItemAtPath:[self cacheDirectory] error:NULL];
    
}

+ (void) releaseSingleton {
   // makes no sense when using ARC
   // [sharedSingleton release]; 
}

+ (OSBImageManager *)sharedImageManager {
   return sharedSingleton;
}

#pragma mark Properties
@synthesize delegate;


@end
