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
#import <MediaPlayer/MediaPlayer.h>
#import <FXBlurView/FXBlurView.h>

#define CONTENT_SIDE_OFFSET 30.0

@implementation FNQuoteCell {
    BOOL _initialized;
    MPMoviePlayerController *_player;
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

- (IBAction)btnPlayPressed:(UIButton *)sender {
    if (_player != nil) {
        [_player.view removeFromSuperview];
        _player = nil;
        
    }
    
    FNQuote *quote = (FNQuote*)_item;
    NSString *path = [[NSBundle mainBundle] pathForResource:quote.videoName ofType:nil];
    _player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    [_player prepareToPlay];
    [_player.view setFrame:self.bounds];  // player's frame must match parent's
    [self addSubview:_player.view];
    [_player play];
    _player.view.alpha = 0.01;
    [_player.view fadeIn];
    [_player setFullscreen:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidExitFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:_player];
}

- (void)movieDidExitFullscreen:(NSNotification *)notif {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:_player];
    
    //Fade out and remove the video
    [UIView animateWithDuration:0.3
                     animations:^{
                         _player.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [_player.view removeFromSuperview];
                         _player = nil;
                     }];
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
    _cellState = cellState;
    
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
    
    if (cellState == FNItemCellStateNormal && _cellMode != FNItemCellModeNormal) {
        [self setCellMode:FNItemCellModeNormal animated:animated];
    }
    
}

- (void)setCellMode:(FNItemCellMode)cellMode {
    [self setCellMode:cellMode];
}

- (void)setCellMode:(FNItemCellMode)cellMode animated:(BOOL)animated {
    
    _cellMode = cellMode;
    
    CGFloat duration = animated?0.3:0.0;
    
    if (cellMode == FNItemCellModeNormal) {
        
        [UIView animateWithDuration:duration
                         animations:^{
                             self.blurredImageView.alpha = 0.0;
                             _callView.alpha = 0.0;
                             _callView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                         }
                         completion:^(BOOL finished){
                             [_callView removeFromSuperview];
                             _callView = nil;
                         }];
        
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
    
    } else if (cellMode == FNItemCellModeCall) {
        
        if (_callView == nil) {
            NSArray *elements = [[NSBundle mainBundle] loadNibNamed:@"FNCallView" owner:nil options:nil];
            if ([elements count] > 0) {
                _callView = elements[0];
            }
            _callView.delegate = self;
        }
        
        [_callView setupForItem:_item];
        _callView.center = self.imageView.center;
        _callView.alpha = 0.0;
        [self addSubview:_callView];
        
        //We want to animate the post view to the size of the call view and then remove it
        [_postView.containerView fadeToAlpha:0.0 duration:0.1];
        
        [UIView animateWithDuration:duration
                         animations:^{
                             _postView.frame = _callView.frame;
                         }
                         completion:^(BOOL finished){
                             //Transition the views
                             [UIView animateWithDuration:duration
                                              animations:^{
                                                  _callView.alpha = 1.0;
                                                  _postView.alpha = 0.0;
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  [_postView removeFromSuperview];
                                                  _postView = nil;
                                              }];
                         }];
        
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
        
        NSString *numString = [NSString stringWithFormat:@"%d", quote.numOfForwards];
        NSString *fullNumOfForwardsText = [NSString stringWithFormat:@"%@ people have forwarded with %@", numString, nameWords[0]];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullNumOfForwardsText];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.24 green:0.50 blue:0.73 alpha:1.0] range:NSMakeRange(0, numString.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(numString.length, fullNumOfForwardsText.length-numString.length)];
        [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:NSMakeRange(0, numString.length)];
        self.numOfFowardsLabel.attributedText = attr;
    }
    
    if (quote.videoName != nil) {
        self.btnPlay.hidden = NO;
    } else {
        self.btnPlay.hidden = YES;
    }
}

@end
