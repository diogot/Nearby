//
//  NBLocationInfoViewCell.h
//  Nearby
//
//  Created by Diogo Tridapalli on 9/6/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import UIKit;

@class NBLocation;
@protocol NBLocationInfoViewCellDelegate;

/**
 *  Collection view cell for NBRouteListViewController
 */
@interface NBLocationInfoViewCell : UICollectionViewCell

/**
 *  Cell delegate
 */
@property (nonatomic, weak) id<NBLocationInfoViewCellDelegate> delegate;

/**
 *  Cell location
 */
@property (nonatomic, readonly) NBLocation *location;

/**
 *  Set cell location and if it has next or previous locations buttons enabled
 *
 *  @param location    NBLocation
 *  @param hasPrevious BOOL
 *  @param hasNext     BOOL
 */
- (void)setLocation:(NBLocation *)location
        hasPrevious:(BOOL)hasPrevious
            hasNext:(BOOL)hasNext;
@end

/**
 *  NBLocationInfoViewCell Delegate
 */
@protocol NBLocationInfoViewCellDelegate <NSObject>

/**
 *  Called when previous location is tapped
 *
 *  @param cell NBLocationInfoViewCell
 */
- (void)didTapPreviousOnInfoViewCell:(NBLocationInfoViewCell *)cell;

/**
 *  Called when next location is tapped
 *
 *  @param cell NBLocationInfoViewCell
 */
- (void)didTapNextOnInfoViewCell:(NBLocationInfoViewCell *)cell;

@end