//
//  NBLocation.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/30/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;
@import CoreLocation.CLLocation;

#warning Docs

@interface NBLocation : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

+ (instancetype)locationWithName:(NSString *)name
                      coordinate:(CLLocationCoordinate2D)coordinate;

- (instancetype)initWithName:(NSString *)name
                  coordinate:(CLLocationCoordinate2D)coordinate
NS_DESIGNATED_INITIALIZER;

@end
