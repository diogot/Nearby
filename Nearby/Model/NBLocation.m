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

+ (instancetype)locationWithTitle:(NSString *)title
                         category:(NSString *)category
                           reason:(NSString *)reason
                       coordinate:(CLLocationCoordinate2D)coordinate
{
    return [[self alloc] initWithTitle:title
                              category:category
                                reason:reason
                            coordinate:coordinate];
}

- (instancetype)initWithTitle:(NSString *)title
                     category:(NSString *)category
                       reason:(NSString *)reason
                   coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _title = title;
        _category = category;
        _reason = reason;
        _coordinate = coordinate;
    }
    
    return self;
}

- (BOOL)isEqualToLocation:(NBLocation *)location
{
    if (location == nil) {
        
        return NO;
    }
    
    BOOL equalTitle = [self nb_isEqualString:self.title
                                   toString:location.title];
    BOOL equalCategory = [self nb_isEqualString:self.category
                                       toString:location.category];
    BOOL equalReason = [self nb_isEqualString:self.reason
                                     toString:location.reason];
    BOOL equalCoordinate = [NBLocation isCoordinate:self.coordinate
                                  equalToCoordinate:location.coordinate];
    
    return equalTitle && equalCategory && equalReason && equalCoordinate;
}

#pragma mark - NSObject

- (NSString *)description
{
    NSString *desc;
    
    desc = [NSString stringWithFormat:
            @"title = %@;  category = %@; reason = %@; coordinate = %@;",
            self.title,
            self.category,
            self.reason,
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
    
    //  Not the best way to do it, but works for now, best way require a bitwise rotation:
    //  https://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html
    hash =
    [self.title hash] ^
    [self.category hash] ^
    [self.reason hash] ^
    (NSUInteger)self.coordinate.latitude ^
    (NSUInteger)self.coordinate.longitude;
    
    return hash;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

static NSString * const kLatitude = @"latitude";
static NSString * const kLongitude = @"longintude";

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    CLLocationCoordinate2D coordinate =
    CLLocationCoordinate2DMake([aDecoder decodeDoubleForKey:kLatitude],
                               [aDecoder decodeDoubleForKey:kLongitude]);

    self = [self initWithTitle:[aDecoder decodeObjectOfClass:[NSString class]
                                                      forKey:NSStringFromSelector(@selector(title))]
                      category:[aDecoder decodeObjectOfClass:[NSString class]
                                                      forKey:NSStringFromSelector(@selector(category))]
                        reason:[aDecoder decodeObjectOfClass:[NSString class]
                                                      forKey:NSStringFromSelector(@selector(reason))]
                   coordinate:coordinate];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:NSStringFromSelector(@selector(title))];
    [aCoder encodeObject:self.category forKey:NSStringFromSelector(@selector(category))];
    [aCoder encodeObject:self.reason forKey:NSStringFromSelector(@selector(reason))];
    [aCoder encodeDouble:self.coordinate.latitude forKey:kLatitude];
    [aCoder encodeDouble:self.coordinate.longitude forKey:kLongitude];
}


@end
