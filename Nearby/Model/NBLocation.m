//
//  NBLocation.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/30/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBLocation.h"

@implementation NBLocation

+ (instancetype)locationWithName:(NSString *)name
                      coordinate:(CLLocationCoordinate2D)coordinate
{
    return [[self alloc] initWithName:name coordinate:coordinate];
}

- (instancetype)initWithName:(NSString *)name
                  coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _name = name;
        _coordinate = coordinate;
    }
    
    return self;
}

@end
