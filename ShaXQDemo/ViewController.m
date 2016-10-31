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
#import "TYTableViewCell.h"
#import "RegExCategories.h"

#import "MCShapeView.h"


//const static NSInteger   xCellRowNumber = 5;

@interface ViewController ()<MCCollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
}

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray   *dataArray;
@property (nonatomic, strong) MCCollectionView *mcView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MCShapeView *shapeView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.shapeView];
    
//    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.mcView];
}



-(MCShapeView *)shapeView
{
    if (!_shapeView) {
        _shapeView = [[MCShapeView alloc] initWithFrame:CGRectMake(0,80, 80, 80)];
    }
    return _shapeView;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 80, 320, 400) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[TYTableViewCell class] forCellReuseIdentifier:@"TYTableViewCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TYTableViewCell" forIndexPath:indexPath];
    cell.label.textContainer = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYTextContainer *textContaner = self.dataArray[indexPath.row];
    
    NSLog(@"textContaner.textHeight+30 ==%d",textContaner.textHeight+30);
    
    
    return textContaner.textHeight+30;// after createTextContainer, have value
    
    
    
    
}



-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        
        for (int i = 0; i<500; i++) {
            
           
            
            NSArray *arr = @[@"@青春[大笑]励志: [哈哈]其实所有漂泊的人，[哈哈]不过是为了有一天能 [微笑]够不再漂泊，[哈哈][哈哈]能用自己的力量 [微笑]撑起身后的家人和自己爱 [微笑]的人。 [haha,15,15]#青春[大笑]励志#[button]",@"[哈哈]其实所[大笑]有漂泊的人",@"不过是 [微笑]为[大笑][大笑]了有一天能够不再",@"[哈哈哈][哈哈][哈哈] [微笑][哈哈][大笑][哈哈]"];
            
            NSString *text =arr[arc4random() % 4];
            
            // 属性文本生成器
            TYTextContainer *textContainer = [[TYTextContainer alloc]init];
            textContainer.text = text;
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            Rx *rx =RX(@"\\[[^\\]]+\\]");
            NSArray *array = [rx matchesWithDetails:text];
            
            NSDictionary *dic =@{@"[哈哈]":@"emoji_003", @"[微笑]": @"emoji_001",@"[大笑]":@"emoji_002"};
            
            for (RxMatch *match  in array) {
                
//                NSLog(@"rxMatch.value ==%@",match.value);
                TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
                imageStorage.cacheImageOnMemory = YES;
                
                NSString *str = dic[match.value];
                if (str) {
                    imageStorage.imageName = str;
                }else continue;
                
                imageStorage.range = match.range;
                imageStorage.size = CGSizeMake(15, 15);
                
                [tmpArray addObject:imageStorage];
                
            }
            [textContainer addTextStorageArray:tmpArray];
            textContainer = [textContainer createTextContainerWithTextWidth:320.0f];

            [_dataArray  addObject:textContainer];
        }

    }
    return _dataArray;
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
