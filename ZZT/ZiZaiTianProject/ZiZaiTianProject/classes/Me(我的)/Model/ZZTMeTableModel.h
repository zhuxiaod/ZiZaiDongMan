//
//  ZZTMeTableModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/2/27.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTMeTableModel : NSObject

@property (nonatomic,strong) NSString *cellTitle;

@property (nonatomic,strong) void(^block)();


+(instancetype)initModelWithTitle:(NSString *)title;

@end
