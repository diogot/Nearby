//
//  NBLocation+MKAnnotation.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBLocation.h"

@import MapKit.MKAnnotation;

#warning Docs

@interface NBLocation (MKAnnotation) <MKAnnotation>

@property(nonatomic, readonly, copy) NSString *title;

@end