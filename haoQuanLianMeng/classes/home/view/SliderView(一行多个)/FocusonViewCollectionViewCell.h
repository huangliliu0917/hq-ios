//
//  FocusonViewCollectionViewCell.h
//  HighCopyTodayNews
//
//  Created by hack on 2017/8/3.
//  Copyright © 2017年 hack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FocusonModel.h"

@protocol FocusonViewCollectionViewCellDelegate <NSObject>


@end

@interface FocusonViewCollectionViewCell : UICollectionViewCell

@property(nonatomic,weak)id<FocusonViewCollectionViewCellDelegate>delegate;


@end
