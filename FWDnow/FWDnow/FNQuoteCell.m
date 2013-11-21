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
#import "FNPostView.h"
#import <FXBlurView/FXBlurView.h>

#define CONTENT_SIDE_OFFSET 30.0

@implementation FNQuoteCell {
    BOOL _initialized;
}

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
    
    if (_initialized) {
        return;
    }
    
    _initialized = YES;
    
    self.cellState = FNItemCellStateNormal;
    
    self.btnFWD.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnFWD.layer.borderWidth = 2.0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blurTapped:)];
    [self.blurredImageView addGestureRecognizer:tap];
    self.blurredImageView.userInteractionEnabled = YES;
}

- (IBAction)btnFWDPressed:(UIButton *)sender {
    [self setCellMode:FNItemCellModePost animated:YES];
}

- (void)blurTapped:(UITapGestureRecognizer *)tap {
    if ([tap state] == UIGestureRecognizerStateRecognized) {
        [self setCellMode:FNItemCellModeNormal animated:YES];
    }
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
        [_postView fadeOutToBottomtWithCompletion:NULL];
    
    } else if (cellMode == FNItemCellModePost) {
        
        if (_postView == nil) {
            NSArray *elements = [[NSBundle mainBundle] loadNibNamed:@"FNPostView" owner:nil options:nil];
            if ([elements count] > 0) {
                _postView = elements[0];
            }
            _postView.delegate = self;
        }
        
        [_postView setupForItem:_item];
        _postView.center = self.imageView.center;
        _postView.alpha = 0.0;
        [self addSubview:_postView];
        
        if (self.blurredImageView.image == nil) {
            self.blurredImageView.image = [self.imageView.image blurredImageWithRadius:10.0 iterations:3 tintColor:[UIColor blackColor]];
        }
        
        [UIView animateWithDuration:duration
                         animations:^{
                             self.blurredImageView.alpha = 1.0;
                         }
                         completion:NULL];
        [_postView fadeInFromBottomWithDelay:0.0 completion:NULL];
    }
}

- (void)setupForItem:(FNQuote *)quote {
    [super setupForItem:quote];
    
    UIImage *img = [UIImage imageNamed:quote.imageName];
    self.imageView.image = img;
    if (self.cellState == FNItemCellStateFull && self.cellMode != FNItemCellModeNormal) {
        self.blurredImageView.image = [img blurredImageWithRadius:10.0 iterations:3 tintColor:[UIColor blackColor]];
    } else {
        self.blurredImageView.image = nil;
    }
    
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
