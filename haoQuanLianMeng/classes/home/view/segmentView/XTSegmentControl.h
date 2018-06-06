//
//  SegmentControl.h
//  GT
//
//  Created by tage on 14-2-26.
//  Copyright (c) 2014年 cn.kaakoo. All rights reserved.
//

/**
 *  左右切换的pageControl
 *
 *  效果为X易的效果
 */

#import <UIKit/UIKit.h>

typedef void(^XTSegmentControlBlock)(NSInteger index);

@class XTSegmentControl;

@protocol XTSegmentControlDelegate <NSObject>

- (void)segmentControl:(XTSegmentControl *)control selectedIndex:(NSInteger)index;

@end

@interface XTSegmentControl : UIView

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem delegate:(id <XTSegmentControlDelegate>)delegate;



- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem andSelectColor:(UIColor *)selectColor andDefault:(UIColor *)defaultColor selectedBlock:(XTSegmentControlBlock)selectedHandle;


- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem andSelectColor:(UIColor *)selectColor andDefault:(UIColor *)defaultColor selectedBlock:(XTSegmentControlBlock)selectedHandle isShowRight:(BOOL)show;

- (void)selectIndex:(NSInteger)index;

- (void)moveIndexWithProgress:(float)progress;

- (void)endMoveIndex:(NSInteger)index;



//选中的颜色
@property (nonatomic, strong) UIColor * selectColor;
//默认的颜色
@property (nonatomic, strong) UIColor * defaultColor;

@end
