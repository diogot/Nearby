//
//  NBLocation+coordinate.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBLocation.h"

#warning DOCs

@interface NBLocation (coordinate)

/**
 *  Function that returns a NSString from a CLLocationCoordinate2D
 *    using the correct precision.
 *
 *  @param coordinate CLLocationCoordinate2D that will be converted
 *
 *  @return NSString from the coordinate. Returns @a nil if coordinte is
 *    kCLLocationCoordinate2DInvalid
 
 */
+ (NSString *)stringWithCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 *  Converts latitude and longitute from NSString or NSNumber to a valid CLLocationCoordinate2D
 *
 *  @param latitudeObj  NSString or NSNumber, if not returns kCLLocationCoordinate2DInvalid
 *  @param longitudeObj NSString or NSNumber, if not returns kCLLocationCoordinate2DInvalid
 *
 *  @return valid CLLocationCoordinate2D or kCLLocationCoordinate2DInvalid
 */
+ (CLLocationCoordinate2D)coordinateFromLatitude:(id)latitudeObj
                                       longitude:(id)longitudeObj;

/**
 *  Calculate the distance in meters between two coordinates.
 *
 *  @param coordinate1 CLLocationCoordinate2D
 *  @param coordinate2 CLLocationCoordinate2D
 *
 *  @return CLLocationDistance distance in meters between two coordinates
 */
+ (CLLocationDistance)distanceBetweenCoodintate:(CLLocationCoordinate2D)coordinate1
                                            and:(CLLocationCoordinate2D)coordinate2;

@end
