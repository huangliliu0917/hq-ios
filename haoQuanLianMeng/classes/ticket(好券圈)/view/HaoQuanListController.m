//
//  HaoQuanListController.m
//  haoQuanLianMeng
//
//  Created by 罗海波 on 2018/6/4.
//  Copyright © 2018年 HT. All rights reserved.
//

#import "HaoQuanListController.h"
#import "AdViewController.h"


@interface HaoQuanListController ()<HTArticleCenterViewDelegate>





@end

@implementation HaoQuanListController


- (void)articleTableViewCell:(HTArticleTableViewCell *)tableViewCell selectedVideoWithDataModel:(HTArticleCellModel *)cellModel{
    
    LWLog(@"xxxxxxx");
}


//尾部刷新
- (void)refreshHeader{
    self.refreshPageIndex = 1;
    [self getArticleList:1];
}


- (void)refreshFooter{
    self.refreshPageIndex += 1;
    [self getArticleList:0];
}


//0表示头部刷新 1表示尾部刷新
- (void)getArticleList:(int)type{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"typeId"] = @(self.type);
    dict[@"pageIndex"] = @(self.refreshPageIndex);
    [[HTNetworkingTool HTNetworkingManager] HTNetworkingToolPost:@"Material/list" parame:dict isHud:YES isHaseCache:YES success:^(id json) {
        NSArray * dataArray = [HTArticleModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"data"]];
        if(type == 1){
            [self.dataArray removeAllObjects];
            //添加空白
            if (!dataArray.count) {
                KWeakSelf(self);
                [self.tableView showEmptyViewClickImageViewBlock:^(id sender) {
                    [weakself getArticleList:1];
                }];
            }else{
                [self.tableView dissmissEmptyView];
            }
        }
        [self.dataArray addObjectsFromArray:dataArray];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [MJRefreshHeader]
    
    
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 500;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(kAdaptedWidth(41), 0, 0, 0);
    [self refreshHeader];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //AdViewController * ac = [[AdViewController alloc] init];
//
//        AdViewController * ac = [[AdViewController alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];
//        //ac.delegate = self;
//        [self.view.window addSubview:ac];
//        [ac show];
//    });
    
    
//    Material/list
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    [self.tableView showEmptyView];
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HTArticleModel * a = [self.dataArray objectAtIndex:indexPath.row];
    return [HTArticleCellModel confirmCellWithArticle:a isDiscover:NO slideType:self.type WithTableView:tableView witdDelegate:self];
   
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
