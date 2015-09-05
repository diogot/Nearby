//
//  NBRoutePlanner.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;

@class NBLocation;

/**
 *  Class to plan routes in an array of locations
 */
@interface NBRoutePlanner : NSObject

/**
 *  Creates an operation that will plan a route staring in specific location.
 *   if canceled the completion handler is not called
 *
 *  @param locations         NSArray of NBLocation
 *  @param location          NBLocation starting, if @a nil the completion block
 *   is called with an error
 *  @param completionHandler completion block, is not executed if the operation
 *   is canceled
 *
 *  @return NSOperation
 */
+ (NSOperation *)routeForLocations:(NSArray *)locations
                startingAtLocation:(NBLocation *)location
                 completionHandler:(void (^)(NSArray *path, NSError *error))completionHandler;

@end
