//
//  NBLocation.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/30/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;
@import CoreLocation.CLLocation;
@import MapKit.MKAnnotation;

/**
 *  Represents a location
 */
@interface NBLocation : NSObject <NSCopying, NSSecureCoding, MKAnnotation>

/**
 *  Location name
 */
@property (nonatomic, readonly, copy) NSString *title;

/**
 *  Location category
 */
@property (nonatomic, readonly) NSString *category;

/**
 *  Reason to visit the location
 */
@property (nonatomic, readonly) NSString *reason;

/**
 *  Location coordinate
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/**
 *  Convenience constructor
 *
 *  @param title      NSString
 *  @param category   NSString
 *  @param reason     NSString
 *  @param coordinate CLLocationCoordinate2D
 *
 *  @return NBLocation
 */
+ (instancetype)locationWithTitle:(NSString *)title
                         category:(NSString *)category
                           reason:(NSString *)reason
                       coordinate:(CLLocationCoordinate2D)coordinate;

/**
 *  Designated initializer
 *
 *  @param title      NSString
 *  @param category   NSString
 *  @param reason     NSString
 *  @param coordinate CLLocationCoordinate2D
 *
 *  @return NBLocation
 */
- (instancetype)initWithTitle:(NSString *)title
                     category:(NSString *)category
                       reason:(NSString *)reason
                  coordinate:(CLLocationCoordinate2D)coordinate
NS_DESIGNATED_INITIALIZER;

/**
 *  Compares with other location
 *
 *  @param location NBLocation
 *
 *  @return @a YES if is equal (same properties), @a NO otherwise
 */
- (BOOL)isEqualToLocation:(NBLocation *)location;

@end
