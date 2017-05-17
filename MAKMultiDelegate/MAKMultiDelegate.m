//
//  MAKMultiDelegate.m
//  HolidayCheck
//
//  Created by Martin Kloepfel on 18.01.16.
//  Copyright © 2016 HolidayCheck AG. All rights reserved.
//

#import "MAKMultiDelegate.h"


@implementation MAKMultiDelegate

@synthesize delegates = _delegates;

- (void)addDelegate:(id)delegate
{
    if (!self.delegates)
        _delegates = [NSPointerArray weakObjectsPointerArray];
    
    [self.delegates addPointer:(__bridge void*)delegate];
}

- (void)removeDelegate:(id)delegate
{
    NSUInteger index = [self indexOfDelegate:delegate];
    if (index != NSNotFound)
        [self.delegates removePointerAtIndex:index];
}

- (void)removeAllDelegates
{
    while (self.delegates.count)
        [self.delegates removePointerAtIndex:self.delegates.count];
}

- (NSUInteger)indexOfDelegate:(id)delegate
{
    for (NSUInteger i = 0; i < self.delegates.count; i += 1)
    {
        if ([self.delegates pointerAtIndex:i] == (__bridge void*)delegate)
            return i;
    }
    return NSNotFound;
}

- (BOOL)respondsToSelector:(SEL)selector
{
    if ([super respondsToSelector:selector])
        return YES;
    
    for (id delegate in self.delegates)
    {
        if (delegate && [delegate respondsToSelector:selector])
            return YES;
    }
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (signature)
        return signature;

    for (id delegate in self.delegates)
    {
        if (!delegate)
            continue;
        
        signature = [delegate methodSignatureForSelector:selector];
        if (signature)
            break;
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    BOOL responded = NO;
    
    for (id delegate in self.delegates)
    {
        if (delegate && [delegate respondsToSelector:selector])
        {
            [invocation invokeWithTarget:delegate];
            responded = YES;
        }
    }
    
    if (!responded)
        [self doesNotRecognizeSelector:selector];
}

@end
