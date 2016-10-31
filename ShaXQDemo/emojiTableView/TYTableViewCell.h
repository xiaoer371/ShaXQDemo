//
//  TYTableViewCell.h
//  ShaXQDemo
//
//  Created by swhl on 16/3/3.
//  Copyright © 2016年 sprite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAttributedLabel.h"

@interface TYTableViewCell : UITableViewCell

@property (nonatomic, weak, readonly) TYAttributedLabel *label;

@end
