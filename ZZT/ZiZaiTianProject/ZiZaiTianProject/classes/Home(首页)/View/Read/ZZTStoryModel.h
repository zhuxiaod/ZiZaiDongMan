//
//  ZZTStoryModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTStoryModel : NSObject

@property (nonatomic,strong) NSString *chapterId;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *userId;

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger praiseNum;

@property (nonatomic,assign) NSInteger wordNum;

@property (nonatomic,assign) NSInteger commentNum;

@property (nonatomic,strong) NSString *headimg;

@property (nonatomic,strong) NSDate *createdate;

@property (nonatomic,strong) NSString *nickName;

@property (nonatomic,strong) NSString *ifpraise;

@end
