//
//  ZZTCartoonCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTDetailModel;
@class ZZTCarttonDetailModel;

@interface ZZTCartoonCell : UICollectionViewCell

@property (nonatomic,strong) ZZTCarttonDetailModel *cartoon;

@property (nonatomic,strong) ZZTDetailModel *materialModel;

@end
