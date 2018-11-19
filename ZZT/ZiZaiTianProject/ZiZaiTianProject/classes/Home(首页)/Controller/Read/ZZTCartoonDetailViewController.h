//
//  ZZTCartoonDetailViewController.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTJiXuYueDuModel;
@class ZZTChapterlistModel;
@class ZZTCarttonDetailModel;
@class ZZTChapterModel;
@interface ZZTCartoonDetailViewController : BaseViewController
//章节
//@property (nonatomic,strong) NSString *cartoonId;
@property (nonatomic,strong) ZZTChapterlistModel *dataModel;
@property (nonatomic,strong) ZZTCarttonDetailModel *cartoonModel;
@property (nonatomic,strong) ZZTJiXuYueDuModel *testModel;
@property (nonatomic,assign) NSInteger indexRow;

@property (nonatomic,strong) ZZTCarttonDetailModel *collectModel;
//书
//@property (nonatomic,strong) NSString *bookNameId;
//继续阅读判断
@property (nonatomic,strong) ZZTChapterlistModel *lastReadModel;
@end
