//
//  ZZTCartoonModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/16.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCartoonModel.h"
@interface ZZTCartoonModel ()

@property (nonatomic,strong) SDWebImageManager *manager;

@end

@implementation ZZTCartoonModel

-(SDWebImageManager *)manager{
    if(_manager){
        _manager = [SDWebImageManager sharedManager];
    }
    return _manager;
}

-(NSInteger)carImgHeight{
    if(_carImgHeight){
        _carImgHeight = 0;
    }
    return _carImgHeight;
}

-(NSMutableArray *)cartoonArray{
    if(!_cartoonArray){
        _cartoonArray = [NSMutableArray array];
    }
    return _cartoonArray;
}

//加载数据
- (NSMutableArray *)loadDatas {
    NSMutableArray *muArray = [NSMutableArray array];
    if(_cartoonArray.count > 0){
        for (int i = 0; i < self.cartoonArray.count; i++) {
            ZZTCartoonModel *model = self.cartoonArray[i];
            [_manager loadImageWithURL:[NSURL URLWithString:model.cartoonUrl] options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if(!image)return ;
                CGFloat percentage;
                CGFloat imageHeight;
                if(image.size.width > Screen_Width){
                    percentage = image.size.width / Screen_Width;
                    imageHeight = image.size.height / percentage;
                }else{
                    percentage = Screen_Width / image.size.width;
                    imageHeight = image.size.height * percentage;
                }
                model.carImgHeight = imageHeight;
            }];
            [muArray addObject:model];
        }
    }
    return muArray;
}

MJCodingImplementation

-(void)setIndex:(NSUInteger)index{
    _index = index;
}

-(BOOL)isDownload{
    if(!_isDownload){
        _isDownload = NO;
    }
    return _isDownload;
}
@end
