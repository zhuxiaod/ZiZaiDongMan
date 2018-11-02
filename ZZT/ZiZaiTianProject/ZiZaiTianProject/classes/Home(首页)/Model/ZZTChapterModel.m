//
//  ZZTChapterModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/18.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTChapterModel.h"

@implementation ZZTChapterModel

@synthesize chapterIndex;
@synthesize chapterName;
@synthesize readPoint;
@synthesize chapterPage;
@synthesize chapterId;
@synthesize imageUrlArray;
@synthesize TxTContent;
@synthesize TXTFileName;
@synthesize storyModel;
@synthesize imageHeightCache;
@synthesize autherData;

-(NSMutableArray *)imageUrlArray{
    if(!imageUrlArray){
        imageUrlArray = [NSMutableArray array];
    }
    return imageUrlArray;
}

-(NSMutableArray *)imageHeightCache{
    if(!imageHeightCache){
        imageHeightCache = [NSMutableArray array];
    }
    return imageHeightCache;
}

// 归档属性
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    // c语言特点：函数的参数如果是基本数据类型，基本是需要函数内部修改他的值
    // 申明一个变量，便于内部将内部参数数量返回给count
    unsigned int count = 0;
    // C语言函数带有copy字样会在堆内存开辟一块空间 此区域ARC不管 需要手动释放！！
    Ivar *ivars = class_copyIvarList([self class], &count); for (int i = 0; i < count; i++) {
        // 拿到ivar
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
        
    } free(ivars);
    
}
// 解档属性
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            // 拿到ivar
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            // 解档
            id value = [aDecoder decodeObjectForKey:key];
            // kvc 赋值
            [self setValue:value forKey:key];
            
        } free(ivars);
        
    } return self;
}

+(instancetype)initCarttonChapter:(NSInteger)chapterId chapterName:(NSString *)chapterName autherData:(UserInfo *)autherData chapterPage:(NSString *)chapterPage chapterIndex:(NSInteger)chapterIndex readPoint:(CGPoint)readPoint imageUrlArray:(NSMutableArray *)imageUrlArray imageHeightCache:(NSMutableArray *)imageHeightCache{
    ZZTChapterModel *model = [[ZZTChapterModel alloc] init];
    model.chapterName = chapterName;//章节名
    model.chapterPage = chapterPage;//章节字数  多少画
    model.chapterIndex = chapterIndex;//第几行
    model.chapterId = chapterId;//章节id
    model.readPoint = readPoint;
    model.autherData = autherData;
    model.imageUrlArray = imageUrlArray;
    model.imageHeightCache = imageHeightCache;
    return model;
}
+(instancetype)initTxtChapter:(NSInteger )chapterId chapterName:(NSString *)chapterName autherData:(UserInfo *)autherData chapterPage:(NSString *)chapterPage chapterIndex:(NSInteger )chapterIndex readPoint:(CGPoint)readPoint TxTContent:(NSString *)TxTContent TXTFileName:(NSString *)TXTFileName storyModel:(ZZTStoryModel *)storyModel{
    ZZTChapterModel *model = [[ZZTChapterModel alloc] init];
    model.chapterName = chapterName;//章节名
    model.chapterPage = chapterPage;//章节字数  多少画
    model.chapterIndex = chapterIndex;//第几行
    model.chapterId = chapterId;//章节id
    model.readPoint = readPoint;
    model.autherData = autherData;
    model.TxTContent = TxTContent;
    model.TXTFileName = TXTFileName;
    model.storyModel = storyModel;
    return model;
}

@end
