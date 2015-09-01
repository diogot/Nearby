//
//  NBNetworkManager.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;
@import CoreLocation.CLLocation;

#warning Docs
@interface NBNetworkManager : NSObject

+ (void)fetchLocationsForCoordinate:(CLLocationCoordinate2D)coordinate
                               page:(NSInteger)page
                  completionHandler:(void (^)(NSDictionary *apiDict, NSError *error))completionHandler;

@end
