//
//  FNItemCell.h
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNPostView.h"
#import "FNCallView.h"

typedef NS_ENUM(NSInteger, FNItemCellState) {
    FNItemCellStateNormal = 0,
    FNItemCellStateFull
};

typedef NS_ENUM(NSInteger, FNItemCellMode) {
    FNItemCellModeNormal = 0,
    FNItemCellModePost,
    FNItemCellModeCall
};

@class FNItem;
@protocol FNItemCellDelegate;

@interface FNItemCell : UICollectionViewCell <FNPostViewDelegate> {
    FNItem *_item;
    FNPostView *_postView;
    FNCallView *_callView;
    FNItemCellState _cellState;
    FNItemCellMode _cellMode;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *blurredImageView;
@property (strong, nonatomic) IBOutlet UIButton *btnFWD;
@property (strong, nonatomic) IBOutlet UILabel *numOfFowardsLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (nonatomic) FNItemCellState cellState;
@property (nonatomic) FNItemCellMode cellMode;
@property (weak, nonatomic) id<FNItemCellDelegate> delegate;

+ (CGSize)sizeForState:(FNItemCellState)state;

- (IBAction)btnFWDPressed:(UIButton *)sender;

- (void)setupForItem:(FNItem *)item;
- (void)setCellState:(FNItemCellState)cellState animate:(BOOL)animated;
- (void)setCellMode:(FNItemCellMode)cellMode animated:(BOOL)animated;

@end

@protocol FNItemCellDelegate <NSObject>

- (UIViewController *)viewControllerForItemCell:(FNItemCell *)cell;

@end
