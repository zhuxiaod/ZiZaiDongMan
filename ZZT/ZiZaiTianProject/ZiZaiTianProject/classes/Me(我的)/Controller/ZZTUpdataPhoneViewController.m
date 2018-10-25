//
//  ZZTUpdataPhoneViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/25.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTUpdataPhoneViewController.h"
#import "ZZTAssociatedPhoneViewController.h"

@interface ZZTUpdataPhoneViewController ()
@property (nonatomic,strong) GGVerifyCodeViewBtn *codeBtn;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) NSString *userNum;

@property (nonatomic,strong) UIButton *nextBtn;
@end

@implementation ZZTUpdataPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"变更手机号";
    UserInfo *user = [Utilities GetNSUserDefaults];
    //请先验证你的手机号
    UILabel *phoneLab = [[UILabel alloc] init];
    _userNum = user.phone;
    NSString *numberString = [_userNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    phoneLab.text = [NSString stringWithFormat:@"请先验证你的手机号：%@",numberString];
    [self.view addSubview:phoneLab];
    
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(30);
    }];
    
    //验证码View
    UIView *codeView = [[UIView alloc] init];
    codeView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:codeView];
    
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLab.mas_bottom).offset(8);
        make.right.equalTo(phoneLab);
        make.left.equalTo(phoneLab);
        make.height.mas_equalTo(30);
    }];
    codeView.layer.cornerRadius = 6.0f;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入验证码";
    textField.textColor = [UIColor blackColor];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.layer.cornerRadius = 4;
    self.textField = textField;
    [codeView addSubview:textField];
    
    NSLog(@"codeView.width%f",codeView.width);
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundColor:[UIColor yellowColor]];
    nextBtn.layer.cornerRadius = 10.0f;
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.mas_bottom).offset(20);
        make.right.equalTo(phoneLab);
        make.left.equalTo(phoneLab);
        make.height.mas_equalTo(30);
    }];
    [nextBtn addTarget:self action:@selector(doneTarget) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextBtn;
    [self.textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}

-(void)textChange{
    self.nextBtn.enabled = self.textField.text.length;
}

-(void)codeBtnVerification{
    NSDictionary *paramDict = @{
                                @"phone":_userNum
                                };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[ZZTAPI stringByAppendingString:@"login/sendMsg"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    [self.codeBtn timeFailBeginFrom:60];
}

-(void)doneTarget{
    [MBProgressHUD showMessage:@"正在验证" toView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{
                           @"checkCode":self.textField.text,
                               @"phone":_userNum
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"login/upUserPhone"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id response = responseObject[@"code"];
        NSInteger code = (NSInteger)response;
        if(code == 300){
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showMessage:@"该号码已注册"];
        }else{
            [MBProgressHUD hideHUDForView:self.view];
            //跳转绑定好码的页面
            ZZTAssociatedPhoneViewController *associatedPhoneVC = [[ZZTAssociatedPhoneViewController alloc] init];
            [self.navigationController pushViewController:associatedPhoneVC animated:YES];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showMessage:@"请求失败"];
    }];
    
    ZZTAssociatedPhoneViewController *associatedPhoneVC = [[ZZTAssociatedPhoneViewController alloc] init];
    associatedPhoneVC.viewTitle = @"更换手机号";
    [self.navigationController pushViewController:associatedPhoneVC animated:YES];
}

//验证手机号码
-(NSString *)numberSuitScanf:(NSString*)number{
    
    //首先验证是不是手机号码
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    BOOL isOk = [regextestmobile evaluateWithObject:number];
    
    if (isOk) {//如果是手机号码的话
        
        NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        
        return numberString;
    }
    return number;
}

@end
