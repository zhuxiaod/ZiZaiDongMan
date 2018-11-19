//
//  ZZTChapterlistModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTChapterlistModel : NSObject<NSCoding>{
    NSInteger id;
    
    NSString *chapterId;
    
    NSString *cartoonId;
    
    NSString *chapterCover;
    
    NSString *chapterName;
    
    NSString *userId;
    
    NSString *commentNum;
    
    NSInteger praiseNum;
    
    NSDate *createdate;
    
    NSInteger ifrelease;
    
    NSString *chapterPage;
    
    NSString *type;
    
    NSString *nickName;
    
    NSString *headimg;
    
    NSString *xuhuaNum;
    
    NSInteger wordNum;
    
    NSInteger listTotal;
}

@property(nonatomic,assign)NSInteger id;

@property(nonatomic,strong)NSString *chapterId;

@property(nonatomic,strong)NSString *cartoonId;

@property(nonatomic,strong)NSString *chapterCover;

@property(nonatomic,strong)NSString *chapterName;

@property(nonatomic,strong)NSString *userId;

@property(nonatomic,strong)NSString *commentNum;

@property(nonatomic,assign)NSInteger praiseNum;

@property(nonatomic,strong)NSDate *createdate;

@property(nonatomic,assign)NSInteger ifrelease;

@property(nonatomic,strong)NSString *chapterPage;

@property(nonatomic,strong)NSString *type;

@property(nonatomic,strong)NSString *nickName;

@property(nonatomic,strong)NSString *headimg;

@property(nonatomic,strong)NSString *xuhuaNum;

@property(nonatomic,assign)NSInteger wordNum;

@property(nonatomic,assign)NSInteger listTotal;

@end
