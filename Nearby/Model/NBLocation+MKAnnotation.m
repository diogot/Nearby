//
//  NBLocation+MKAnnotation.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBLocation+MKAnnotation.h"

@implementation NBLocation (MKAnnotation)

- (NSString *)title
{
    return self.name;
}

@end
