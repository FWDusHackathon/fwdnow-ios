//
//  FNViewController.h
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
