//
//  ZZTChapterModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/18.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZTStoryModel;
@interface ZZTChapterModel : NSObject<NSCoding>{
    NSInteger chapterIndex;
    NSString *chapterName;
    CGPoint readPoint;
    NSString *chapterPage;
    NSInteger chapterId;
    NSMutableArray *imageUrlArray;
    NSMutableArray *imageHeightCache;
    NSString *TxTContent;
    NSString *TXTFileName;
    ZZTStoryModel *storyModel;
}

@property (nonatomic,assign) NSInteger chapterIndex;

@property (nonatomic,strong) NSString *chapterName;

@property (nonatomic,assign) CGPoint readPoint;
//第几画
@property (nonatomic,strong) NSString *chapterPage;

@property (nonatomic,assign) NSInteger chapterId;

@property (nonatomic,strong) NSMutableArray *imageUrlArray;

@property (nonatomic,strong) NSString *TxTContent;

@property (nonatomic,strong) NSString *TXTFileName;

@property (nonatomic,strong) ZZTStoryModel *storyModel;

@property (nonatomic,strong) NSMutableArray *imageHeightCache;


@end
