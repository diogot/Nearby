//
//  NBOperation.m
//  Nearby
//
//  Created by Diogo Tridapalli on 9/5/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBOperation.h"

static NSString * const kStateKeyPath = @"state";

static inline BOOL IsValidStateTransition(NBOperationState fromState,
                                          NBOperationState toState,
                                          BOOL isCanceled)
{
    if (fromState == toState) {
        NBLogD(@"Inconsistent state");
        
        return NO;
    }
    
    switch (fromState) {
        case kNBOperationStateReady:
        case kNBOperationStateExecuting:
            return toState > fromState;
        case kNBOperationStateFinished:
        case kNBOperationStateCanceled:
        default:
            return NO;
    }
}

@interface NBOperation (){
    NBOperationState _state;
}

@property (nonatomic, readwrite) NBOperationState state;

@end

@implementation NBOperation

// use the KVO mechanism to indicate that changes to "state" affect other properties as well
+ (NSSet *)keyPathsForValuesAffectingIsReady
{
    return [NSSet setWithObject:kStateKeyPath];
}

+ (NSSet *)keyPathsForValuesAffectingIsExecuting
{
    return [NSSet setWithObject:kStateKeyPath];
}

+ (NSSet *)keyPathsForValuesAffectingIsFinished
{
    return [NSSet setWithObject:kStateKeyPath];
}

+ (NSSet *)keyPathsForValuesAffectingIsCanceled
{
    return [NSSet setWithObject:kStateKeyPath];
}

- (NBOperationState)state
{
    return _state;
}

- (void)setState:(NBOperationState)state
{
    if (NO == IsValidStateTransition(_state, state, [self isCancelled])) {
        return;
    }
    
    [self willChangeValueForKey:kStateKeyPath];
    _state = state;
    [self didChangeValueForKey:kStateKeyPath];
}

- (BOOL)isReady
{
    return self.state == kNBOperationStateReady && [super isReady];
}

- (BOOL)isExecuting
{
    return self.state == kNBOperationStateExecuting;
}

- (BOOL)isFinished
{
    return self.state >= kNBOperationStateFinished;
}

- (BOOL)isCancelled
{
    return self.state == kNBOperationStateCanceled;
}

- (void)start
{
    if (self.state != kNBOperationStateReady) {
        return;
    }
    
    self.state = kNBOperationStateExecuting;
    [self execute];
}

- (void)execute
{
    [self finish];
}

- (void)cancel
{
    self.state = kNBOperationStateCanceled;
}

- (void)finish
{
    self.state = kNBOperationStateFinished;
}

@end
