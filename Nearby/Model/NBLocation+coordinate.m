//
//  NBLocation+coordinate.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBLocation+coordinate.h"

@implementation NBLocation (coordinate)

+ (NSString *)stringWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSString *string = nil;
    
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        //  precision: http://en.wikipedia.org/wiki/Decimal_degrees
        string = [NSString stringWithFormat:@"%.6f,%.6f",
                  coordinate.latitude,
                  coordinate.longitude];
    }
    
    return string;
}

+ (CLLocationCoordinate2D)coordinateFromLatitude:(id)latitudeObj
                                       longitude:(id)longitudeObj
{
    CLLocationCoordinate2D coordinate = kCLLocationCoordinate2DInvalid;
    
    if (latitudeObj != nil && longitudeObj != nil) {
        BOOL isLatitudeValid = [latitudeObj isKindOfClass:[NSNumber class]] ||
        [latitudeObj isKindOfClass:[NSString class]];
        BOOL isLongitudeValid = [longitudeObj isKindOfClass:[NSNumber class]] ||
        [longitudeObj isKindOfClass:[NSString class]];
        
        if (isLatitudeValid  && isLongitudeValid) {
            CLLocationDegrees latitude = [latitudeObj doubleValue];
            CLLocationDegrees longitude = [longitudeObj doubleValue];
            coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        }
    }
    
    return coordinate;
}

+ (CLLocationDistance)distanceBetweenCoodintate:(CLLocationCoordinate2D)coordinate1
                                            and:(CLLocationCoordinate2D)coordinate2
{
    NSDate *date = [NSDate date];
    CLLocation *newLoc = [[CLLocation alloc] initWithCoordinate:coordinate1
                                                       altitude:500.0
                                             horizontalAccuracy:10.0
                                               verticalAccuracy:10.0
                                                      timestamp:date];
    
    CLLocation *oldLoc = [[CLLocation alloc] initWithCoordinate:coordinate2
                                                       altitude:500.0
                                             horizontalAccuracy:10.0
                                               verticalAccuracy:10.0
                                                      timestamp:date];
    CLLocationDistance distance = [oldLoc distanceFromLocation:newLoc];
    
    return distance;
}

@end
