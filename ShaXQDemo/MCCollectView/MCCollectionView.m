//
//  MCCollectionView.m
//  ShaXQDemo
//
//  Created by swhl on 16/2/29.
//  Copyright © 2016年 sprite. All rights reserved.
//

#import "MCCollectionView.h"

#import "MCCollectionViewCell.h"

const static  CGFloat  xCellRowNumber = 5.0;

@interface MCCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,MCCollectionViewCellDelegate>
{
    NSUInteger _dataSourceNum;
    BOOL _isDelete;  
}

@property (nonatomic, strong) UICollectionView *collectView;


@end

@implementation MCCollectionView

-(instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)array
{
    
    CGFloat height =((self.frame.size.width - 80) /xCellRowNumber + 20) * (array?ceil(array.count/xCellRowNumber):2)+40;
    CGRect rect = frame.size.width==0?CGRectZero:frame;
    rect.size.height =height;
    self = [super initWithFrame:rect];
    if (self) {
         _isDelete = NO;
        [self addSubview:self.collectView];
        if (array) {
            self.dataArray =[NSMutableArray arrayWithArray:array];
        }
    }
    return self;
}

-(void)setOriginPoint:(CGPoint)originPoint
{
    _originPoint = originPoint;
    CGRect rect = self.frame;
    rect.origin.x = originPoint.x;
    rect.origin.y = originPoint.y;
    self.frame = rect;
}

-(UICollectionView *)collectView
{
    if (!_collectView) {
        
        UICollectionViewFlowLayout *collectViewLayout = [[UICollectionViewFlowLayout alloc] init];
        [collectViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        CGFloat height =((self.frame.size.width - 80) /xCellRowNumber + 20) * ceil(self.dataArray.count/xCellRowNumber)+40;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,height) collectionViewLayout:collectViewLayout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.backgroundColor = [UIColor whiteColor];
        [_collectView registerClass:[MCCollectionViewCell class] forCellWithReuseIdentifier:@"MCCollectionViewCell"];
    }
    return _collectView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"MCCollectionViewCell";
    MCCollectionViewCell * cell = (MCCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    CellModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.frame.size.width - 80) / xCellRowNumber, (self.frame.size.width - 80) /xCellRowNumber + 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 10, 20);
}

//===============
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count-1) {
        _isDelete = !_isDelete;
        NSArray *cellArray = [collectionView visibleCells];
        if (_isDelete) {
            for (MCCollectionViewCell * cell in cellArray) {
                if (cell.model.state ==MCModelStateDel) {
                    [cell resetTitleName:@"取消"];
                     continue;
                }
                if (cell.model.state ==MCModelStateAdd) {
                    continue;
                }
                [cell StartShakeAnimations];
                cell.deleteState = MCDeleteBtnStateEditing;
            }
        }else{
            for (MCCollectionViewCell * cell in cellArray) {
                cell.deleteState = MCDeleteBtnStateNormal;
                [cell StopShakeAnimations];
                if (cell.model.state ==MCModelStateDel) {
                    [cell resetTitleName:@"删除"];
                }
            }
        }
        if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteDataSourceItem)]) {
            [self.delegate deleteDataSourceItem];
            
        }
        
    }else if (indexPath.row == self.dataArray.count-2){
        if (_isDelete) {
            return;
        }
        if (self.delegate &&[self.delegate respondsToSelector:@selector(addDataSourceItem)]) {
            [self.delegate addDataSourceItem];
        }
        [self layoutCollectionViewFrame];
    }else{
        if (self.delegate &&[self.delegate respondsToSelector:@selector(didSelectItem:)]) {
            CellModel *model = self.dataArray[indexPath.row];
            [self.delegate didSelectItem:model];
        }
    }
}
#pragma mark -
-(void)deleteCurrentItem:(MCCollectionViewCell*)item
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(deleteWihthItemModel:)]) {
        NSIndexPath *indexPath =[self.collectView indexPathForCell:item];
        CellModel *model = _dataArray[indexPath.row];
        
        if ([self.delegate deleteWihthItemModel:model]) {
            _dataSourceNum = _dataArray.count;
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.collectView deleteItemsAtIndexPaths:@[indexPath]];
            [self layoutCollectionViewFrame];
        }else{
            NSLog(@"donot delete");
        }
    }
}
-(void)addItemsWithModels:(NSArray <__kindof CellModel *> *)models
{
    _dataSourceNum = _dataArray.count;
    
    for (CellModel *model  in models) {
        [_dataArray insertObject:model atIndex:_dataArray.count-2];
    }
    [self.collectView reloadData];
}

-(void)layoutCollectionViewFrame
{
    NSUInteger oldNum =ceil(_dataSourceNum/xCellRowNumber);
    NSUInteger newNum =ceil(self.dataArray.count/xCellRowNumber);
    if (oldNum != newNum) {
        
        CGFloat height =((self.frame.size.width - 80) /xCellRowNumber + 20) * ceil(self.dataArray.count/xCellRowNumber) + 40 + floor(self.dataArray.count/xCellRowNumber)*10;
        
        CGRect supRect = self.frame;
        supRect.size.height = height;
        self.frame = supRect;
        
        CGRect rect =self.collectView.frame;
        rect.size.height = height;
        self.collectView.frame =rect;
    }
}


-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray  = [[NSMutableArray alloc] init];
        
        CellModel *model1 = [[CellModel alloc] init];
        model1.name = @"添加";
        model1.state = MCModelStateAdd;
        [_dataArray addObject:model1];
        
        CellModel *model2 = [[CellModel alloc] init];
        model2.name = @"删除";
        model2.state = MCModelStateDel;
        [_dataArray addObject:model2];
    }
    return _dataArray;
}



@end
