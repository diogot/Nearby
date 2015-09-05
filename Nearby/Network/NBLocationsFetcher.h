//
//  NBLocationsFetcher.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/30/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;
@import CoreLocation.CLLocation;

/**
 *  Completion block
 *
 *  @param locations NSArray of NBLocation
 *  @param error     NSError if NBLocation is @a nil
 */
typedef void (^NBLocationsFetcherCompletionHandler)(NSArray *locations, NSError *error);

/**
 *  Fetcher for locations nearby a coordinate
 */
@interface NBLocationsFetcher : NSObject

/**
 *  Creates a cancelable fetch for up to 100 NBLocations nearby a
 *   CLLocationCoordinate2D.
 *
 *
 *  @param coordinate        CLLocationCoordinate2D
 *  @param completionHandler Block execute when operation finishes, is not 
 *    called if operation is canceld
 *
 *  @return NSOperation
 */
+ (NSOperation *)fetchLocationsForCoordinate:(CLLocationCoordinate2D)coordinate
                           completionHandler:(NBLocationsFetcherCompletionHandler)completionHandler;

@end
