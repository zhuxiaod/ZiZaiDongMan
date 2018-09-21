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

@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midCons;
@property (nonatomic,strong) ZXDLoginRegisterView *loginView ;
@property (nonatomic,strong) NSString *platformId;

@end

@implementation ZZTLoginRegisterViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
// 获取cooick
//    https://blog.csdn.net/qthdsy/article/details/51991845
    
    //登录view
    ZXDLoginRegisterView *loginView = [ZXDLoginRegisterView loginView];
    _loginView = loginView;
    [self.midView addSubview:loginView];
    
//    //注册view
//    ZXDLoginRegisterView *registerView = [ZXDLoginRegisterView registerView];
//    [self.midView addSubview:registerView];
    //获取验证码
    loginView.buttonAction = ^(UIButton *sender) {
        [self verificationButtonClick:sender];
    };
    //登录
    loginView.LogBtnClick = ^(UIButton *sender) {
        [self loginButtonClick:sender];
    };
//    registerView.buttonAction = ^(UIButton *sender) {
//        [self loginButtonClick:sender];
//    };
}

//获取验证码
-(void)verificationButtonClick:(UIButton *)button
{
    //提醒电话号码 位数不够
    
    
    //验证码
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"text/xml; charset=ut-8" forHTTPHeaderField:@"Content-Type"];
  
//    if (button.tag == 0) {
//        //1.创建会话管理者
//        //获取验证码
//        //http://192.168.0.165:8888/login/sendMsg?phoneNumber=18827514330
//        //判断验证码是否够数位
//        //如果够 发送  不够 就提示
//
        NSDictionary *paramDict = @{
                                    @"phone":self.loginView.phoneNumber.text
                                    };
//        //获取cookie
//        NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject: cookiesData forKey:@"Set-Cookie"];
//        [defaults synchronize];
//
        [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"login/sendMsg"] parameters:paramDict success:^(id responseObject) {

        } failure:^(NSError *error) {
            
        }];
//        //取cookie
//        NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"]];
//        NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage]; for (NSHTTPCookie * cookie in cookies){
//            [cookieStorage setCookie: cookie];
//            NSLog(@"%@",cookie);
//        }
//    }else{
//        //登录
//        NSDictionary *paramDict = @{
//                                    @"phone":@"18827514330",
//                                    @"checkCode":@"268996"
//                                    };
//        [manager POST:@"http://192.168.0.165:8888/login/loginApp" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"%@---%@",[responseObject class],responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"请求失败 -- %@",error);
//        }];
//
//
//    }

    NSLog(@"%@",self.loginView.phoneNumber);
}
-(void)loginButtonClick:(UIButton *)button{
    NSDictionary *paramDict = @{
                                    @"phone":self.loginView.phoneNumber.text,
                                    @"checkCode":self.loginView.verification.text
                                    };

    [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"login/loginApp"] parameters:paramDict success:^(id responseObject) {
        
        [self loginAfterLoadUserDataWith:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)registerButtonClick:(UIButton *)button
{
    
}

// viewDidLayoutSubviews:才会根据布局调整控件的尺寸
-(void)viewDidLayoutSubviews
{
    //一定要调用super
    [super viewDidLayoutSubviews];
    
    ZXDLoginRegisterView *loginView = self.midView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.midView.bounds.size.width * 0.5, self.midView.bounds.size.height);
    
//    ZXDLoginRegisterView *registerView = self.midView.subviews[1];
//    reg
    
//    isterView.frame = CGRectMake(self.midView.bounds.size.width * 0.5, 0, self.midView.bounds.size.width * 0.5, self.midView.bounds.size.height);
}

- (IBAction)dissMiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickRegister:(UIButton *)sender {
//    sender.selected =! sender.selected;
//    //平移中间View
//    _midCons.constant = _midCons.constant == 0? -self.midView.bounds.size.width * 0.5:0;
//
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.view layoutIfNeeded];
//    }];
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
                
                [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"login/thirdPartyLogin"] parameters:dic success:^(id responseObject) {
                    [self loginAfterLoadUserDataWith:responseObject];
                } failure:^(NSError *error) {

                }];
            }
        }
    }];
}

-(void)loginAfterLoadUserDataWith:(id)responseObject{
    //成功
    NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
    NSArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
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
@end
