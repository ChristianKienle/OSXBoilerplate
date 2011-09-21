//
//  NSObject+HHKeyValueObserver.m
//
// Copyright (c) 2010 Houdah Software s.à r.l. (http://www.houdah.com)
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSObject+HHKeyValueObserver.h"

#import "NSObject+AMAssociatedObjects.h"


static NSString *HHKeyValueObserverProxiesKey = @"HHKeyValueObserverProxiesKey";


@interface HHKeyValueObserverProxy : NSObject <HHKeyValueObservationInfo>
{
	__weak NSObject *_observer;
	__weak NSObject *_observee;
	NSString *_keyPath;
	SEL _action;
#if NS_BLOCKS_AVAILABLE
    HHKeyValueObserverBlock _block;
#endif
	BOOL _isObserving;
}

- (HHKeyValueObserverProxy *)initWithObserver:(id)observer observee:(id)observee keyPath:(NSString*)keyPath action:(SEL)action;

#if NS_BLOCKS_AVAILABLE
- (HHKeyValueObserverProxy *)initWithObserver:(id)observer observee:(id)observee keyPath:(NSString*)keyPath block:(HHKeyValueObserverBlock)block;
#endif

@property (assign, readonly) NSObject *observer;
@property (assign, readonly) NSObject *observee;
@property (copy, readonly) NSString *keyPath;

@property (assign, readonly) SEL action;
@property (copy, readonly) HHKeyValueObserverBlock block;

- (void)startObserving:(NSKeyValueObservingOptions)options;
- (void)stopObserving;

@end


@implementation NSObject (HHKeyValueObserver)

- (NSMapTable*)hhKeyValueObserverProxies
{
	NSMapTable *hhKeyValueObserverProxies = [self associatedValueForKey:HHKeyValueObserverProxiesKey];
	
	if (hhKeyValueObserverProxies == nil) {
		@synchronized (self) {
			hhKeyValueObserverProxies = [self associatedValueForKey:HHKeyValueObserverProxiesKey];

			if (hhKeyValueObserverProxies == nil) {
				hhKeyValueObserverProxies = [NSMapTable mapTableWithStrongToStrongObjects];
				
				[self associateValue:hhKeyValueObserverProxies withKey:HHKeyValueObserverProxiesKey];
			}
		}
	}
	
	return hhKeyValueObserverProxies;
}

- (NSString*)keyForObservee:(id)observee keyPath:(NSString *)keyPath action:(SEL)action block:(id)block
{
	return [NSString stringWithFormat:@"%p:%@:%@:%p", observee, keyPath, NSStringFromSelector(action), block];
}

- (void)startObserving:(id)observee keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options action:(SEL)action
{
	HHKeyValueObserverProxy *proxy = [[[HHKeyValueObserverProxy alloc] initWithObserver:self observee:self keyPath:keyPath action:action] autorelease];
	NSMapTable *hhKeyValueObserverProxies = [self hhKeyValueObserverProxies];

	[hhKeyValueObserverProxies setObject:proxy forKey:[self keyForObservee:observee keyPath:keyPath action:action block:nil]];
	
	[proxy startObserving:options];
}

- (void)stopObserving:(id)observee keyPath:(NSString *)keyPath target:(id)target action:(SEL)action
{
	NSMapTable *hhKeyValueObserverProxies = [self hhKeyValueObserverProxies];
	NSString *key = [self keyForObservee:observee keyPath:keyPath action:action block:nil];
	
	NSAssert([hhKeyValueObserverProxies objectForKey:key] != nil, @"No observer found matching prototype");
	
	[hhKeyValueObserverProxies removeObjectForKey:key];
}

#if NS_BLOCKS_AVAILABLE

- (void)startObserving:(id)observee keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(HHKeyValueObserverBlock)block
{
	HHKeyValueObserverProxy *proxy = [[[HHKeyValueObserverProxy alloc] initWithObserver:self observee:observee keyPath:keyPath block:block] autorelease];
	NSMapTable *hhKeyValueObserverProxies = [self hhKeyValueObserverProxies];
	
	[hhKeyValueObserverProxies setObject:proxy forKey:[self keyForObservee:observee keyPath:keyPath action:nil block:block]];
	
	[proxy startObserving:options];	
}

- (void)stopObserving:(id)observee keyPath:(NSString *)keyPath block:(HHKeyValueObserverBlock)block
{
	NSMapTable *hhKeyValueObserverProxies = [self hhKeyValueObserverProxies];
	NSString *key = [self keyForObservee:observee keyPath:keyPath action:NULL block:block];
	
	NSAssert([hhKeyValueObserverProxies objectForKey:key] != nil, @"No observer found matching prototype");
	
	[hhKeyValueObserverProxies removeObjectForKey:key];	
}

#endif

@end


static NSString *HHKeyValueObserverContext = @"HHKeyValueObserverContext";


@implementation HHKeyValueObserverProxy 

- (HHKeyValueObserverProxy *)initWithObserver:(id)observer observee:(id)observee keyPath:(NSString*)keyPath action:(SEL)action
{
    if ((self = [super init]) != nil) {
		_observer = observer;
		_observee = observee;
		_keyPath = [keyPath copy];
		_action = action;
	}
	
	return self;
}

#if NS_BLOCKS_AVAILABLE
- (HHKeyValueObserverProxy *)initWithObserver:(id)observer observee:(id)observee keyPath:(NSString*)keyPath block:(HHKeyValueObserverBlock)block
{
    if ((self = [super init]) != nil) {
		_observer = observer;
		_observee = observee;
		_keyPath = [keyPath copy];
		_block = [block copy];
	}
	
	return self;
}
#endif

@synthesize observer = _observer;
@synthesize observee = _observee;
@synthesize keyPath = _keyPath;
@synthesize action = _action;
@synthesize block = _block;

- (void)startObserving:(NSKeyValueObservingOptions)options
{
	@synchronized (self) {
		if (!_isObserving) {
			_isObserving = YES;

			[self.observee addObserver:self forKeyPath:self.keyPath options:options context:HHKeyValueObserverContext];
		}
	}
}

- (void)stopObserving
{
	@synchronized (self) {
		if (_isObserving) {
			_isObserving = NO;
			
			[self.observee removeObserver:self forKeyPath:self.keyPath];
		}
	}
}

- (void)observeValueForKeyPath:(NSString *)inKeyPath ofObject:(id)inObject change:(NSDictionary *)inChange context:(void *)inContext
{
	if ([HHKeyValueObserverContext isEqual:inContext]) {
		
#if NS_BLOCKS_AVAILABLE
		if (self.block != nil) {
			self.block(self, inChange);
			
			return;
		}
#endif
		
		[self.observer performSelector:self.action withObject:self withObject:inChange];
	}
	else {
		[super observeValueForKeyPath:inKeyPath ofObject:inObject change:inChange context:inContext];
	}
}

- (void)dealloc
{
	[self stopObserving];
	
	_observer = nil;
	_observee = nil;
	[_keyPath release], _keyPath = nil;
	_action = NULL;
	[_block release], _block = nil;

    [super dealloc];
}

@end