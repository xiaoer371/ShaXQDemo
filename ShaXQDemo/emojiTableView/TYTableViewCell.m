//
//  TYTableViewCell.m
//  ShaXQDemo
//
//  Created by swhl on 16/3/3.
//  Copyright © 2016年 sprite. All rights reserved.
//

#import "TYTableViewCell.h"

@implementation TYTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addAtrribuedLabel];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addAtrribuedLabel];
    }
    return self;
}

- (void)addAtrribuedLabel
{
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    label.highlightedLinkColor = [UIColor redColor];
    [self addSubview:label];
    _label = label;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_label setFrameWithOrign:CGPointMake(0, 15) Width:CGRectGetWidth(self.frame)];

}


@end
