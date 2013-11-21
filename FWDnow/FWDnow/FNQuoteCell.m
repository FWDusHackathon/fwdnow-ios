//
//  FNQuoteCell.m
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import "FNQuoteCell.h"
#import "FNQuote.h"

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
}

- (void)setCellState:(FNItemCellState)cellState {
    [self setCellState:cellState animate:NO];
}

- (void)setCellState:(FNItemCellState)cellState animate:(BOOL)animated {
    
    CGFloat duration = animated?0.3:0.0;
    [UIView animateWithDuration:duration
                     animations:^{
                         if (cellState == FNItemCellStateNormal) {
                             self.quoteTextView.alpha = 0.0;
                         } else {
                             self.quoteTextView.alpha = 1.0;
                         }
                     }
                     completion:NULL];
    
}

- (void)setupForItem:(FNQuote *)quote {
    UIImage *img = [UIImage imageNamed:quote.imageName];
    self.imageView.image = img;
    
    if (quote.contentStyle == FNItemContentStyleLight) {
        self.quoteTextView.textColor = [UIColor whiteColor];
    } else {
        self.quoteTextView.textColor = [UIColor blackColor];
    }
}

@end
