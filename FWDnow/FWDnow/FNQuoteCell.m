//
//  FNQuoteCell.m
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import "FNQuoteCell.h"
#import "FNQuote.h"
#import "FNKit.h"
#import <FXBlurView/FXBlurView.h>

#define CONTENT_SIDE_OFFSET 30.0

@implementation FNQuoteCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cellState = FNItemCellStateNormal;
    
    self.btnFWD.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnFWD.layer.borderWidth = 2.0;
}

- (IBAction)btnFWDPressed:(UIButton *)sender {
    [self setCellMode:FNItemCellModePost animated:YES];
}

- (void)setCellState:(FNItemCellState)cellState {
    [self setCellState:cellState animate:NO];
}

- (void)setCellState:(FNItemCellState)cellState animate:(BOOL)animated {
    
    CGFloat duration = animated?0.3:0.0;
    [UIView animateWithDuration:duration
                     animations:^{
                         if (cellState == FNItemCellStateNormal) {
                             self.contentView.alpha = 0.0;
                         } else {
                             self.contentView.alpha = 1.0;
                         }
                     }
                     completion:NULL];
    
}

- (void)setCellMode:(FNItemCellMode)cellMode {
    [self setCellMode:cellMode];
}

- (void)setCellMode:(FNItemCellMode)cellMode animated:(BOOL)animated {
    
    CGFloat duration = animated?0.3:0.0;
    
    if (cellMode == FNItemCellModeNormal) {
        [UIView animateWithDuration:duration
                         animations:^{
                             self.blurredImageView.alpha = 0.0;
                         }
                         completion:NULL];
    
    } else if (cellMode == FNItemCellModePost) {
        
        [UIView animateWithDuration:duration
                         animations:^{
                             self.blurredImageView.alpha = 1.0;
                         }
                         completion:NULL];
    }
}

- (void)setupForItem:(FNQuote *)quote {
    
    UIImage *img = [UIImage imageNamed:quote.imageName];
    self.imageView.image = img;
    self.blurredImageView.image = [img blurredImageWithRadius:15.0 iterations:3 tintColor:[UIColor blackColor]];
    
    self.quoteTextView.text = quote.quote;
    
    if (quote.contentStyle == FNItemContentStyleLight) {
        self.quoteTextView.textColor = [UIColor whiteColor];
    } else {
        self.quoteTextView.textColor = [UIColor blackColor];
    }
    
    if (quote.contentAlignment == FNItemContentAlignmentLeft) {
        self.contentView.x = CONTENT_SIDE_OFFSET;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.quoteTextView.textAlignment = NSTextAlignmentLeft;
    } else {
        self.contentView.x = self.width - self.contentView.width - CONTENT_SIDE_OFFSET;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.quoteTextView.textAlignment = NSTextAlignmentRight;
    }
    
    self.quoteTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    
    NSArray *nameWords = [quote.celebrityName componentsSeparatedByString:@" "];
    if (nameWords.count > 0) {
        NSString *btnFWDText = [NSString stringWithFormat:@"FWD now with %@", nameWords[0]];
        [self.btnFWD setTitle:btnFWDText forState:UIControlStateNormal];
        
        CGSize btnSize = [self.btnFWD sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        self.btnFWD.width = btnSize.width + 40.0;
    }
}

@end
