//
//  ZZTLoginRegisterViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTLoginRegisterViewController.h"
#import "ZXDLoginRegisterView.h"
#import "ZXDFastLoginView.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import <UShareUI/UMSocialUIUtility.h>
#import "ZZTUserModel.h"

@interface ZZTLoginRegisterViewController ()

//@property (weak, nonatomic) IBOutlet UIView *midView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midCons;
@property (nonatomic,strong) ZXDLoginRegisterView *loginView ;
@property (nonatomic,strong) NSString *platformId;

@property (nonatomic,strong) UIImageView *logoIcon;

@property (nonatomic,strong) UILabel *logoName;

@property (nonatomic,strong) UIView *mindView;

@end

@implementation ZZTLoginRegisterViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //登录view
    ZXDLoginRegisterView *loginView = [ZXDLoginRegisterView loginView];
    _loginView = loginView;
//    [self.midView addSubview:loginView];
    
    //获取验证码
    loginView.buttonAction = ^(UIButton *sender) {
        [self verificationButtonClick:sender];
    };
    //登录
    loginView.LogBtnClick = ^(UIButton *sender) {
        [self loginButtonClick:sender];
    };

    self.viewNavBar.backgroundColor = [UIColor colorWithRGB:@"53,51,55"];
    
    [self.viewNavBar.centerButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.viewNavBar.centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self addBackBtn];
    
    [self.viewNavBar.leftButton setImage:[UIImage imageNamed:@"loginBackBtn"] forState:UIControlStateNormal];
    
    //图标
    UIImageView *logoIcon = [[UIImageView alloc] init];
    logoIcon.image = [UIImage imageNamed:@"ICON-head_portrait"];
    [self.view addSubview:logoIcon];
    
    [logoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(120);
        make.centerX.equalTo(self.view);
        make.height.width.mas_equalTo(SCREEN_HEIGHT * 0.125);
    }];
    
    //名字
    UILabel *logoName = [[UILabel alloc] init];
    logoName.text = @"自在动漫";
    logoName.attributedText = [NSString addStrSpace:logoName.text];
    [self.view addSubview:logoName];
    
    [logoName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoIcon.mas_bottom).offset(10);
        make.centerX.equalTo(logoIcon);
        make.height.mas_equalTo(20);
    }];
    
    //下面是键盘
    UIView *mindView = [[UIView alloc] init];
    [self.view addSubview:mindView];
    [mindView addSubview:loginView];
    
    [mindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoName.mas_bottom).offset(60);
        make.centerX.equalTo(logoIcon);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(220);
    }];

    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mindView.mas_top);
        make.right.equalTo(mindView.mas_right);
        make.left.equalTo(mindView.mas_left);
        make.bottom.equalTo(mindView.mas_bottom);
    }];
    
    //其他登录方式
    UIView *bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:bottomView];

    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(150);
        make.right.left.equalTo(self.view);
    }];
    
    UILabel *loginLab = [[UILabel alloc] init];
    loginLab.text = @"其他登录方式";
    [bottomView addSubview:loginLab];
    
    [loginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(0);
        make.centerX.equalTo(bottomView);
        make.height.mas_equalTo(20);
    }];
    
    UIView *leftBottomView = [[UIView alloc] init];
    leftBottomView.backgroundColor = ZZTSubColor;
    [bottomView addSubview:leftBottomView];
    
    [leftBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loginLab);
        make.right.equalTo(loginLab.mas_left).offset(-8);
        make.left.equalTo(bottomView.mas_left).offset(50);
        make.height.mas_equalTo(1);
    }];
    
    UIView *rightBottomView = [[UIView alloc] init];
    rightBottomView.backgroundColor = ZZTSubColor;
    [bottomView addSubview:rightBottomView];
    
    [rightBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loginLab);
        make.left.equalTo(loginLab.mas_right).offset(8);
        make.right.equalTo(bottomView.mas_right).offset(-50);
        make.height.mas_equalTo(1);
    }];
    
    [self.view layoutIfNeeded];
    
    UIButton *QQLoginBtn = [[UIButton alloc] init];
    [QQLoginBtn addTarget:self action:@selector(QQLogin:) forControlEvents:UIControlEventTouchUpInside];
    [QQLoginBtn setImage:[UIImage imageNamed:@"QQ_icon"] forState:UIControlStateNormal];
    [bottomView addSubview:QQLoginBtn];
    
    [QQLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView).offset(-100);
        make.centerY.equalTo(bottomView);
        make.height.width.mas_equalTo(bottomView.height * 0.6);
    }];
    
    UIButton *WCLoginBtn = [[UIButton alloc] init];
    [WCLoginBtn addTarget:self action:@selector(WeChatLogin:) forControlEvents:UIControlEventTouchUpInside];
    [WCLoginBtn setImage:[UIImage imageNamed:@"WeChat_icon"] forState:UIControlStateNormal];
    [bottomView addSubview:WCLoginBtn];
    
    [WCLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView).offset(100);
        make.centerY.equalTo(bottomView);
        make.height.width.mas_equalTo(bottomView.height * 0.6);
    }];
    
}

