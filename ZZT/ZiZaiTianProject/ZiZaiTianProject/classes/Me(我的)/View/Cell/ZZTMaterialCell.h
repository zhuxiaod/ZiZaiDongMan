//
//  ZZTMaterialCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^tapImageBlock) (UIImageView *imageView);

@interface ZZTMaterialCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,copy) tapImageBlock buttonAction;

@property (nonatomic,strong) NSString *imageStr;

@property (strong, nonatomic) UIImageView *selectImageView;

@end
