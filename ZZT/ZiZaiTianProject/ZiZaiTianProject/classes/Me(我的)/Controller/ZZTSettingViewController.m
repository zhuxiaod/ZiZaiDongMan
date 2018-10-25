//
//  ZZTSettingViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTSettingViewController.h"
#import "ZZTSettingSwichCell.h"
#import "ZZTNoTypeCell.h"
#import "ZZTExitCell.h"
#import "ZZTSettingModel.h"
#import "ProgressHUD.h"
#import <SDImageCache.h>
#import "ZZTUserAgreementViewController.h"
#import "ZZTPhoneNumViewController.h"
#import "ZZTAssociatedPhoneViewController.h"

@interface ZZTSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *tableView;
@property (strong,nonatomic) ZZTNoTypeCell *cell;
//@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic,strong)NSMutableArray *array1;

@property (nonatomic,strong)NSArray *array2;

@property (nonatomic,strong)NSArray *array3;

@property (nonatomic,strong) NSString *cacheSize;

@property (nonatomic,strong) UserInfo *userData;

@end

@implementation ZZTSettingViewController

-(NSMutableArray *)array1{
    if(!_array1){
        _array1 = [NSMutableArray array];
    }
    return _array1;
}

-(NSArray *)array2{
    if(!_array2){
        _array2 = [NSMutableArray array];
    }
    return _array2;
}

-(NSArray *)array3{
    if(!_array3){
        _array3 = [NSMutableArray array];
    }
    return _array3;
}

//cell的标识
NSString *ZZTsetting = @"ZZTsetting";
NSString *ZZTcellq = @"ZZTcellq";
NSString *ZZTcell11 = @"ZZTcell11";
NSString *NoTypeCell = @"NoTypeCell";
NSString *ExitCell = @"ExitCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    
    [self reloadCacheSize];

    //创建tableView
    [self setupTableView];
    //注册Cell
    [self registerCell];
    //title数据
    [self titleData];

    self.userData = [Utilities GetNSUserDefaults];
}
#pragma mark - tableView
-(void)setupTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 10;
    _tableView.contentInset = UIEdgeInsetsMake(-30, 0, 44, 0);
    //隐藏滚动条
    _tableView.showsVerticalScrollIndicator = NO;
}
#pragma mark - 注册cell
-(void)registerCell{
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ZZTSettingSwichCell" bundle:nil] forCellReuseIdentifier:ZZTsetting];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ZZTcellq];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ZZTcell11];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZZTNoTypeCell" bundle:nil] forCellReuseIdentifier:NoTypeCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZZTExitCell" bundle:nil] forCellReuseIdentifier:ExitCell];
}
#pragma mark - title数据
-(void)titleData{
    _array1 = [NSMutableArray arrayWithObjects:[ZZTSettingModel initSettingModelWith:@"低流量模式" detail:@"非WIFI环境下加载低质量图片,可为您节省70%流量"],[ZZTSettingModel initSettingModelWith:@"回复推送" detail:@"开启后及时收到别人的评论"],[ZZTSettingModel initSettingModelWith:@"更新提示" detail:@"关注作品更新后会及时提醒"],
//               [ZZTSettingModel initSettingModelWith:@"夜间模式" detail:@"开启后,夜间阅读不伤眼睛"],
               nil];
    _array2 = [NSArray arrayWithObjects:@"赏个好评",@"意见反馈",@"推荐给好友", nil];
    _array3 = [NSArray arrayWithObjects:@"缓存清理",@"帮助中心",@"关于我们",@"用户协议", nil];
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return self.array1.count;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return self.array2.count;
    }else{
        return self.array3.count + 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        ZZTSettingSwichCell *cell = [tableView
                                     dequeueReusableCellWithIdentifier:ZZTsetting];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ZZTSettingModel *model = self.array1[indexPath.row];
        cell.settingModel = model;
        return cell;
    }else if (indexPath.section == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZZTcellq];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = @"手机号码";
        UILabel *label = [[UILabel alloc] init];
        
        NSString *numberString = [self.userData.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        label.text = numberString;
        
        label.font = [UIFont boldSystemFontOfSize:14];
        [label sizeToFit];
        label.backgroundColor = [UIColor clearColor];
        label.frame =CGRectMake(Screen_Width - label.frame.size.width - 50, 15, label.frame.size.width, label.frame.size.height);
        [cell.contentView addSubview:label];
        label.textColor = [UIColor grayColor];
        return cell;
    }else if(indexPath.section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZZTcellq];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = self.array2[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZZTcellq];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            ZZTNoTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:NoTypeCell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellLab.text = self.array3[indexPath.row];
            cell.cache.text = self.cacheSize;
            _cell = cell;
            return cell;
        }else if (indexPath.row == 4) {
            ZZTExitCell *cell = [tableView dequeueReusableCellWithIdentifier:ExitCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.array3[indexPath.row];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            //如果有号码
            if(_userData.phone){
                //电话号码
                ZZTPhoneNumViewController *phoneNum = [[ZZTPhoneNumViewController alloc] init];
                [self.navigationController pushViewController:phoneNum animated:YES];
            }else{
                ZZTAssociatedPhoneViewController *phoneVC = [[ZZTAssociatedPhoneViewController alloc] init];
                phoneVC.viewTitle = @"绑定手机号";
                [self.navigationController pushViewController:phoneVC animated:YES];
            }
        }
    }
    else if(indexPath.section == 2){
        if(indexPath.row == 2){
            [self shareWithSharePanel];
        }
    }
    else if(indexPath.section == 3){
        if(indexPath.row == 0){
            weakself(self);
            
            dissmissCallBack dissmiss = [ProgressHUD showProgressWithStatus:@"清理中" inView:self.view];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                dissmiss();
                [weakSelf reloadCacheSize];
                [ProgressHUD showSuccessWithStatus:@"清理完毕" inView:weakSelf.view];
            }];
        }else if (indexPath.row == 3){
            ZZTUserAgreementViewController *userAgreementVC = [[ZZTUserAgreementViewController alloc] init];
            userAgreementVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userAgreementVC animated:YES];

        }else if(indexPath.row == 4){
            //退出账号
            UserInfo *user = [[UserInfo alloc] init];
            user.userId = @"";
            [Utilities SetNSUserDefaults:user];
            NSLog(@"user:%@",user);
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:@"" forKey:@"userId"];
//            [defaults synchronize];
            //退出页面
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)reloadCacheSize {
    
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        NSInteger mb = totalSize / 1024 / 1024;
        self.cacheSize = [NSString stringWithFormat:@"%zdMB",mb];
        [self.tableView reloadData];
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"自在动漫" descr:@"自在动漫~自在~" thumImage:[UIImage imageNamed:@"我的-头像框"]];
    shareObject.webpageUrl = @"http://www.zztian.cn/"; //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:plaform messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if(error){
            //failed
        }else{
            //success
        }
    }];
}
@end
