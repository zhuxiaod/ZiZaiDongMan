//
//  ZZTReportModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/7.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTReportModel : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,assign) NSInteger index;

+(ZZTReportModel *)initWithName:(NSString *)name Content:(NSString *)content Index:(NSInteger)index;

@end
