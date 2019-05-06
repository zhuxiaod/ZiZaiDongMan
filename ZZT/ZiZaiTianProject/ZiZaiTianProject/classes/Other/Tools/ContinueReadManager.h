//
//  ContinueReadManager.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/16.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN
@class ZZTCarttonDetailModel;

@interface ContinueReadManager : NSObject

//阅读书架
@property (nonatomic,strong)NSMutableArray *bookReadedArray;

+(instancetype)sharedInstance;

//保存地址
-(NSMutableArray *)getContinueReadArray;

//查询书
-(NSInteger)isHaveThisBook:(ZZTCarttonDetailModel *)book;

//保存数据
-(void)saveBookReadedArray;

//添加书籍
-(void)addReadedBookWithChapter:(ZZTChapterlistModel *)chapterData bookModel:(ZZTCarttonDetailModel *)bookModel chapterModel:(ZZTChapterModel *)chapterModel;

//替换章节
-(void)replaceReadedBookWithChapter:(ZZTChapterModel *)chapterModel bookModel:(ZZTCarttonDetailModel *)bookModel readedIndex:(NSInteger)readedIndex chapterData:(ZZTChapterlistModel *)chapterData;

-(ZZTJiXuYueDuModel *)getJuXuYueDuModelWithBookId:(NSString *)bookId;

@end

//NS_ASSUME_NONNULL_END
