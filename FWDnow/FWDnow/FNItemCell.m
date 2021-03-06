
//
//  FNItemCell.m
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import "FNItemCell.h"
#import "UIView+Utilities.h"

@implementation FNItemCell

+ (CGSize)sizeForState:(FNItemCellState)state {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (state == FNItemCellStateNormal) {
            return CGSizeMake(467.0, 200.0);
        } else {
            return CGSizeMake(964.0, 400.0);
        }
    } else {
        if (state == FNItemCellStateNormal) {
            return CGSizeMake(310.0, 150.0);
        } else {
            return CGSizeMake(310.0, 300.0);
        }
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.gradientView addGradientWithTopColor:[UIColor clearColor]
                                   bottomColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //Resize gradient layer
    for (CALayer *sub in self.gradientView.layer.sublayers) {
        sub.frame = self.gradientView.bounds;
    }
}

- (IBAction)btnFWDPressed:(UIButton *)sender {
    
}

- (void)setupForItem:(FNItem *)item {
    _item = item;
}

- (void)setCellState:(FNItemCellState)cellState animate:(BOOL)animated {
}

- (void)setCellMode:(FNItemCellMode)cellMode animated:(BOOL)animated {
}

#pragma mark - FNPostViewDelegate

- (UIViewController *)viewControllerForPostViewShareViews:(FNPostView *)postView {
    return [self.delegate viewControllerForItemCell:self];
}

- (void)postViewDidFinishPosting:(FNPostView *)postView {
    //We want to show the success post view and the call view on the iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self setCellMode:FNItemCellModeCall animated:YES];
    } else {
        //On the iPhone we are done
        [self setCellMode:FNItemCellModeNormal animated:YES];
    }
    
}

#pragma mark - FNCallViewDelegate

- (void)callViewDidCall:(FNCallView *)callView {
    [self setCellMode:FNItemCellModeNormal animated:YES];
}

- (void)callViewDidSendPostCard:(FNCallView *)callView {
    [self setCellMode:FNItemCellModeNormal animated:YES];
}

@end
