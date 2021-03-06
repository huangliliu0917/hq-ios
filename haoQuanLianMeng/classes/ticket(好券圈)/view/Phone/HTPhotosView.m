//
//  HTPhotosView.m
//  haoQuanLianMeng
//
//  Created by 罗海波 on 2018/5/30.
//  Copyright © 2018年 HT. All rights reserved.
//

#import "HTPhotosView.h"
#import "PhoneViewCell.h"
#import <UIImageView+WebCache.h>
#import "MJPhotoBrowser.h"
#import "SDPhotoBrowser.h"
#import "MJPhoto.h"

#define  kPhotoSize      kAdaptedWidth(90)
#define  kPhotoSizeSingle  kAdaptedWidth(200)
#define  kCellSpacing  kAdaptedWidth(5)

static NSString* const kIdentifier = @"Identifier";

@interface HTPhotosView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDPhotoBrowserDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *collectionViewLayout;

//资讯数据模型
@property (nonatomic, strong) HTArticleCellModel *model;

@end


@implementation HTPhotosView

- (UICollectionView *)collectionView
{
    if (!_collectionView){
        UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc] init];
        //flow.itemSize = CGSizeMake(kPhotoSize, kPhotoSize);
        flow.minimumLineSpacing = kCellSpacing;
        flow.minimumInteritemSpacing = kCellSpacing;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:flow];
        _collectionView.collectionViewLayout = flow;
        _collectionView.scrollEnabled = false;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.backgroundColor = []
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[PhoneViewCell class] forCellWithReuseIdentifier:kIdentifier];
    }
    return _collectionView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.photosArray.count == 1) {
        return CGSizeMake(kPhotoSizeSingle, kPhotoSizeSingle);
    }else{
        return CGSizeMake(kPhotoSize, kPhotoSize);
    }
}


#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupView];
    }
    return self;
}
- (void)setupView
{
//    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    LWLog(@"xxxx");
}


- (void)setPhotosArray:(NSArray<NSString*>*)photosArray
{
    _photosArray = photosArray;
    CGSize size = [self getItemSize];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
    [self.collectionView reloadData];
    
}


- (void)configArticleView:(HTArticleCellModel *)model{
    _model = model;
    
    self.smallPhotosArray = model.article.SmallImageUrls;
    self.photosArray = model.article.ImageUrls;
    [self.collectionView reloadData];
}




#pragma mark - collectionview
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    LWLog(@"%lu",(unsigned long)self.smallPhotosArray.count);
    return self.smallPhotosArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    PhoneViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(PhoneViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    
    LWLog(@"%@",self.smallPhotosArray[indexPath.row]);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.smallPhotosArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"headerMoren"]];
    //cell.imageView.tag = indexPath.row;
}
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    brower.showSaveBtn = NO;
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < self.photosArray.count; i++) {
        NSString * filePath = self.photosArray[i];
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:filePath];
        PhoneViewCell *cell = (PhoneViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        photo.srcImageView = cell.imageView; //设置来源哪一个UIImageView
        [photos addObject:photo];
    }
    brower.photos = photos;
    
    //3.设置默认显示的图片索引
    brower.currentPhotoIndex = indexPath.row;
    
    //4.显示浏览器
    [brower show];
    
    
    
}



#pragma mark -
- (CGFloat)getHeight{
    return [self getItemSize].height;
}
- (CGSize)getItemSize;
{
    UICollectionViewFlowLayout* flow = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    NSInteger count = self.photosArray.count;
    NSInteger itemsPerRow = [self itemsPerRow];
    CGSize size = CGSizeZero;
    if (count == 0){
    size = CGSizeZero;

}else if (count == 1) {
    size = CGSizeMake(kPhotoSizeSingle, kPhotoSizeSingle);
    flow.itemSize = size;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
} else {
    flow.itemSize = CGSizeMake(kPhotoSize, kPhotoSize);
    CGFloat width = itemsPerRow * (kPhotoSize + kCellSpacing);
    CGFloat height = ceilf((float)count / (float)itemsPerRow) * (kPhotoSize + kCellSpacing);
    size = CGSizeMake(width, height);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
    
    return size;
}
- (NSInteger)itemsPerRow
{
    NSInteger count = self.photosArray.count;
    if (count < 3) {
        return count;
    } else if (count <= 4) {
        return 2;
    } else {
        return 3;
    }
}


@end
