//
//  ZZTEditorImgCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/29.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTDetailModel;

@interface ZZTEditorImgCell : UICollectionViewCell

@property(nonatomic,assign) NSInteger cellState;

@property (nonatomic,strong) NSString *imageStr;

@property (nonatomic,strong) ZZTDetailModel *model;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) void(^deleteCell)(ZZTDetailModel *model);

@end
