//
//  NBRouteListViewController.h
//  Nearby
//
//  Created by Diogo Tridapalli on 9/6/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import UIKit;

@class NBLocation;
@protocol NBRouteListViewControllerDelegate;

/**
 *  Controller to list the locations on route
 */
@interface NBRouteListViewController : UICollectionViewController

/**
 *  Controller delegate
 */
@property (nonatomic, weak) id<NBRouteListViewControllerDelegate> delegate;

/**
 *  Array of NBLocations, when set trigger a list reload
 */
@property (nonatomic) NSArray *locations;

/**
 *  Current location highlighed
 */
@property (nonatomic, readonly) NBLocation *highlightedLocation;


/**
 *  Default constructor
 *
 *  @return NBRouteListViewController
 */
+ (instancetype)controller;

/**
 *  Set the highlighted location on the list, don't trigger delegate
 *
 *  @param highlightedLocation NBLocation
 *  @param animated            BOOL
 */
- (void)setHighlightedLocation:(NBLocation *)highlightedLocation
                      animated:(BOOL)animated;

@end

/**
 *  NBRouteListViewController Delegate
 */
@protocol NBRouteListViewControllerDelegate <NSObject>

/**
 *  Called when a new location is highlighted
 *
 *  @param location   NBLocation
 *  @param controller NBRouteListViewController
 */
- (void)didHighlightLocation:(NBLocation *)location
       onRouteListController:(NBRouteListViewController *)controller;

/**
 *  Called when a location is selected
 *
 *  @param location   NBLocation
 *  @param controller NBRouteListViewController
 */
- (void)didSelectedLocation:(NBLocation *)location
      onRouteListController:(NBRouteListViewController *)controller;

@end