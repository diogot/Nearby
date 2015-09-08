//
//  NSObject+isEqual.h
//  Nearby
//
//  Created by Diogo Tridapalli on 9/4/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;

/**
 *  Category to help isEqual<Object>
 */
@interface NSObject (isEqual)

- (BOOL)nb_isEqualString:(NSString *)a toString:(NSString *)b;
- (BOOL)nb_isEqualNumber:(NSNumber *)a toNumber:(NSNumber *)b;
- (BOOL)nb_isEqualObject:(NSObject *)a toObject:(NSObject *)b;

@end
