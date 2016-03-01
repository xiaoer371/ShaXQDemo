//
//  ViewController.m
//  ShaXQDemo
//
//  Created by swhl on 16/2/29.
//  Copyright © 2016年 sprite. All rights reserved.
//

#import "ViewController.h"

#import "MCCollectionViewCell.h"
#import "CellModel.h"

#import "MCCollectionView.h"


//const static NSInteger   xCellRowNumber = 5;

@interface ViewController ()<MCCollectionViewDelegate>
{
    
}

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray   *dataArray;

@property (nonatomic, strong) MCCollectionView *mcView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.mcView];
}

-(MCCollectionView *)mcView
{
    if (!_mcView) {
        _mcView =[[MCCollectionView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 1) dataSource:nil];
        _mcView.delegate = self;
    }
    return _mcView;
}

-(BOOL)deleteWihthItemModel:(CellModel *)model
{
    return YES;
}

-(void)didSelectItem:(CellModel *)model
{
    NSLog(@"didSelectItem");
}

-(void)addDataSourceItem
{
    CellModel *model = [[CellModel alloc] init];
    model.name = @"test";
    [_mcView addItemsWithModels:@[model]];
}

-(void)deleteDataSourceItem
{
    NSLog(@"deleteDataSourceItem");
}


@end
