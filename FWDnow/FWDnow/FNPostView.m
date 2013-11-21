//
//  FNPostView.m
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import "FNPostView.h"
#import "FNItem.h"

@implementation FNPostView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2.0;
}

- (void)setupForItem:(FNItem *)item {
    
    NSArray *nameWords = [item.celebrityName componentsSeparatedByString:@" "];
    if (nameWords.count > 0) {
        NSString *text = [NSString stringWithFormat:@"I go FWD with @%@ to support immigration reform #ready4reform", nameWords[0]];
        self.textView.text = text;
    }
}

@end
