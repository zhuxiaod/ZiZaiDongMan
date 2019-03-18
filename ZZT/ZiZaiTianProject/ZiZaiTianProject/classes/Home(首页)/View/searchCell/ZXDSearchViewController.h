//
//  ZXDSearchViewController.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/20.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "PYSearchViewController.h"

@interface ZXDSearchViewController : UIViewController

@property (nonatomic,strong) void(^getSearchMaterialData)(ZZTDetailModel *materialModel);

@property (nonatomic,assign) BOOL isFromEditorView;

+(void)initView;

@end
