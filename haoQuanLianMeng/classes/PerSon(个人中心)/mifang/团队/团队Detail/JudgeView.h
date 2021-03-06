//
//  JudgeView.h
//  haoQuanLianMeng
//
//  Created by 罗海波 on 2018/6/21.
//  Copyright © 2018年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JudgeViewDelegate <NSObject>


- (void)select:(NSMutableDictionary *)dict;


@end



@interface JudgeView : UIView

@property (nonatomic,weak) id <JudgeViewDelegate> delegate;

@property (nonatomic,strong) NSMutableDictionary * parmae;


- (void)show;

- (void)hidden;
@end
