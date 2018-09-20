//
//  ZZTEditImageViewModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/27.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTEditImageViewModel.h"

@implementation ZZTEditImageViewModel

//快速创建一个对象
+(ZZTEditImageViewModel *)initImgaeViewModel:(CGRect)imageViewFrame imageUrl:(NSString *)imageUrl tagNum:(NSInteger)tagNum viewType:(NSInteger)viewType localResource:(UIImage *)localResource viewTransform:(CGAffineTransform)viewTransform{
    ZZTEditImageViewModel *imageModel = [[ZZTEditImageViewModel alloc] init];
    imageModel.imageViewFrame = imageViewFrame;
    imageModel.imageUrl = imageUrl;
    imageModel.tagNum = tagNum;
    imageModel.viewType = viewType;
    imageModel.localResource = localResource;
    imageModel.viewTransform = viewTransform;
    return imageModel;
}


@end
