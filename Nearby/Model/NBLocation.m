//
//  NBLocation.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/30/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBLocation+coordinate.h"
#import "NSObject+isEqual.h"

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

- (BOOL)isEqualToLocation:(NBLocation *)location
{
    if (location == nil) {
        
        return NO;
    }
    
    BOOL equalName = [self nb_isEqualString:self.name
                                   toString:location.name];
    BOOL equalCoordinate = [NBLocation isCoordinate:self.coordinate
                                  equalToCoordinate:location.coordinate];
    
    return equalName && equalCoordinate;
}

#pragma mark - NSObject

- (NSString *)description
{
    NSString *desc;
    
    desc = [NSString stringWithFormat:
            @"name = %@; coordinate = %@",
            self.name,
            [NBLocation stringWithCoordinate:self.coordinate]];
    
    return desc;
}

- (NSString *)debugDescription
{
    NSString *desc;
    
    desc = [NSString stringWithFormat:@"<%@: %p; %@>",
            NSStringFromClass([self class]),
            self,
            [self description]];
    
    return desc;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if ([object isKindOfClass:[NBLocation class]] == NO) {
        return NO;
    }
    
    return [self isEqualToLocation:object];
}

- (NSUInteger)hash
{
    NSUInteger hash;
    
    hash =
    [self.name hash] ^
    (NSUInteger)self.coordinate.latitude ^
    (NSUInteger)self.coordinate.longitude;
    
    return hash;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
