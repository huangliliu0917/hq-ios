//
//  HomeSegementViewController.m
//  haoQuanLianMeng
//
//  Created by 罗海波 on 2018/5/31.
//  Copyright © 2018年 HT. All rights reserved.
//

#import "HomeSegementViewController.h"
#import "XTSegmentControl.h"
#import "HomeOtherTableViewController.h"

@interface HomeSegementViewController ()<UIScrollViewDelegate>


@property (nonatomic, strong) NSArray * titleItems;


@property (nonatomic, strong) XTSegmentControl * segmentControl;


@property(nonatomic,strong) UIScrollView * scrollView;



@property (nonatomic, strong) UIImageView * rightIcon;



@property (nonatomic,strong) UIButton * leftBtn;

@end

@implementation HomeSegementViewController


- (UIButton *)leftBtn{
    if (_leftBtn == nil) {
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setTitle:@"拼多多" forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"home_left"] forState:UIWindowLevelNormal];
        leftBtn.titleLabel.font = kAdaptedFontSize(13);
        leftBtn.frame = CGRectMake(0, 0, 40, 44);
        leftBtn.showsTouchWhenHighlighted = YES;
        leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        // 重点位置开始
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, leftBtn.titleLabel.width + 2.5, 0, -leftBtn.titleLabel.width - 2.5);
        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -leftBtn.currentImage.size.width, 0, leftBtn.currentImage.size.width);
        // 重点位置结束
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
       
    }
    
    return _leftBtn;
}

- (UIImageView *)rightIcon {
    if (_rightIcon == nil){
        _rightIcon = [[UIImageView alloc] init];
     }
    return  _rightIcon;
}

- (NSArray *)titleItems {
    if(_titleItems == nil){
        _titleItems = @[@"推荐",@"护肤",@"美食",@"女装",@"美妆",@"百货"];
    }
    return _titleItems;
}

- (void)setupScrollView
{
    // 不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = YES;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.backgroundColor = [UIColor redColor];
    scrollView.frame = self.view.bounds;
    //    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.frame.size.width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.backgroundColor = [UIColor whiteColor];
}


- (void)setupTitlesView
{


    self.segmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth , kAdaptedWidth(40)) Items:self.titleItems andSelectColor:[UIColor orangeColor] andDefault:[UIColor blackColor] selectedBlock:^(NSInteger index) {

//        [self selectCurrentOption:index];
    } isShowRight:YES];
    
    [self.segmentControl setDefaultColor:[UIColor blackColor]];
    [self.segmentControl setDefaultColor:[UIColor orangeColor]];
    [self.view addSubview:self.segmentControl];


//    self.rightIcon.frame = CGRectMake(CGRectGetMaxX(self.segmentControl.frame), 0, kAdaptedWidth(40), kAdaptedWidth(40));
//    [self.view addSubview:self.rightIcon];

}

- (void)addChildVcView
{
    // 子控制器的索引
    NSUInteger index = self.scrollView.contentOffset.x / KScreenWidth;

    // 取出子控制器
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;

    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}


- (void)setupChildViewControllers
{
    for(int i = 0; i<  self.titleItems.count; i++){
        if (i == 0){
            HomeViewController * homeViewController = [[HomeViewController alloc] init];
            [self addChildViewController:homeViewController];
        } else{
            HomeOtherTableViewController * vc = [[HomeOtherTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self addChildViewController:vc];
        }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupChildViewControllers];

    [self setupScrollView];

    [self setupTitlesView];

    [self addChildVcView];
    
    UIBarButtonItem *leftItemBtn = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    self.navigationItem.leftBarButtonItem = leftItemBtn;

}






/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildVcView];
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 选中\点击对应的按钮
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    //    HomeTitleButton *titleButton = self.titleView.subviews[index];
    //    [self.titleView titleClick:titleButton];

    [self.segmentControl selectIndex:index];
    // 添加子控制器的view
    [self addChildVcView];

    // 当index == 0时, viewWithTag:方法返回的就是self.titlesView
    //    XMGTitleButton *titleButton = (XMGTitleButton *)[self.titlesView viewWithTag:index];
}

@end

