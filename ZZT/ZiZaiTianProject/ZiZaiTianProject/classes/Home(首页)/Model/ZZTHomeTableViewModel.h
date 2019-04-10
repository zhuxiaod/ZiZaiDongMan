//
//  ZZTHomeTableViewModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/3/28.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTHomeTableViewModel : NSObject
//头标题
//数组
//判断是不是有footer
//点击效果
//url 请求多少个数
@property (nonatomic,strong) NSString *headerName;

@property (nonatomic,strong) NSArray *cellArray;

@property (nonatomic,strong) NSString *url;

@property (nonatomic,strong) NSString *cellNum;

/*---------------------------------------------*/
//img
@property (nonatomic,strong) NSString *btnImgUrl;
//title
@property (nonatomic,strong) NSString *title;
//block
@property (nonatomic,strong) void(^block)(void);

/*---------------------------------------------*/

//headerWH
@property (nonatomic,assign) CGSize headerWH;
//footerWH
@property (nonatomic,assign) CGSize footerWH;
//itemWH
@property (nonatomic,assign) CGSize itemWH;

/*---------------------------------------------*/

+(instancetype)initHomeCollectionViewWH:(CGSize)headerWH footerWH:(CGSize)footerWH itemWH:(CGSize)itemWH;

+(instancetype)initBtnModelWithImgUrl:(NSString *)url title:(NSString *)btnTitle;

+(instancetype)initHomeTableViewModelWithName:(NSString *)headerName cellArray:(NSArray *)cellArray url:(NSString *)urlStr cellNum:(NSString *)cellNum;

+(instancetype)initHotVCModel:(NSString *)Url title:(NSString *)title;

@end
