//
//  TiXianBottomTableViewCell.h
//  haoQuanLianMeng
//
//  Created by 罗海波 on 2018/6/20.
//  Copyright © 2018年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WoYaoTiXian.h"

@interface TiXianBottomTableViewCell : UITableViewCell

- (void)configure:(WoYaoTiXian *)model;


- (int)getTixinMoney;

@end
