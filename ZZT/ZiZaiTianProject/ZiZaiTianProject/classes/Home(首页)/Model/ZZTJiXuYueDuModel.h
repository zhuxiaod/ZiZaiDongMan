//
//  ZZTJiXuYueDuModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTJiXuYueDuModel : NSObject<NSCoding>{
    NSString *bookName;
    NSString *bookContentId;
    NSString *bookId;
    NSString *bookChapter;
    CGPoint readPoint;
    NSString *chapterIndex;
}
//书名
@property (nonatomic,strong) NSString *bookName;
//看内容的行数
@property (nonatomic,strong) NSString *bookContentId;
//章节ID
//@property (nonatomic,strong) NSString *bookChapter;
//书id
@property (nonatomic,strong) NSString *bookId;
//第几画
@property (nonatomic,strong) NSString *bookChapter;

@property (nonatomic,assign) CGPoint readPoint;

@property (nonatomic,strong) NSString *chapterIndex;

@end
