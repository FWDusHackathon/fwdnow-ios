//
//  FNCallView.h
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FNItem;

@interface FNCallView : UIView

@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *powerLabel;

- (IBAction)btnCallPressed:(UIButton *)sender;
- (void)setupForItem:(FNItem *)item;

@end
