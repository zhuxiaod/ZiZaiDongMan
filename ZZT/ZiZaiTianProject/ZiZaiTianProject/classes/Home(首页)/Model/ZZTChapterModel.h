//
//  ZZTChapterModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/18.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZTStoryModel;
@class UserInfo;

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
    UserInfo *autherData;
    NSString *chapterType;
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

@property (nonatomic,strong) UserInfo *autherData;

@property (nonatomic,strong) NSString *chapterType;
/*
 1.chapterId            书ID
 2.chapterName          书名
 3.autherData           作者信息
 4.chapterPage          页数 1-1话
 5.chapterIndex         章节数组中的第几个
 6.readPoint            最后浏览的位置
 7.imageUrlArray        图片地址缓存(不请求网络时方便读取)
 8.imageHeightCache     高度缓存
 */
+(instancetype)initCarttonChapter:(NSInteger )chapterId chapterName:(NSString *)chapterName autherData:(UserInfo *)autherData chapterPage:(NSString *)chapterPage chapterIndex:(NSInteger )chapterIndex readPoint:(CGPoint)readPoint imageUrlArray:(NSMutableArray *)imageUrlArray imageHeightCache:(NSMutableArray *)imageHeightCache;


+(instancetype)initJxydChapterModel:(ZZTChapterlistModel *)chapterData userData:(UserInfo *)userData  readPoint:(CGPoint)readPoint imageUrlArray:(NSMutableArray *)imageUrlArray imageHeightCache:(NSMutableArray *)imageHeightCache;

/*
 1.chapterId            书ID
 2.chapterName          书名
 3.autherData           作者信息
 4.chapterPage          页数 1-1话
 5.chapterIndex         章节数组中的第几个
 6.readPoint            最后浏览的位置
 7.TxTContent           文本内容
 8.TXTFileName          文本地址
 9.storyModel           文本信息
 */
+(instancetype)initTxtChapter:(NSInteger )chapterId chapterName:(NSString *)chapterName autherData:(UserInfo *)autherData chapterPage:(NSString *)chapterPage chapterIndex:(NSInteger )chapterIndex readPoint:(CGPoint)readPoint TxTContent:(NSString *)TxTContent TXTFileName:(NSString *)TXTFileName storyModel:(ZZTStoryModel *)storyModel;

@end
