//
//  CellModel.m
//  TableView
//
//  Created by swhl on 16/2/29.
//  Copyright © 2016年 lxj. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.state = MCModelStateNormal;
    }
    return self;
}

@end
