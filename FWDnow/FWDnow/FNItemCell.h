//
//  FNItemCell.h
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FNItemCellState) {
    FNItemCellStateNormal = 0,
    FNItemCellStateFull
};

@class FNItem;

@interface FNItemCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *btnFWD;
@property (strong, nonatomic) IBOutlet UILabel *numOfFowardsLabel;
@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (nonatomic) FNItemCellState cellState;

+ (CGSize)sizeForState:(FNItemCellState)state;

- (void)setupForItem:(FNItem *)item;
- (void)setCellState:(FNItemCellState)cellState animate:(BOOL)animated;

@end