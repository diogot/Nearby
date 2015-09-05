//
//  NSObject+isEqual.m
//  Nearby
//
//  Created by Diogo Tridapalli on 9/4/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NSObject+isEqual.h"

@implementation NSObject (isEqual)

- (BOOL)nb_isEqualString:(NSString *)a toString:(NSString *)b
{
    return ( a == nil && b == nil ) || [a isEqualToString:b];
}

- (BOOL)nb_isEqualNumber:(NSNumber *)a toNumber:(NSNumber *)b
{
    return ( a == nil && b == nil ) || [a isEqualToNumber:b];
}

- (BOOL)nb_isEqualObject:(NSObject *)a toObject:(NSObject *)b
{
    return ( a == nil && b == nil ) || [a isEqual:b];
}

@end
