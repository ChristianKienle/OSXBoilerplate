//
//  NSObject+HHBlockPerform.m
//  HHBlocks
//
//  Created by Pierre Bernard on 9/15/09.
//  Copyright 2009 Houdah Software. All rights reserved.
//

#import "NSObject+HHBlockPerform.h"


@implementation NSObject (HHBlockPerform)

- (void)performAfterDelay:(NSTimeInterval)delay block:(HHPerformBlock)block
{
	[self performSelector:@selector(runBlock:) withObject:[[block copy] autorelease] afterDelay:delay];
}

- (void)performOnMainThreadWait:(BOOL)wait block:(HHPerformBlock)block
{
	[self performSelectorOnMainThread:@selector(runBlock:)
						   withObject:[[block copy] autorelease]
						waitUntilDone:wait
								modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

- (void)runBlock:(HHPerformBlock)block
{
	block(self);
}

@end