//
//  ZZTHomeTableViewModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/3/28.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTHomeTableViewModel.h"

@implementation ZZTHomeTableViewModel

-(NSArray *)cellArray{
    if(_cellArray ==  nil){
        _cellArray = [NSArray array];
    }
    return _cellArray;
}

//热门数据Model
+(instancetype)initHotVCModel:(NSString *)Url title:(NSString *)title{
    ZZTHomeTableViewModel *model = [[ZZTHomeTableViewModel alloc] init];
    model.title = title;
    model.url = Url;
    return model;
}

//首页collectionViewSizeModel
+(instancetype)initHomeCollectionViewWH:(CGSize)headerWH footerWH:(CGSize)footerWH itemWH:(CGSize)itemWH{
    ZZTHomeTableViewModel *model = [[ZZTHomeTableViewModel alloc] init];
    model.headerWH = headerWH;
    model.footerWH = footerWH;
    model.itemWH = itemWH;
    return model;
}


//按钮
+(instancetype)initBtnModelWithImgUrl:(NSString *)url title:(NSString *)btnTitle{
    ZZTHomeTableViewModel *model = [[ZZTHomeTableViewModel alloc] init];
    model.btnImgUrl = url;
    model.title = btnTitle;
    return model;
}

//数据
+(instancetype)initHomeTableViewModelWithName:(NSString *)headerName cellArray:(NSArray *)cellArray url:(NSString *)urlStr cellNum:(NSString *)cellNum
{
    ZZTHomeTableViewModel *model = [[ZZTHomeTableViewModel alloc] init];
    model.cellArray = cellArray;
    model.headerName = headerName;
    model.url = urlStr;
    model.cellNum = cellNum;
    return model;
}

@end
