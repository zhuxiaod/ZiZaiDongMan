//
//  ZZTCarttonDetailModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/11.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTCarttonDetailModel : NSObject

@property (nonatomic,strong) NSString *id;

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *bookName;
@property (nonatomic,strong) NSString *intro;
@property (nonatomic,strong) NSString *cover;
@property (nonatomic,strong) NSString *bookType;
@property (nonatomic,strong) NSString *type;

@property (nonatomic,assign) NSInteger clickNum;
@property (nonatomic,assign) NSInteger collectNum;
@property (nonatomic,assign) NSInteger praiseNum;

@property (nonatomic,strong) NSDate *createTime;

@property (nonatomic,strong) NSString *recordNum;
@property (nonatomic,strong) NSString *ifConcern;

@property (nonatomic,strong) NSString *cartoonType;

@property (nonatomic,strong) NSString *ifrelease;
@property (nonatomic,strong) NSString *ifCollect;
@property (nonatomic,assign) NSInteger commentNum;
@property (nonatomic,strong) NSString *cartoonId;

@property (nonatomic,assign) BOOL isHave;
//补充
@property (nonatomic,strong) NSString *chapterCover;

@property (nonatomic,strong) NSString *headimg;

@property (nonatomic,strong) NSString *browseType;

@property (nonatomic,strong) NSString *qiniu;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *contentImg;

@property (nonatomic,strong) NSString *nickName;

@property (nonatomic,strong) NSString *lbCover;

@property (nonatomic,strong) NSString *ifauthor;

@property (nonatomic,strong) NSString *serialize;

//素材
@property (nonatomic,strong) NSString *img;

@property (nonatomic,strong) NSString *fodderType;

@property (nonatomic,strong) NSString *owner;

@property (nonatomic,assign) NSInteger modelType;

@property (nonatomic,assign) NSInteger flag;

@property (nonatomic,assign) NSInteger fodderId;

@property (nonatomic,strong) NSString *money;

@property (nonatomic,strong) NSString *fodderName;

@property (nonatomic,assign) CGFloat rowHeight;


@end
