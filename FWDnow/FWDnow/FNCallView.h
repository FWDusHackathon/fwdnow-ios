//
//  FNCallView.h
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FNItem;
@protocol FNCallViewDelegate;

@interface FNCallView : UIView

@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) id<FNCallViewDelegate> delegate;

- (IBAction)btnCallPressed:(UIButton *)sender;
- (IBAction)btnSendPressed:(UIButton *)sender;
- (void)setupForItem:(FNItem *)item;

@end

@protocol FNCallViewDelegate <NSObject>

- (void)callViewDidCall:(FNCallView *)callView;
- (void)callViewDidSendPostCard:(FNCallView *)callView;

@end
