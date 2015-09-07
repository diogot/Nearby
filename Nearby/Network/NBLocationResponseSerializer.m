//
//  NBLocationResponseSerializer.m
//  Nearby
//
//  Created by Diogo Tridapalli on 9/4/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBLocationResponseSerializer.h"
#import "NBLocation+coordinate.h"

@implementation NBLocationResponseSerializer

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSDictionary *apiDict = [super responseObjectForResponse:response data:data error:error];
    
    if (apiDict == nil) {
        
        return nil;
    }
    
    if ([apiDict isKindOfClass:[NSDictionary class]] == NO) {
        if (error) {
            *error = [self parseError];
        }
        
        return nil;
    }

    NSArray *groups = apiDict[@"response"][@"groups"];
    if ([groups isKindOfClass:[NSArray class]] == NO || groups.count == 0) {
        if (error) {
            *error = [self parseError];
        }
        
        return nil;
    }

    NSMutableSet *locations = [NSMutableSet new];
    
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
            
            
            // TODO: improve error handling
            NSString *category = [venue[@"categories"] firstObject][@"name"];
            NSString *reason = [item[@"reasons"][@"items" ] firstObject][@"summary"];
            
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
            
            NBLocation *location = [NBLocation locationWithTitle:name
                                                        category:category
                                                          reason:reason
                                                      coordinate:coordinate];
            [locations addObject:location];
        }
    }
    
    if (locations.count == 0) {
        if (error) {
            *error = [self parseError];
        }

        locations = nil;
    }

    return [locations copy];
}

#pragma mark - Error

- (NSError *)parseError
{
    // Single error just for this execise, but is better to have distinct errors
    NSString *description = NSLocalizedString(@"NBLocationResponseSerializer.ParsingErrorDescription", nil);
    NSError *error = [NSError nb_errorWithCode:NBParsingErrorCode
                          localizedDescription:description];
    
    return error;
}

@end
