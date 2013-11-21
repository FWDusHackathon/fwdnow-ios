//
//  FNPostView.h
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FNItem;

@interface FNPostView : UIView

@property (strong, nonatomic) IBOutlet UITextView *textView;

- (void)setupForItem:(FNItem *)item;

@end
