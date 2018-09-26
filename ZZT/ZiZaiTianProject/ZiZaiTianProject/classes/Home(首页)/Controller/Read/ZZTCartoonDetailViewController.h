//
//  ZZTCartoonDetailViewController.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTJiXuYueDuModel;

@interface ZZTCartoonDetailViewController : BaseViewController
//章节
@property (nonatomic,strong) NSString *cartoonId;
@property (nonatomic,strong) NSString *viewTitle;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) ZZTJiXuYueDuModel *testModel;
//书
@property (nonatomic,strong) NSString *bookNameId;

@end
