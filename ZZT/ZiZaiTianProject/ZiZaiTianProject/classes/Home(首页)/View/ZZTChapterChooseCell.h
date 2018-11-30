//
//  ZZTChapterChooseCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTChapterChooseModel;

@interface ZZTChapterChooseCell : UICollectionViewCell

@property (nonatomic,strong) NSNumber *isChangeStyle;

@property (nonatomic,strong) ZZTChapterChooseModel *model;

@property (nonatomic,strong) NSString *str;

@end
