//
//  NBNetworkManager.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;
@import CoreLocation.CLLocation;

/**
 *  Class to deal with network request
 */
@interface NBNetworkManager : NSObject

/**
 *  Fetch NBlocations nearby a specified coordinate, up to 50 locations per page
 *
 *  @param coordinate        CLLocationCoordinate2D
 *  @param page              results pagination, start with 0
 *  @param completionHandler block executed when the task finishes
 *
 *  @return A running NSURLSessionTask or @a nil if coordinate is invalid
 */
+ (NSURLSessionTask *)fetchLocationsForCoordinate:(CLLocationCoordinate2D)coordinate
                                             page:(NSUInteger)page
                                completionHandler:(void (^)(NSSet *locations, NSError *error))completionHandler;

@end
