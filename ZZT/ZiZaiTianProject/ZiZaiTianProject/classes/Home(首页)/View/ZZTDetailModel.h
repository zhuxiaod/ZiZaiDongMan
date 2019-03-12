//
//  ZZTDetailModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTDetailModel : NSObject

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,strong) NSString *img;

@property (nonatomic,strong) NSString *fodderType;

@property (nonatomic,strong) NSString *owner;

@property (nonatomic,assign) NSInteger modelType;

@property (nonatomic,assign) NSInteger flag;

@property (nonatomic,assign) NSInteger ifCollect;

@property (nonatomic,assign) NSInteger fodderId;

@property (nonatomic,strong) NSString *money;

@property (nonatomic,strong) NSString *fodderName;

@property (nonatomic,strong) NSString *ifauthor;

+(instancetype)initDetailModelWith:(NSString *)img flag:(NSInteger)flag ifCollect:(NSInteger)ifCollect;
@end
