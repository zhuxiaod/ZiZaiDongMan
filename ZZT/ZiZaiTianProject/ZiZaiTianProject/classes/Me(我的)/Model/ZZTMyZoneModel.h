//
//  ZZTMyZoneModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTMyZoneModel : NSObject

@property (nonatomic,strong) NSString *id;

@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *nickName;

@property (nonatomic,strong) NSString *intro;

@property (nonatomic,strong) NSString *headimg;

@property (nonatomic,strong) NSString *cover;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *contentImg;

@property (nonatomic,strong) NSString *qiniu;

@property (nonatomic,strong) NSString *publishtime;

@property (nonatomic,assign) NSInteger replycount;

@property (nonatomic,strong) NSString *ifpraise;

@property (nonatomic,strong) NSString *userType;

@property (nonatomic,strong) NSString *ifConcern;

@property (nonatomic,assign) NSInteger praisecount;

@property (nonatomic,assign) NSInteger index;

@end
