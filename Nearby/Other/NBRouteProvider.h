//
//  NBRouteProvider.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;

@class NBLocation;
#warning DOCs

@interface NBRouteProvider : NSObject

+ (void)routeForLocations:(NSArray *)locations
       startingAtLocation:(NBLocation *)location
        completionHandler:(void (^)(NSArray *path, NSError *error))completionHandler;

@end
