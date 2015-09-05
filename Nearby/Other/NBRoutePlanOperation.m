//
//  NBRoutePlanOperation.m
//  Nearby
//
//  Created by Diogo Tridapalli on 9/5/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBRoutePlanOperation.h"
#import "NBLocation+coordinate.h"
@import CoreLocation.CLLocation;

@interface NBRoutePlanOperation ()

@property (nonatomic, copy) NBRoutePlanOperationCompletionHandler completionHandler;
@property (nonatomic, readonly) NBLocation *startLocation;
@property (nonatomic, readonly) NSMutableArray *route;
@property (nonatomic) NSError *error;

@end

@implementation NBRoutePlanOperation

- (instancetype)initWithStartingLocation:(NBLocation *)location
                          otherLocations:(NSArray *)locations
                       completionHandler:(NBRoutePlanOperationCompletionHandler)completionHandler
{
    self = [super init];
    if (self) {
        _completionHandler = completionHandler;
        _startLocation = location;
        NSMutableArray *route = location ? [NSMutableArray arrayWithObject:location] : nil;
        if (locations.count) {
            [route addObjectsFromArray:locations];
        }
        _route = route;
    }
    
    return self;
}

- (void)execute
{
    NSMutableArray *route = self.route;
    if (route.count == 0) {
        self.error = [self missingStartRoute];
    } else {
        NSInteger count = route.count;
        for (NSInteger i = 0; i < count-1 && !self.cancelled; ++i) {
            NSInteger closestIndex =
            [self indexOfClosestLocationToLocationAtIndex:i
                                           amongLocations:route];
            [route exchangeObjectAtIndex:i+1 withObjectAtIndex:closestIndex];
        }
        
        [route addObject:self.startLocation];
    }
    
    [self finish];
}

- (NSInteger)indexOfClosestLocationToLocationAtIndex:(NSInteger)refereceIndex
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

- (void)finish
{
    NBRoutePlanOperationCompletionHandler completionHandler = [self.completionHandler copy];
    if (completionHandler && self.cancelled == NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.error) {
                completionHandler(nil, self.error);
            } else {
                completionHandler(self.route, nil);
            }
        });
    }
    
    self.completionHandler = nil;
    
    [super finish];
}

- (NSError *)missingStartRoute
{
    NSString *description = NSLocalizedString(@"NBRoutePlanOperation.MissingStartRouteDescription", nil);
    NSError *error = [NSError nb_errorWithCode:NBRoutePlanErrorCode
                          localizedDescription:description];
    
    return error;
}

@end
