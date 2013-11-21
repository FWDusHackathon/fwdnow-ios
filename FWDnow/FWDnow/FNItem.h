//
//  FNItem.h
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FNItemContentStyle) {
    FNItemContentStyleLight = 0,
    FNItemContentStyleDark
};

typedef NS_ENUM(NSInteger, FNItemContentAlignment) {
    FNItemContentAlignmentLeft = 0,
    FNItemContentAlignmentRight
};

@interface FNItem : NSObject

@property (strong, nonatomic) NSString *celebrityName;
@property (strong, nonatomic) NSString *imageName;
@property (nonatomic) NSUInteger numOfForwards;
@property (nonatomic) FNItemContentStyle contentStyle;
@property (nonatomic) FNItemContentAlignment contentAlignment;

@end
