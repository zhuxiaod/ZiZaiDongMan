
//
//  ContinueReadManager.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/16.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ContinueReadManager.h"
#import "ZZTCarttonDetailModel.h"
#import "ZZTChapterlistModel.h"
#import "ZZTJiXuYueDuModel.h"

@implementation ContinueReadManager

+ (instancetype)sharedInstance
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ContinueReadManager alloc] init];
    });
    
    return instance;
}

//取出数据
-(NSMutableArray *)getContinueReadArray{
    NSMutableArray *arrayDict = [NSKeyedUnarchiver unarchiveObjectWithFile:JiXuYueDuAPI];
    
    if (arrayDict == nil) {
        arrayDict = [NSMutableArray array];
    }
    return arrayDict;
}

-(NSMutableArray *)bookReadedArray{
    
    _bookReadedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:JiXuYueDuAPI];
    if (_bookReadedArray == nil) {
        _bookReadedArray = [NSMutableArray array];
    }
    return _bookReadedArray;
}

//保存数据
-(void)saveBookReadedArray{
    //存
    NSString *path = JiXuYueDuAPI;
    
    [NSKeyedArchiver archiveRootObject:_bookReadedArray toFile:path];
}
//书 章节

//查询书
-(NSInteger)isHaveThisBook:(ZZTCarttonDetailModel *)book{
    //先看有没有这篇文章
    NSInteger arrayIndex = -1;
    //因为有很多本书 所以会有很多对象
    for (NSInteger i = 0; i < self.bookReadedArray.count; i++) {
        ZZTJiXuYueDuModel *bookModel = _bookReadedArray[i];
        if([bookModel.bookId isEqualToString:book.id]){
            //证明有这一本书
            arrayIndex = i;
            break;
        }
    }
    return arrayIndex;
}

//没有此书  添加
-(void)addReadedBookWithChapter:(ZZTChapterlistModel *)chapterData bookModel:(ZZTCarttonDetailModel *)bookModel chapterModel:(ZZTChapterModel *)chapterModel{
    ZZTJiXuYueDuModel *jxydBook = [ZZTJiXuYueDuModel initJxydBook:bookModel];

    if([chapterData.chapterType isEqualToString:@"1"]){
        jxydBook.lastReadData = chapterData;
    }else{
        jxydBook.lastMultiReadData = chapterData;
    }
    
    [jxydBook.chapterArray addObject:chapterModel];
    [_bookReadedArray addObject:jxydBook];
    //保存信息
    [self saveBookReadedArray];
}

-(void)replaceReadedBookWithChapter:(ZZTChapterModel *)chapterModel bookModel:(ZZTCarttonDetailModel *)bookModel readedIndex:(NSInteger)readedIndex chapterData:(ZZTChapterlistModel *)chapterData{
    
    //取出这本书
    ZZTJiXuYueDuModel *readModel = _bookReadedArray[readedIndex];
    
    //查有没有这个章节
    BOOL isChapterHave = NO;
    NSInteger chapterIndex = 0;
    for (int i = 0; i < readModel.chapterArray.count; i++) {
        ZZTChapterModel *chapterM = readModel.chapterArray[i];
        //查看ID 和 类型是否一致
        if(chapterModel.chapterId == chapterM.chapterId && [chapterModel.chapterType isEqualToString:chapterM.chapterType]){
            isChapterHave = YES;
            chapterIndex = i;
            break;
        }
    }
    
    //如果有这个章节
    if(isChapterHave == YES){
        //在数组之中的位置
        //            readModel.arrayIndex = [NSString stringWithFormat:@"%ld",index];
        [readModel.chapterArray replaceObjectAtIndex:chapterIndex withObject:chapterModel];
    }else{
        //            readModel.arrayIndex = [NSString stringWithFormat:@"%ld",readModel.chapterArray.count];
        [readModel.chapterArray addObject:chapterModel];
    }
    readModel.arrayIndex = [NSString stringWithFormat:@"%ld",isChapterHave == YES?chapterIndex:readModel.chapterArray.count];
    //添加最后一次读的是原版 还是 同人
    //        if(readModel.chapter)
    if([chapterData.chapterType isEqualToString:@"1"]){
        readModel.lastReadData = chapterData;
    }else{
        readModel.lastMultiReadData = chapterData;
    }
    
//    readModel.chapterListRow = [NSString stringWithFormat:@"%ld",self.indexRow];
    [_bookReadedArray replaceObjectAtIndex:readedIndex withObject:readModel];
    
    //保存信息
    [self saveBookReadedArray];
}

-(ZZTJiXuYueDuModel *)getJuXuYueDuModelWithBookId:(NSString *)bookId{

    ZZTJiXuYueDuModel *model = [[ZZTJiXuYueDuModel alloc] init];
    for (int i = 0; i < _bookReadedArray.count; i++) {
        //看这个数组里面的模型是否有这本书
        model = _bookReadedArray[i];
        if([model.bookId isEqualToString:bookId]){
            break;
        }
    }
    return model;
}
@end
