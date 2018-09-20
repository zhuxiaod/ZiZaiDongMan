//
//  ZZTMyZoneModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTMyZoneModel : NSObject

@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *nickName;

@property (nonatomic,strong) NSString *intro;

@property (nonatomic,strong) NSString *headimg;

@property (nonatomic,strong) NSString *cover;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *contentImg;

@property (nonatomic,strong) NSString *qiniu;

@property (nonatomic,assign) NSTimeInterval publishtime;

@property (nonatomic,assign) NSInteger replycount;




@end
