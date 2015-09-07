//
//  NBLocationInfoViewCell.m
//  Nearby
//
//  Created by Diogo Tridapalli on 9/6/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBLocationInfoViewCell.h"
#import "NBLocation.h"

static CGFloat const kButtonWidth = 30;
static CGFloat const kSpace = 4;

@interface NBLocationInfoViewCell ()

@property (nonatomic, readwrite) NBLocation *location;

@property (nonatomic, readonly) UIButton *leftButton;
@property (nonatomic, readonly) UIButton *rightButton;
@property (nonatomic, readonly) UILabel *nameLabel;
@property (nonatomic, readonly) UILabel *descriptionLabel;

@end

@implementation NBLocationInfoViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UIView *contentView = self.contentView;
    
    UILabel *nameLabel = [self createNameLabel];
    _nameLabel = nameLabel;
    [contentView addSubview:nameLabel];
    
    UILabel *descriptionLabel = [self createDescriptionLabel];
    _descriptionLabel = descriptionLabel;
    [contentView addSubview:descriptionLabel];
    
    UIButton *leftButton = [self createPreviousButton];
    _leftButton = leftButton;
    [contentView addSubview:leftButton];
    
    UIButton *rightButton = [self createNextButton];
    _rightButton = rightButton;
    [contentView addSubview:rightButton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(nameLabel, descriptionLabel, leftButton, rightButton);
    NSDictionary *metrics = @{@"bWidth": @(kButtonWidth),
                              @"space": @(kSpace)};
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[leftButton(bWidth)]-[nameLabel]-[rightButton(bWidth)]|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[leftButton]|"
                                             options:0
                                             metrics:metrics
                                               views:views]];
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightButton]|"
                                             options:0
                                             metrics:metrics
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-(space)-[descriptionLabel]"
                                             options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing
                                             metrics:metrics
                                               views:views]];
}

- (UILabel *)createNameLabel
{
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    return label;
}

- (UILabel *)createDescriptionLabel
{
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    return label;
}

- (UIButton *)createPreviousButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self
               action:@selector(didTapPrevious)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"〈" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    return button;
}

- (UIButton *)createNextButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self
               action:@selector(didTapNext)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"〉" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    return button;
}

- (void)setLocation:(NBLocation *)location
{
    if (_location == location) {

        return;
    }
    
    _location = location;
    
    self.nameLabel.text = location.title.length ? location.title : @"";
    
    NSMutableString *description = [NSMutableString new];
    BOOL hasCategory = location.category.length > 0;
    BOOL hasReason = location.reason.length > 0;
    
    if (hasCategory) {
        [description appendString:location.category];
        if (hasReason) {
            [description appendString:@" ∙ "];
        }
    }
    
    if (hasReason) {
        [description appendString:location.reason];
    }
    
    self.descriptionLabel.text = description.length ? [description copy] : @"";
}

- (void)setLocation:(NBLocation *)location
        hasPrevious:(BOOL)hasPrevious
            hasNext:(BOOL)hasNext
{
    self.location = location;
    self.leftButton.enabled = hasPrevious;
    self.rightButton.enabled = hasNext;
}

#pragma Call NBLocationInfoViewCellDelegate

- (void)didTapPrevious
{
    if ([self.delegate respondsToSelector:@selector(didTapPreviousOnInfoViewCell:)]) {
        [self.delegate didTapPreviousOnInfoViewCell:self];
    }
}

- (void)didTapNext
{
    if ([self.delegate respondsToSelector:@selector(didTapNextOnInfoViewCell:)]) {
        [self.delegate didTapNextOnInfoViewCell:self];
    }
}

@end
