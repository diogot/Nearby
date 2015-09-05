//
//  NBLocationsFetcher.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/30/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBLocationsFetcher.h"
#import "NBLocationFetchOperation.h"

@implementation NBLocationsFetcher

+ (NSOperation *)fetchLocationsForCoordinate:(CLLocationCoordinate2D)coordinate
                           completionHandler:(NBLocationsFetcherCompletionHandler)completionHandler
{
    NBLocationFetchOperation *operation =
    [[NBLocationFetchOperation alloc] initWithCoordinate:coordinate
                                       completionHandler:completionHandler];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
    
    return operation;
}

@end
