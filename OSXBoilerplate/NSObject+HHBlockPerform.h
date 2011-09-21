//
//  NSObject+HHBlockPerform.h
//  HHBlocks
//
//  Created by Pierre Bernard on 9/15/09.
//  Copyright 2009 Houdah Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef void (^HHPerformBlock)(id owner);


@interface NSObject (HHBlockPerform)

- (void)performAfterDelay:(NSTimeInterval)delay block:(HHPerformBlock)block;
- (void)performOnMainThreadWait:(BOOL)wait block:(HHPerformBlock)block;

@end
