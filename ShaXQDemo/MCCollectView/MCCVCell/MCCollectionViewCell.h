//
//  MCCollectionViewCell.h
//  TableView
//
//  Created by swhl on 16/2/29.
//  Copyright © 2016年 lxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

typedef enum : NSUInteger {
    MCDeleteBtnStateNormal = 0,
    MCDeleteBtnStateEditing = 1,
} MCDeleteState;

@class MCCollectionViewCell;
@protocol MCCollectionViewCellDelegate <NSObject>

-(void)deleteCurrentItem:(MCCollectionViewCell*)item;

@end



@interface MCCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CellModel *model;
@property (nonatomic, assign) id<MCCollectionViewCellDelegate> delegate;

@property (nonatomic) MCDeleteState deleteState;

-(void)StartShakeAnimations;
-(void)StopShakeAnimations;

-(void)resetTitleName:(NSString *)name;

@end
