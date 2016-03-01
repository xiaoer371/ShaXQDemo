//
//  MCCollectionViewCell.m
//  TableView
//
//  Created by swhl on 16/2/29.
//  Copyright © 2016年 lxj. All rights reserved.
//

#import "MCCollectionViewCell.h"

const static NSInteger   xCellPaddingLeft = 8;
const static NSInteger   xCellPaddingTop  = 5;
const static NSInteger   xCellTitleHeight  = 20;

@interface MCCollectionViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIButton    *delBtn;



@end

@implementation MCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.deleteState = MCDeleteBtnStateNormal;
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xCellPaddingLeft, xCellPaddingTop, frame.size.width-2*xCellPaddingLeft, frame.size.height-3*xCellPaddingTop-xCellTitleHeight)];
        [self addSubview:_headImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCellPaddingLeft/2,CGRectGetMaxY(_headImageView.frame)+xCellPaddingTop, frame.size.width-xCellPaddingLeft, xCellTitleHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview: _titleLabel];
        
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame)-10, 3, 15, 15);
        [_delBtn setImage:[UIImage imageNamed:@"delMini.png"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delectActions:) forControlEvents:UIControlEventTouchUpInside];
        _delBtn.hidden = YES;
        [self addSubview:_delBtn];
        
    }
    return self;
}

-(void)setModel:(CellModel *)model
{
    _model = model ;
    
    _titleLabel.text = model.name;
    
    if (model.state == MCModelStateAdd) {
        _headImageView.image = [UIImage imageNamed:@"add.png"];
        self.delBtn.hidden = YES;
    }else if (model.state == MCModelStateDel){
        _headImageView.image = [UIImage imageNamed:@"delete.png"];
        self.delBtn.hidden = YES;
    }else{
        _headImageView.image = [UIImage imageNamed:@"nv.png"];
    }
    
}

-(void)setDeleteState:(MCDeleteState)deleteState
{
    _deleteState = deleteState;
    if (_deleteState == MCDeleteBtnStateNormal) {
        self.delBtn.hidden = YES;
    }else if (_deleteState == MCDeleteBtnStateEditing){
        self.delBtn.hidden = NO;
    }else{
        
    }
}
-(void)resetTitleName:(NSString *)name
{
    self.titleLabel.text = name;
}


-(void)delectActions:(UIButton *)sender
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteCurrentItem:)]) {
        [self.delegate deleteCurrentItem:self];
    }
}

#define angleToRadion(angle) (angle / 180.0 * M_PI)
-(void)StartShakeAnimations
{
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animation];
    ani.keyPath = @"transform.rotation";
    ani.values = @[@(angleToRadion(-6)),@(angleToRadion(6)),@(angleToRadion(-6))];
    ani.repeatCount = MAXFLOAT;
    ani.duration = 0.2f;
    [self.layer addAnimation:ani forKey:@"mcshake"];
}

-(void)StopShakeAnimations
{
    [self.layer removeAnimationForKey:@"mcshake"];
}

@end
