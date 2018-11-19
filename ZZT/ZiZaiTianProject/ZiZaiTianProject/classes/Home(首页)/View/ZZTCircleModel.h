//
//  ZZTCircleModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class customer;
@interface ZZTCircleModel : NSObject
@property(nonatomic,strong) NSString *contentId;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *parentCommentId;
@property(nonatomic,strong) NSString *customerId;
@property(nonatomic,strong) NSString *chapterId;

@property(nonatomic,assign) NSInteger state;
@property(nonatomic,assign) NSInteger type;

@property(nonatomic,strong) NSString *commentDate;
@property(nonatomic,strong) NSString *commentTime;

@property(nonatomic,strong) customer *customer;

@property(nonatomic,strong) NSArray *replyComment;

@property(nonatomic,assign) NSInteger praiseNum;

@property(nonatomic,strong) NSString *ifPraise;

@property (nonatomic,assign) BOOL isOpenComment;
//图片数组
@property(nonatomic,strong) NSArray *imageArray;

@property (nonatomic,assign) NSInteger indexRow;
//高度
@property (nonatomic, strong) NSMutableArray *commentHeightArr;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat nameLabelHeight;
@property (nonatomic, assign) CGFloat contentLabelHeight;
@property (nonatomic, assign) CGFloat imgBgViewHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) CGFloat likerHeight;
@property (nonatomic, assign) BOOL isSpread; //全文是否展开


@end
