//
//  ZZTCartoonModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/16.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTCartoonModel : NSObject

@property (nonatomic,strong) NSMutableArray *cartoonArray;

@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,strong)NSString *chapterId;
@property (nonatomic,strong)NSString *cartoonUrl;
@property (nonatomic,assign)NSInteger carImgHeight;
@property (nonatomic,assign)NSUInteger index;

- (NSMutableArray *)loadDatas;


@end