//获取验证码
-(void)verificationButtonClick:(UIButton *)button
{
    //验证码
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=ut-8" forHTTPHeaderField:@"Content-Type"];

    NSDictionary *paramDict = @{
                                @"phone":self.loginView.phoneNumber.text
                                };

    [manager POST:[ZZTAPI stringByAppendingString:@"login/sendMsg"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    NSLog(@"%@",self.loginView.phoneNumber);
}

-(void)loginButtonClick:(UIButton *)button{
    
    NSDictionary *paramDict = @{
                                @"phone":self.loginView.phoneNumber.text,
                                @"checkCode":self.loginView.verification.text
                                };

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"login/loginApp"]  parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self loginAfterLoadUserDataWith:responseObject];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)viewDidLayoutSubviews
{
    //一定要调用super
    [super viewDidLayoutSubviews];
    
//    ZXDLoginRegisterView *loginView = self.midView.subviews[0];
//    loginView.frame = CGRectMake(0, 0, self.midView.bounds.size.width * 0.5, self.midView.bounds.size.height);
}

- (IBAction)dissMiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 三方登录
- (IBAction)QQLogin:(UIButton *)sender {
    
    self.platformId = @"1";
    UMSocialPlatformType type = UMSocialPlatformType_QQ;
    [self getUserInfo:type];
    
}

- (IBAction)WeChatLogin:(UIButton *)sender {
    
    self.platformId = @"2";
    UMSocialPlatformType type = UMSocialPlatformType_WechatSession;
    [self getUserInfo:type];
    
}

- (IBAction)sinaLogin:(UIButton *)sender {
    self.platformId = @"3";
    UMSocialPlatformType type = UMSocialPlatformType_Sina;
    [self getUserInfo:type];
}

-(void)shareWithSharePanel{
    __weak typeof(self) ws = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [ws shareTextToPlatform:platformType];
    }];
}

//分享
-(void)shareTextToPlatform:(UMSocialPlatformType)plaform{
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    messageObject.text = @"友盟+";
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享到标题" descr:@"分享的描述" thumImage:[UIImage imageNamed:@"3.png"]];
    shareObject.webpageUrl = @"https://www.baidu.com/"; //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    [[UMSocialManager defaultManager] shareToPlatform:plaform messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if(error){
            //failed
        }else{
            //success
        }
    }];
}

-(void)getUserInfo:(UMSocialPlatformType)platformType{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if(error){
            //failed
            NSLog(@"error:%@",error);
        }else{
            if([result isKindOfClass:[UMSocialUserInfoResponse class]]){
                UMSocialUserInfoResponse *userInfo = result;
                
                NSString *uid = userInfo.uid;
                
                NSString *token = userInfo.accessToken;
                
                NSString *userName = userInfo.name;
                
                NSString *userIconurl = userInfo.iconurl;
                
                NSLog(@"uid:%@ token:%@ userName:%@ 1121212121userIconurl:%@",uid,token,userName,userIconurl);
                
                //上传数据
                NSDictionary *dic = @{
                                      @"nickName":userInfo.name,
                                      @"loginMode":self.platformId,
                                      @"loginNumber":userInfo.openid,
                                      @"sex":userInfo.unionGender,
                                      @"headimg":userInfo.iconurl
                                      };
                
                AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
                [manager POST:[ZZTAPI stringByAppendingString:@"login/thirdPartyLogin"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self loginAfterLoadUserDataWith:responseObject];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                }];
            }
        }
    }];
}

-(void)loginAfterLoadUserDataWith:(id)responseObject{
    //成功
    NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
    NSArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
    //获得数据
    UserInfo *user = array[0];
    //存
    [Utilities SetNSUserDefaults:user];


    //关闭页面
    [self dismissViewControllerAnimated:YES completion:^{
        //创建通知
        NSNotification *notification = [NSNotification notificationWithName:@"loadMeView" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }];
}

+ (void)show {
    
    UIViewController *rootVc = [self topViewControllerWithRootViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
    
    ZZTLoginRegisterViewController *loginVc = [ZZTLoginRegisterViewController new];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    
    [rootVc presentViewController:loginVc animated:YES completion:^{
        
    }];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
@end
