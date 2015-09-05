//
//  NBLocationFetchOperation.h
//  Nearby
//
//  Created by Diogo Tridapalli on 9/5/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBOperation.h"
@import CoreLocation.CLLocation;

/**
 *  Completion handler
 *
 *  @param locations NSArray of NBLocation or @a nil
 *  @param error     NSError if locations is @a nil
 */
typedef void(^NBLocationFetchOperationCompletionHandler)(NSArray *locations, NSError *error);

/**
 *  Operation to fetch up to 100 NBLocation nearby a coordinate
 */
@interface NBLocationFetchOperation : NBOperation

/**
 *  Coordinate passed on init
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (instancetype)init __attribute__((unavailable("Must use initWithCoordinate:completionHandler: instead.")));

/**
 *  Designated initializer
 *
 *  @param coordinate        coordinate to fetch locations nearby
 *  @param completionHandler completion block, is not executed if the operation 
 *   is canceled
 *
 *  @return NBLocationFetchOperation
 */
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                 completionHandler:(NBLocationFetchOperationCompletionHandler)completionHandler
NS_DESIGNATED_INITIALIZER;

@end
