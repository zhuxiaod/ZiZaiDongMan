//
//  ZZTAssociatedPhoneViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/25.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTAssociatedPhoneViewController.h"

@interface ZZTAssociatedPhoneViewController ()

@property (nonatomic,strong) UITextField *phoneTF;
@property (nonatomic,strong) UITextField *codeTF;
@property (nonatomic,strong) GGVerifyCodeViewBtn *codeBtn;
@property (nonatomic,strong) UIButton *nextBtn;
@end

@implementation ZZTAssociatedPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _viewTitle;
    
    [self addBackBtn];
    
    [self.viewNavBar.centerButton setTitle:@"绑定手机号" forState:UIControlStateNormal];
    
    //请先验证你的手机号
    UIView *phoneView = [[UIView alloc] init];
    phoneView.backgroundColor = [UIColor whiteColor];
    phoneView.layer.cornerRadius = 6.0f;
    [self.view addSubview:phoneView];
    
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewNavBar.mas_bottom).offset(16);
        make.right.equalTo(self.viewNavBar).offset(-16);
        make.left.equalTo(self.viewNavBar).offset(16);
        make.height.mas_equalTo(30);
    }];
    
    //phoneTF
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.placeholder = @"请输入您的电话号码";
    phoneTF.textColor = [UIColor blackColor];
    phoneTF.textAlignment = NSTextAlignmentLeft;
    phoneTF.borderStyle = UITextBorderStyleNone;
    phoneTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.layer.cornerRadius = 4;
    self.phoneTF = phoneTF;
    [phoneView addSubview:phoneTF];
    
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_top).offset(0);
        make.left.equalTo(phoneView.mas_left).offset(4);
        make.bottom.equalTo(phoneView.mas_bottom).offset(0);
        make.width.equalTo(phoneView).multipliedBy(1);
    }];
    
    //验证码
    //验证码View
    UIView *codeView = [[UIView alloc] init];
    codeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:codeView];
    
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom).offset(8);
        make.right.equalTo(phoneView);
        make.left.equalTo(phoneView);
        make.height.mas_equalTo(30);
    }];
    codeView.layer.cornerRadius = 6.0f;
    
    UITextField *codeTF = [[UITextField alloc] init];
    codeTF.placeholder = @"请输入验证码";
    codeTF.textColor = [UIColor blackColor];
    codeTF.textAlignment = NSTextAlignmentLeft;
    codeTF.borderStyle = UITextBorderStyleNone;
    codeTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.layer.cornerRadius = 4;
    self.codeTF = codeTF;
    [codeView addSubview:codeTF];
    
    [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.mas_top).offset(0);
        make.left.equalTo(codeView.mas_left).offset(4);
        make.bottom.equalTo(codeView.mas_bottom).offset(0);
        make.width.equalTo(codeView).multipliedBy(0.6);
    }];
    
    GGVerifyCodeViewBtn *codeBtn = [[GGVerifyCodeViewBtn alloc] init];
    [codeBtn setTitle:@"验证码" forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(codeBtnVerification) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:codeBtn];
    self.codeBtn = codeBtn;
    
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.mas_top).offset(2);
        make.right.equalTo(codeView.mas_right).offset(-8);
        make.bottom.equalTo(codeView.mas_bottom).offset(-2);
        make.width.equalTo(codeView).multipliedBy(0.3);
    }];
    
    //下一步按钮
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundColor:ZZTSubColor];
    nextBtn.layer.cornerRadius = 10.0f;
    nextBtn.enabled = NO;
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.mas_bottom).offset(20);
        make.right.equalTo(codeView);
        make.left.equalTo(codeView);
        make.height.mas_equalTo(30);
    }];
    [nextBtn addTarget:self action:@selector(doneTarget) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextBtn;
    [self.phoneTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.codeTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}

-(void)textChange{
    self.nextBtn.enabled = self.phoneTF.text.length && self.codeTF.text.length;
}

-(void)codeBtnVerification{
    if ([ZXDCheckContent checkTelNumber:self.phoneTF.text]) {
        NSDictionary *paramDict = @{
                                    @"phone":self.phoneTF.text
                                    };
        AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
        [manager POST:[ZZTAPI stringByAppendingString:@"login/sendMsg"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        [self.codeBtn timeFailBeginFrom:60];
    }else{
        //不是电话号码
//        [MBProgressHUD showMessage:@"请输入正确的电话号码"];
        [MBProgressHUD showSuccess:@"请输入正确的电话号码"];
    }
}

-(void)doneTarget{
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    NSDictionary *dict = @{
                              @"checkCode":self.codeTF.text,
                              @"phone":self.phoneTF.text,
                              @"userId":[NSString stringWithFormat:@"%ld",user.id]
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"login/upUserPhone"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@",responseObject);
        id result = responseObject[@"code"];
        NSString *code = [NSString stringWithFormat:@"%@",result];
        if([code isEqual:@"100"]){
            [MBProgressHUD showSuccess:@"绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            id result = responseObject[@"status"];
            NSString *message = [NSString stringWithFormat:@"%@",result];
            [MBProgressHUD showError:message];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//    verifyPhone
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    NSDictionary *dict = @{
//                           @"checkCode":self.codeTF.text
//                           };
//    [MBProgressHUD showMessage:@"处理中..." toView:self.view];
//    [manager POST:[ZZTAPI stringByAppendingString:@"login/verifyPhone"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        id response = responseObject[@"code"];
//        NSInteger code = (NSInteger)response;
//        if(code == 300){
//            [MBProgressHUD hideHUDForView:self.view];
//            [MBProgressHUD showError:@"该号码已注册"];
//        }else{
//            [MBProgressHUD hideHUDForView:self.view];
//            //跳转绑定好码的页面
//            [MBProgressHUD showSuccess:@"更改成功"];
//            [MBProgressHUD hideHUDForView:self.view];
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}

-(void)setViewTitle:(NSString *)viewTitle{
    _viewTitle = viewTitle;
}
@end
