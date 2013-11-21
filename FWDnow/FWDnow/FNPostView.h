//
//  FNPostView.h
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FNItem;
@protocol FNPostViewDelegate;

@interface FNPostView : UIView

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *btnFB;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;
@property (strong, nonatomic) IBOutlet UIButton *btnCongressman;

@property (weak, nonatomic) id<FNPostViewDelegate> delegate;

- (IBAction)btnFBPressed:(UIButton *)sender;
- (IBAction)btnTwitterPressed:(UIButton *)sender;
- (IBAction)btnCongressmanPressed:(UIButton *)sender;
- (IBAction)btnFWDNowPressed:(UIButton *)sender;
- (void)setupForItem:(FNItem *)item;

@end

@protocol FNPostViewDelegate <NSObject>

- (UIViewController *)viewControllerForPostViewShareViews:(FNPostView *)postView;

@end