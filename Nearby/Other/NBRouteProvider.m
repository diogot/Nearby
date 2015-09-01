//
//  NBRouteProvider.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBRouteProvider.h"
#import "NBLocation+coordinate.h"

#warning REVIEW

@implementation NBRouteProvider

+ (void)routeForLocations:(NSArray *)locations
      startingAtLocation:(NBLocation *)location
       completionHandler:(void (^)(NSArray *path, NSError *error))completionHandler
{
    NSMutableArray *path = [NSMutableArray arrayWithObject:location];
    [path addObjectsFromArray:locations];
    
    NSInteger count = path.count;
    for (NSInteger i = 0; i < count-1; ++i) {
        NSInteger closestIndex =
        [self indexOfClosestLocationToLocationAtIndex:i
                                       amongLocations:path];
        [path exchangeObjectAtIndex:i+1 withObjectAtIndex:closestIndex];
    }
    
    [path addObject:location];
    
    completionHandler([path copy], nil);
}

+ (NSInteger)indexOfClosestLocationToLocationAtIndex:(NSInteger)refereceIndex
                                      amongLocations:(NSArray *)locations
{
    NSInteger closestIndex = -1;
    CLLocationDistance minDistance = DBL_MAX;
    
    NSInteger count = locations.count;
    CLLocationCoordinate2D referece = ((NBLocation *)locations[refereceIndex]).coordinate;
    
    for (NSInteger i = refereceIndex+1; i<count; ++i) {
        CLLocationCoordinate2D coord = ((NBLocation *)locations[i]).coordinate;

        CLLocationDistance distance =
        [NBLocation distanceBetweenCoodintate:referece
                                          and:coord];
        if (distance <= minDistance) {
            minDistance = distance;
            closestIndex = i;
        }
    }
    
    return closestIndex;
}

@end
