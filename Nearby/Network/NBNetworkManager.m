//
//  NBNetworkManager.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBNetworkManager.h"
#import <AFHTTPSessionManager.h>
#import "NBLocationResponseSerializer.h"
#import <Keys/NearbyKeys.h>
#import <AFNetworkActivityIndicatorManager.h>
#import "NBLocation+coordinate.h"
#import "NSError+nb.h"

NSTimeInterval const kRequestTimeout = 30;

NSInteger const kResultsPerPage = 50;

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
    config.timeoutIntervalForRequest = kRequestTimeout;
    _session = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    _session.responseSerializer = [NBLocationResponseSerializer new];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

+ (NSURLSessionTask *)fetchLocationsForCoordinate:(CLLocationCoordinate2D)coordinate
                               page:(NSUInteger)page
                  completionHandler:(void (^)(NSSet *locations, NSError *error))completionHandler
{
    return [[self sharedManager] fetchLocationsForCoordinate:coordinate
                                                        page:page
                                           completionHandler:completionHandler];
}


- (NSURLSessionTask *)fetchLocationsForCoordinate:(CLLocationCoordinate2D)coordinate
                               page:(NSUInteger)page
                  completionHandler:(void (^)(NSSet *locations, NSError *error))completionHandler
{
    if (CLLocationCoordinate2DIsValid(coordinate) == NO) {
        if (completionHandler) {
            completionHandler(nil, [self missingParameterError]);
        }
        
        return nil;
    }
    
    // https://developer.foursquare.com/docs/venues/explore
    NSString * const URLString = @"https://api.foursquare.com/v2/venues/explore";
    
    NSString *offset = [NSString stringWithFormat:@"%ld", (long)(page)*kResultsPerPage];
    NearbyKeys *keys = [NearbyKeys new];
    NSDictionary *params = @{@"ll": [NBLocation stringWithCoordinate:coordinate],
//                             @"section": @"sights",  // This might resctrict too much
                             @"limit": @(kResultsPerPage),
                             @"offset": offset,
                             @"time": @"any",
                             @"client_id": [keys foursquareClientID],
                             @"client_secret": [keys foursquareClientSecret],
                             @"v": @"20150901",
                             @"m": @"foursquare"};

    NSURLSessionTask *task =
    [self.session GET:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionHandler(nil, error);
    }];
    
    return task;
}

- (NSError *)missingParameterError
{
    return [NSError nb_errorWithCode:NBMissingParameterErrorCode
                localizedDescription:NSLocalizedString(@"NBNetworkManager.MissingParameterDescription", )];
}

@end
