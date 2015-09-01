//
//  NBLocationsFetcher.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/30/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBLocationsFetcher.h"
#import "NBNetworkManager.h"
#import "NBLocation+coordinate.h"

#warning REVIEW

@implementation NBLocationsFetcher

+ (NSOperation *)fetchLocationsForCoordinate:(CLLocationCoordinate2D)coordinate
                           completionHandler:(NBLocationsFetcherCompletionHandler)completionHandler
{
    [NBNetworkManager fetchLocationsForCoordinate:coordinate page:0 completionHandler:^(NSDictionary *apiDict, NSError *error) {
        if (error) {
            completionHandler(nil, error);
        } else {
            [self parseApiDictionary:apiDict completionHandler:completionHandler];
        }
    }];
    
    return nil;
}

+ (void)parseApiDictionary:(NSDictionary *)apiDict
         completionHandler:(NBLocationsFetcherCompletionHandler)completionHandler
{
    // Validation errors can return early
    if ([apiDict isKindOfClass:[NSDictionary class]] == NO) {
        completionHandler(nil, [self parseError]);
        
        return;
    }
    
    NSArray *groups = apiDict[@"response"][@"groups"];
    if ([groups isKindOfClass:[NSArray class]] == NO || groups.count == 0) {
        completionHandler(nil, [self parseError]);
        
        return;
    }
    
    NSMutableArray *locations = [NSMutableArray new];
    
    for (NSDictionary *group in groups) {
        NSArray *items = group[@"items"];
        if ([items isKindOfClass:[NSArray class]] == NO) {
            LogSoftCrash();
            
            continue;
        }
        for (NSDictionary *item in items) {
            if ([item isKindOfClass:[NSDictionary class]] == NO) {
                LogSoftCrash();
                
                continue;
            }
            NSDictionary *venue = item[@"venue"];
            if ([venue isKindOfClass:[NSDictionary class]] == NO) {
                LogSoftCrash();
                
                continue;
            }

            NSString *name = venue[@"name"];
            if (name.length == 0) {
                LogSoftCrash();
                
                continue;
            }
            
            NSDictionary *locationDict = venue[@"location"];
            if ([locationDict isKindOfClass:[NSDictionary class]] == NO) {
                LogSoftCrash();
                
                continue;
            }
            
            id lat = locationDict[@"lat"];
            id lng = locationDict[@"lng"];
            CLLocationCoordinate2D coordinate = [NBLocation coordinateFromLatitude:lat
                                                                         longitude:lng];
            if (CLLocationCoordinate2DIsValid(coordinate) == NO) {
                LogSoftCrash();
                
                continue;
            }
            
            NBLocation *location = [NBLocation locationWithName:name
                                                     coordinate:coordinate];
            [locations addObject:location];
        }
    }
    
    if (locations.count == 0) {
        completionHandler(nil, [self parseError]);
    } else {
        completionHandler([locations copy], nil);
    }
}

+ (NSError *)parseError
{
    // Single error just for this execise, but is better to have distinct errors
    NSString *descriprion = NSLocalizedString(@"NBLocationsFetcher.ParsingErrorDescription", nil);
    NSError *error = [NSError nb_errorWithCode:-1
                          localizedDescription:descriprion];
    
    return error;
}

@end
