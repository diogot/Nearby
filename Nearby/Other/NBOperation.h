//
//  NBOperation.h
//  Nearby
//
//  Created by Diogo Tridapalli on 9/5/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;

/**
 *  Operation states
 */
typedef NS_ENUM(NSInteger, NBOperationState){
    /**
     *  Operation is ready to execute
     */
    kNBOperationStateReady = 0,
    /**
     *  Operation is executing
     */
    kNBOperationStateExecuting,
    /**
     *  Operation is finished
     */
    kNBOperationStateFinished,
    /**
     *  Operation is finished due to cancel
     */
    kNBOperationStateCanceled
};

/**
 *  Class to be subclassed for easy encapsulation of tasks
 */
@interface NBOperation : NSOperation

/**
 *  Operation state
 *
 *  @see NBOperationState
 */
@property (nonatomic, readonly) NBOperationState state;

/**
 *  Methdos that must be overide on subclasses, the task should be started 
 *  inside this method and finish should be called on task completion
 */
- (void)execute;

/**
 *  When the task is finished this method should be called
 */
- (void)finish;

@end
