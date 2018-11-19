//
//  ZZTJiXuYueDuModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZTChapterlistModel;

@interface ZZTJiXuYueDuModel : NSObject<NSCoding>{
    NSString *bookName;
//    NSInteger lastChapterId;
    NSString *bookId;
    NSMutableArray *chapterArray;
    NSString *arrayIndex;
    NSString *chapterListRow;
    ZZTChapterlistModel *lastReadData;
}
//书名
@property (nonatomic,strong) NSString *bookName;

@property (nonatomic,strong) NSMutableArray *chapterArray;

@property (nonatomic,strong) NSString *bookId;
//最后一本书
@property (nonatomic,strong) NSString *chapterListRow;

@property (nonatomic,strong) NSString *arrayIndex;
//最后一次读的书
@property (nonatomic,strong) ZZTChapterlistModel *lastReadData;

@end
