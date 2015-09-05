//
//  NBRoutePlanner.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBRoutePlanner.h"
#import "NBRoutePlanOperation.h"

@implementation NBRoutePlanner

+ (NSOperationQueue *)queue
{
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [NSOperationQueue new];
        queue.name = NSStringFromClass([self class]);
    });
    
    return queue;
}

+ (NSOperation *)routeForLocations:(NSArray *)locations
                startingAtLocation:(NBLocation *)location
                 completionHandler:(void (^)(NSArray *path, NSError *error))completionHandler
{
    NBRoutePlanOperation *operation =
    [[NBRoutePlanOperation alloc] initWithStartingLocation:location
                                            otherLocations:locations
                                         completionHandler:completionHandler];

    [[self queue] addOperation:operation];
    
    return operation;
}

@end
