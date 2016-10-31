//
//  MCCollectionView.h
//  ShaXQDemo
//
//  Created by swhl on 16/2/29.
//  Copyright © 2016年 sprite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCCollectionView;
@class MCCollectionViewCell;
@class CellModel;

@protocol MCCollectionViewDelegate <NSObject>

@required

@optional

-(BOOL)deleteWihthItemModel:(CellModel *)model;

-(void)didSelectItem:(CellModel *)model;

-(void)addDataSourceItem;

-(void)deleteDataSourceItem;

@end


@interface MCCollectionView : UIView
{
    
}
@property (nonatomic, assign) id <MCCollectionViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray            *dataArray;
//@property (nonatomic, assign) CGPoint          originPoint;

-(instancetype)initWithFrame:(CGRect)frame
                  dataSource:(NSArray *)array;



-(void)addItemsWithModels:(NSArray <__kindof CellModel *> *)models;




@end
