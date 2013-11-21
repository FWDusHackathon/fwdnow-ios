//
//  FNViewController.m
//  FWDnow
//
//  Created by Emerson Malca on 11/21/13.
//  Copyright (c) 2013 FWDus. All rights reserved.
//

#import "FNViewController.h"
#import "FNQuote.h"

@interface FNViewController ()

@end

@implementation FNViewController {
    NSMutableArray *_items;
    NSIndexPath *_expandedIndexPath;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FNQuote *quote = [[FNQuote alloc] init];
    quote.celebrityName = @"Shakira";
    quote.quote = @"“Immigration reform isn’t about politics. It’s about people-mothers, kids. Obama is working for all of them”";
    quote.numOfForwards = 40321;
    quote.imageName = @"Shakira.jpg";
    quote.contentStyle = FNItemContentStyleLight;
    [_items addObject:quote];
    
    quote = [[FNQuote alloc] init];
    quote.celebrityName = @"Kim Kardashian";
    quote.quote = @"#FWDnow and support immigration reform with me";
    quote.numOfForwards = 40321;
    quote.imageName = @"Kim.jpg";
    quote.contentStyle = FNItemContentStyleLight;
    quote.contentAlignment = FNItemContentAlignmentRight;
    [_items addObject:quote];
    
    quote = [[FNQuote alloc] init];
    quote.celebrityName = @"Kanye West";
    quote.quote = @"#FWDnow and support immigration reform with me";
    quote.numOfForwards = 40321;
    quote.imageName = @"Kanye.jpg";
    quote.contentStyle = FNItemContentStyleLight;
    [_items addObject:quote];
    
    quote = [[FNQuote alloc] init];
    quote.celebrityName = @"Julianne Moore";
    quote.quote = @"“Immigration reform will put 11 million people living in the United States on a pathway to citizenship”";
    quote.numOfForwards = 40321;
    quote.imageName = @"Julianne.jpg";
    quote.contentStyle = FNItemContentStyleDark;
    [_items addObject:quote];
    
    quote = [[FNQuote alloc] init];
    quote.celebrityName = @"Taboo";
    quote.quote = @"Taboo's new song opposing Arizona's Bill 1070 against illegal immigration";
    quote.numOfForwards = 40321;
    quote.imageName = @"Taboo.jpg";
    quote.contentStyle = FNItemContentStyleLight;
    [_items addObject:quote];
    
    //Start with teh first one expanded
    _expandedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FNQuoteCell" bundle:nil] forCellWithReuseIdentifier:@"FNQuoteCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FNHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FNHeader"];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark Collection view methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_items count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FNHeader" forIndexPath:indexPath];
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FNItemCell *cell = nil;
    id resource = [_items objectAtIndex:indexPath.row];
    if ([resource isKindOfClass:[FNQuote class]]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FNQuoteCell" forIndexPath:indexPath];
        cell.delegate = self;
        FNQuote *quote = (FNQuote *)resource;
        [(FNQuoteCell*)cell setupForItem:quote];
    }
    
    if (_expandedIndexPath != nil && [_expandedIndexPath compare:indexPath] == NSOrderedSame) {
        cell.cellState = FNItemCellStateFull;
    } else {
        cell.cellState = FNItemCellStateNormal;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_expandedIndexPath != nil && [_expandedIndexPath compare:indexPath] == NSOrderedSame) {
        return [FNItemCell sizeForState:FNItemCellStateFull];
    }
    return [FNItemCell sizeForState:FNItemCellStateNormal];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //If it is the one that is already expanded we just ignore it
    if (_expandedIndexPath != nil && [_expandedIndexPath compare:indexPath] == NSOrderedSame) {
        return;
    }
    
    //Expand the one just tapped
    NSIndexPath *previousIndexPath = _expandedIndexPath;
    _expandedIndexPath = indexPath;
    
    //We might need to move the cell right before the one we are going to expand to right after if there is on even number of
    //before
    BOOL switchCellBeforeExpanded = NO;
    NSInteger indexOffset = -1;
    if (indexPath.item%2 != 0 && indexPath.item != 0) {
        switchCellBeforeExpanded = YES;
        if ([previousIndexPath compare:_expandedIndexPath] == NSOrderedDescending) {
            indexOffset = 1;
        }
        [_items exchangeObjectAtIndex:_expandedIndexPath.item+indexOffset withObjectAtIndex:_expandedIndexPath.item];
        _expandedIndexPath = [NSIndexPath indexPathForItem:indexPath.item+indexOffset inSection:indexPath.section];
    }
    
    [collectionView performBatchUpdates:^{
        
        //Check to see if we need to do switching logic
        if (switchCellBeforeExpanded) {
            //Don't forget that expandedIndexPath has already been updated by now
            [collectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:_expandedIndexPath.item inSection:_expandedIndexPath.section] toIndexPath:[NSIndexPath indexPathForItem:_expandedIndexPath.item-indexOffset inSection:_expandedIndexPath.section]];
            
            if (previousIndexPath != nil) {
                if ([previousIndexPath compare:_expandedIndexPath] == NSOrderedSame) {
                    //Special case
                    if (previousIndexPath.item == 0) {
                        FNItemCell *cell = (FNItemCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_expandedIndexPath.item+1 inSection:_expandedIndexPath.section]];
                        [cell setCellState:FNItemCellStateFull animate:YES];
                        FNItemCell *prevCell = (FNItemCell*)[collectionView cellForItemAtIndexPath:previousIndexPath];
                        [prevCell setCellState:FNItemCellStateNormal animate:YES];
                    
                    } else {
                        FNItemCell *cell = (FNItemCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_expandedIndexPath.item-indexOffset inSection:_expandedIndexPath.section]];
                        [cell setCellState:FNItemCellStateFull animate:YES];
                        FNItemCell *prevCell = (FNItemCell*)[collectionView cellForItemAtIndexPath:previousIndexPath];
                        [prevCell setCellState:FNItemCellStateNormal animate:YES];
                    }
                    
                } else {
                    FNItemCell *cell = (FNItemCell*)[collectionView cellForItemAtIndexPath:previousIndexPath];
                    [cell setCellState:FNItemCellStateFull animate:YES];
                }
                
            }
        
        } else {
            //Normal logic
            if (previousIndexPath != nil) {
                FNItemCell *cell = (FNItemCell*)[collectionView cellForItemAtIndexPath:previousIndexPath];
                [cell setCellState:FNItemCellStateNormal animate:YES];
            }
            
            FNItemCell *cell = (FNItemCell*)[collectionView cellForItemAtIndexPath:_expandedIndexPath];
            [cell setCellState:FNItemCellStateFull animate:YES];
        }
    }
                             completion:^(BOOL finished){
                                 
                             }];
}

#pragma mark - FNItemCellDelegate

- (UIViewController *)viewControllerForItemCell:(FNItemCell *)cell {
    return self;
}

@end
