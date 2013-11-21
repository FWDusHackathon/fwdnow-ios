//
//  FNCallView.m
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import "FNCallView.h"
#import "FNItem.h"

@implementation FNCallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupForItem:(FNItem *)item {
    
    NSArray *nameWords = [item.celebrityName componentsSeparatedByString:@" "];
    if (nameWords.count > 0) {
        NSString *text = [NSString stringWithFormat:@"You + %@ + %d people have Forwarded so far", nameWords[0], item.numOfForwards];
        self.leftLabel.text = text;
        
        NSString *powerText = [NSString stringWithFormat:@"Be a power supporter like %@, and do one of the following:", nameWords[0]];
        self.powerLabel.text = powerText;
    }
}

@end
