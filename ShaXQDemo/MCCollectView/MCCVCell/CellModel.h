//
//  CellModel.h
//  TableView
//
//  Created by swhl on 16/2/29.
//  Copyright © 2016年 lxj. All rights reserved.
//




#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MCModelStateNormal = 0,
    MCModelStateAdd = 1,
    MCModelStateDel = 2,
} MCModelState;

@interface CellModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headerUrl;
@property (nonatomic,) MCModelState state;




@end
