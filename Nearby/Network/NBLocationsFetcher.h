//
//  NBLocationsFetcher.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/30/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;
@import CoreLocation.CLLocation;

#warning DOCs

typedef void (^NBLocationsFetcherCompletionHandler)(NSArray *locations, NSError *error);

@interface NBLocationsFetcher : NSObject

+ (NSOperation *)fetchLocationsForCoordinate:(CLLocationCoordinate2D)coordinate
                           completionHandler:(NBLocationsFetcherCompletionHandler)completionHandler;

@end
