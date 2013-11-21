//
//  FNQuoteCell.h
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import "FNItemCell.h"

@interface FNQuoteCell : FNItemCell

@property (strong, nonatomic) IBOutlet UITextView *quoteTextView;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;

- (IBAction)btnPlayPressed:(UIButton *)sender;

@end
