//
//  ZZTJiXuYueDuModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTJiXuYueDuModel.h"

@implementation ZZTJiXuYueDuModel

@synthesize bookName;
@synthesize chapterArray;
@synthesize bookId;
@synthesize arrayIndex;
@synthesize chapterListRow;
@synthesize lastReadData;

+(instancetype)initJxydBook:(ZZTCarttonDetailModel*)model{
    ZZTJiXuYueDuModel *book = [[ZZTJiXuYueDuModel alloc] init];
    book.bookName = model.bookName;
    book.bookId = model.id;
    return book;
}


-(NSMutableArray *)chapterArray{
    if(!chapterArray){
        chapterArray = [NSMutableArray array];
    }
    return chapterArray;
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

@end
