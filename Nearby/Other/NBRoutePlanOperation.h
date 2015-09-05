//
//  NBRoutePlanOperation.h
//  Nearby
//
//  Created by Diogo Tridapalli on 9/5/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBOperation.h"

@class NBLocation;

/**
 *  Completion handler
 *
 *  @param plannedRoute NSArray of NBLocation or @a nil
 *  @param error        NSError if locations is @a nil
 */
typedef void(^NBRoutePlanOperationCompletionHandler)(NSArray *plannedRoute, NSError *error);

/**
 *  Operation to plan a route path for an array of locations
 */
@interface NBRoutePlanOperation : NBOperation

- (instancetype)init
__attribute__((unavailable("Must use initWithStartingLocation:otherLocations:completionHandler: instead.")));

/**
 *  Designated initializer
 *
 *  @param location          Start location
 *  @param locations         Array of lacations to visit
 *  @param completionHandler completion block, is not executed if the operation
 *   is canceled
 *
 *  @return NBRoutePlanOperation
 */
- (instancetype)initWithStartingLocation:(NBLocation *)location
                          otherLocations:(NSArray *)locations
                       completionHandler:(NBRoutePlanOperationCompletionHandler)completionHandler
NS_DESIGNATED_INITIALIZER;

@end
