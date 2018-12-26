//
//  ZZTMaterialTypeCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/25.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTKindModel;

@interface ZZTMaterialTypeCell : UICollectionViewCell

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) ZZTKindModel *model;

@end
