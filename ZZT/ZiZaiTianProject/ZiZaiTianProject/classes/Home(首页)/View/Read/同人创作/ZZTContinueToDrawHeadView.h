//
//  ZZTContinueToDrawHeadView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTCartoonModel;
@class ZZTXuHuaUserView;

typedef void (^xuHuaBtnBlock)(void);

@interface ZZTContinueToDrawHeadView : UIView

@property (nonatomic,copy) xuHuaBtnBlock buttonAction;

@property (nonatomic,strong) ZZTJiXuYueDuModel *lastReadModel;

@property (nonatomic,strong) ZZTCarttonDetailModel *bookDetail;

@property (weak, nonatomic) IBOutlet ZZTXuHuaUserView *xuHuaUserView;

@property (nonatomic,copy) void (^xuHuaBtnBlock)(void);

@property (nonatomic,strong) NSArray *array;

+(instancetype)ContinueToDrawHeadView;

-(void)pushMultiCartoonEditorVC:(ZZTChapterlistModel *)model;

@end
