//
//  ZZTChapterlistModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTChapterlistModel.h"

@implementation ZZTChapterlistModel

@synthesize id;
@synthesize chapterId;
@synthesize cartoonId;
@synthesize chapterCover;
@synthesize chapterName;
@synthesize userId;
@synthesize commentNum;
@synthesize praiseNum;
@synthesize createdate;
@synthesize ifrelease;
@synthesize chapterPage;
@synthesize type;
@synthesize nickName;
@synthesize headimg;
@synthesize xuhuaNum;
@synthesize wordNum;
@synthesize listTotal;
@synthesize chapterMoney;
@synthesize isSelect;
@synthesize chapterType;
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

+(instancetype)initXuhuaModel:(ZZTCarttonDetailModel *)book chapterPage:(NSString *)page chapterId:(NSString *)chapterId{
    ZZTChapterlistModel *model = [[ZZTChapterlistModel alloc] init];
    model.chapterPage = page;
    model.cartoonId = book.id;
    model.bookName = book.bookName;
    model.chapterId = chapterId;
    return model;
}

@end
