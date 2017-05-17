//
//  MAKMultiDelegate.h
//  HolidayCheck
//
//  Created by Martin Kloepfel on 18.01.16.
//  Copyright © 2016 HolidayCheck AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAKMultiDelegate : NSObject

/**
 The array of registered delegates.
 */
@property (readonly, nonatomic) NSPointerArray* delegates;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;

@end
