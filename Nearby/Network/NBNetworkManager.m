//
//  NBNetworkManager.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBNetworkManager.h"
#import <AFHTTPSessionManager.h>
#import <Keys/NearbyKeys.h>
#import <AFNetworkActivityIndicatorManager.h>
#import "NBLocation+coordinate.h"

#warning REVIEW

@interface NBNetworkManager ()

@property (nonatomic, readonly) AFHTTPSessionManager *session;

+ (instancetype)sharedManager;

@end

@implementation NBNetworkManager

+ (instancetype)sharedManager
{
    static dispatch_once_t pred;
    static id shared;
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30;
    _session = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    _session.responseSerializer = [AFJSONResponseSerializer new];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

+ (void)fetchLocationsForCoordinate:(CLLocationCoordinate2D)coordinate
                               page:(NSInteger)page
                  completionHandler:(void (^)(NSDictionary *apiDict, NSError *error))completionHandler
{
    [[self sharedManager] fetchLocationsForCoordinate:coordinate
                                                 page:page
                                    completionHandler:completionHandler];
}


- (void)fetchLocationsForCoordinate:(CLLocationCoordinate2D)coordinate
                               page:(NSInteger)page
                  completionHandler:(void (^)(NSDictionary *apiDict, NSError *error))completionHandler
{
    // https://developer.foursquare.com/docs/venues/explore
    NSString *URLString = @"https://api.foursquare.com/v2/venues/explore";
    
    NSString *offset = [NSString stringWithFormat:@"%ld", (long)(page)*50];
    NearbyKeys *keys = [NearbyKeys new];
    NSDictionary *params = @{@"ll": [NBLocation stringWithCoordinate:coordinate],
                             @"section": @"sights",
                             @"limit": @"50",
                             @"offset": offset,
                             @"time": @"any",
                             @"client_id": [keys foursquareClientID],
                             @"client_secret": [keys foursquareClientSecret],
                             @"v": @"20150901",
                             @"m": @"foursquare"};

    [self.session GET:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionHandler(nil, error);
    }];
}

@end
