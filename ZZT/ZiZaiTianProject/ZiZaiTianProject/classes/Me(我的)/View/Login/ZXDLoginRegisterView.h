//
//  ZXDLoginRegisterView.h
//  loginDemo
//
//  Created by zxd on 2018/6/22.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^Click)(void);

@interface ZXDLoginRegisterView : UIView
//设置block
typedef void(^ButtonClick)(UIButton * sender);

typedef void(^LogBtnClick)(UIButton * sender);


@property (nonatomic,strong)UITextField *phoneNumber;

@property (nonatomic,strong)UITextField *verification;

@property (weak, nonatomic) IBOutlet GGVerifyCodeViewBtn *verificationBtn;

@property (nonatomic,copy) ButtonClick buttonAction;

@property (nonatomic,copy) LogBtnClick LogBtnClick;


+ (instancetype)loginView;

+ (instancetype)registerView;


//@property (nonatomic ,copy)Click loginClick;

@end
