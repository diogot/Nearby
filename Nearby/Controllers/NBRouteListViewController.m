//
//  NBRouteListViewController.m
//  Nearby
//
//  Created by Diogo Tridapalli on 9/6/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBRouteListViewController.h"
#import "NBLocationInfoViewCell.h"

@interface NBRouteListViewController () <NBLocationInfoViewCellDelegate>

@end

@implementation NBRouteListViewController

#pragma mark - Public methods

+ (instancetype)controller
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [[[self class] alloc] initWithCollectionViewLayout:layout];
}

- (void)setLocations:(NSArray *)locations
{
    if (_locations == locations) {
        return;
    }
    
    _locations = locations;
    [self.collectionView reloadData];
    [self setHighlightedLocationAtIndex:0
                               animated:YES
                           callDelegate:0];
}

- (void)setHighlightedLocation:(NBLocation *)highlightedLocation
                      animated:(BOOL)animated
{
    NSUInteger index = [self.locations indexOfObject:highlightedLocation];
    [self setHighlightedLocationAtIndex:index
                               animated:animated
                           callDelegate:YES];
}

- (void)setHighlightedLocationAtIndex:(NSInteger)highlightedLocationIndex
                             animated:(BOOL)animated
                         callDelegate:(BOOL)callDelegate
{
    _highlightedLocation = self.locations[highlightedLocationIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:highlightedLocationIndex
                                                 inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionLeft
                                        animated:animated];
    
    if (callDelegate) {
        [self callDidHighlightLocationOnDelegate];
    }
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionView *collectionView = self.collectionView;
    
    [collectionView registerClass:[NBLocationInfoViewCell class]
       forCellWithReuseIdentifier:NSStringFromClass([NBLocationInfoViewCell class])];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.scrollEnabled = NO;
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = size;
    [layout invalidateLayout];
    
#warning TODO: offset need to change also
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.locations.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;
    
    NSArray *locations = self.locations;
    NBLocation *location = locations[index];
    
    
    BOOL hasPrevious = index > 0;
    BOOL hasNext = index < locations.count;

    NBLocationInfoViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NBLocationInfoViewCell class])
                                              forIndexPath:indexPath];
    cell.delegate = self;
    [cell setLocation:location hasPrevious:hasPrevious hasNext:hasNext];
    
    return cell;
}

#pragma mark - NBLocationInfoViewCellDelegate

- (void)didTapPreviousOnInfoViewCell:(NBLocationInfoViewCell *)cell
{
    NBLocation *currentLocation = cell.location;
    NSInteger currentIndex = [self.locations indexOfObject:currentLocation];
    
    [self setHighlightedLocationAtIndex:currentIndex-1
                               animated:YES
                           callDelegate:YES];
}

- (void)didTapNextOnInfoViewCell:(NBLocationInfoViewCell *)cell
{
    NBLocation *currentLocation = cell.location;
    NSInteger currentIndex = [self.locations indexOfObject:currentLocation];
    
    [self setHighlightedLocationAtIndex:currentIndex+1
                               animated:YES
                           callDelegate:YES];
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;
    [self callDidSelectedLocationOnDelegate:self.locations[index]];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.bounds.size.width;
    CGFloat height = CGRectGetHeight(self.view.bounds);
    UIEdgeInsets contentInset = collectionView.contentInset;
    
    CGSize size = CGSizeMake(width - contentInset.right - contentInset.left,
                             height);
    
    return size;
}

#pragma mark - NBRouteListViewControllerDelegate

- (void)callDidHighlightLocationOnDelegate
{
    if ([self.delegate respondsToSelector:@selector(didHighlightLocation:onRouteListController:)]) {
        [self.delegate didHighlightLocation:self.highlightedLocation onRouteListController:self];
    }
}

- (void)callDidSelectedLocationOnDelegate:(NBLocation *)location
{
    if ([self.delegate respondsToSelector:@selector(didSelectedLocation:onRouteListController:)]) {
        [self.delegate didSelectedLocation:location onRouteListController:self];
    }
}

@end
