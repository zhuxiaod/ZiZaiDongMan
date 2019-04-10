//
//  ZZTAuthorCertificationViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/12.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTAuthorCertificationViewController.h"
#import "ZZTMeInputOneCell.h"
#import "CMInputView.h"
#import "ZZTCell.h"
#import "ZZTAuthorAttestationView.h"
#import "ZZTWorkInstructionsViewController.h"

static NSString *AuthorCertificationCellOne = @"AuthorCertificationCellOne";

static NSString *AuthorMeInputOneCell = @"AuthorMeInputOneCell";


@interface ZZTAuthorCertificationViewController ()<UITableViewDataSource,UITableViewDelegate,ZZTMeInputOneCellDelegate,ZZTAuthorAttestationViewDelegate>{
    CGFloat _cellHeight[2];
}


@property(nonatomic,strong) UITableView *tableView;

//节1
@property (nonatomic,strong) NSArray *sectionOne;
//节2
@property (nonatomic,strong) NSArray *sectionTwo;
//节3
@property (nonatomic,strong) NSArray *sectionThree;

//真实姓名
@property (nonatomic,strong) NSString *realName;
//身份证
@property (nonatomic,strong) NSString *IdCard;
//邮箱地址
@property (nonatomic,strong) NSString *emailAddress;
//个人介绍
@property (nonatomic,strong) NSString *userIntro;
//作品介绍
@property (nonatomic,strong) NSString *workIntro;
//是否提交邮箱
@property (nonatomic,strong) NSString *isCommitMail;
//同意协议
@property (nonatomic,strong) NSString *isAgreement;

@property (nonatomic,strong) ZZTMeInputOneCell *userIntroCell;

@property (nonatomic,strong) ZZTMeInputOneCell *wordIntroCell;

@property (nonatomic,assign) CGFloat TextH;

@property (nonatomic,strong) NSArray *cellHeightArray;

@end

@implementation ZZTAuthorCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewNavBar.centerButton setTitle:@"作者认证申请" forState:UIControlStateNormal];
    
    [self.viewNavBar.rightButton setTitle:@"投稿须知" forState:UIControlStateNormal];
    
    [self.viewNavBar.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.viewNavBar.leftButton);
    }];
    
    [self.viewNavBar.rightButton addTarget:self action:@selector(gotoContribute) forControlEvents:UIControlEventTouchUpInside];
    
    [self setMeNavBarStyle];
    
    //初始化
    self.realName = @"";
    self.IdCard = @"";
    self.emailAddress = @"";
    self.userIntro = @"";
    self.workIntro = @"";
    self.isCommitMail = @"0";
    self.isAgreement = @"0";
    
    _sectionOne = [NSArray arrayWithObjects:[ZZTCell initCellModelWithTitle:@"真实姓名" cellDetail:@"用于实名认证"],[ZZTCell initCellModelWithTitle:@"身份证" cellDetail:@"居民身份证号码"],[ZZTCell initCellModelWithTitle:@"邮箱地址" cellDetail:@"与提交作品一致的邮箱地址"], nil];
    _sectionTwo = [NSArray arrayWithObjects:[ZZTCell initCellModelWithTitle:@"个人介绍" cellDetail:@"个人创作风格,擅长方向,代表作等..."],[ZZTCell initCellModelWithTitle:@"首次提交作品介绍" cellDetail:@"简单介绍提交的作品名称、内容、风格等..."], nil];
    
    //创建tabView
    [self setupTableView];
    //提交申请
    [self setupCommitBtn];
    self.TextH = 100;
    //40加字体大小加
    _cellHeight[0] = 100;
    _cellHeight[1] = 100;
}

#pragma mark - 进入投稿须知
-(void)gotoContribute{
    ZZTWorkInstructionsViewController *workVC = [[ZZTWorkInstructionsViewController alloc] init];
    
    [self.navigationController pushViewController:workVC animated:YES];
}

-(void)setupCommitBtn{
    
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage createImageWithColor:ZZTSubColor] forState:UIControlStateNormal];
    [button setTitle:@"提交申请" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commitApply) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.right.left.equalTo(self.view).offset(0);
        make.height.mas_equalTo(64);
    }];
}

-(void)commitApply{
    //数据判断
    BOOL isName = NO;
    BOOL isID = NO;
    BOOL isMail = NO;
    BOOL isCommit = NO;
    BOOL isAgree = NO;

    //姓名判断
    if([ZXDCheckContent checkUserName:self.realName]){
        isName = YES;

    }else{
        NSLog(@"姓名格式不正确,请填写正确的姓名");
        [MBProgressHUD showError:@"姓名格式不正确,请填写正确的姓名"];
        return;
    }

    //'身份证号'正则表达式筛选

    NSString *identificationNumberPattern =@"\\d{17}[[0-9],0-9xX]";

    NSPredicate *identificationNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",identificationNumberPattern];

    if(![identificationNumberPredicate evaluateWithObject:self.IdCard]){

        NSLog(@"身份证格式不正确,请检查后重试!");
        [MBProgressHUD showError:@"身份证格式不正确,请填写正确的身份证"];
        return;
    }else{
        isID = YES;
    }

    //邮箱验证
    if([Utilities validateEmail:self.emailAddress]){
        isMail = YES;
    }else{

        NSLog(@"邮箱不正确");
        [MBProgressHUD showError:@"邮箱地址格式不正确,请填写正确的邮箱地址"];
        return;
    }

//    self.userIntro = @"";
//    self.workIntro = @"";
    //有无勾选协议
    if([self.isCommitMail isEqualToString:@"0"]){
        NSLog(@"请提交作品到邮箱");
        [MBProgressHUD showError:@"请提交作品到邮箱"];
        return;
    }else{
        isCommit = YES;
    }

    if([self.isAgreement isEqualToString:@"0"]){
        NSLog(@"请仔细阅读协议");
        [MBProgressHUD showError:@"请阅读并同意《自在动漫作者协议》"];
        return;
    }else{
        isAgree = YES;
    }

    if(isName && isID && isCommit && isAgree){
        //请求接口
        //已经提交申请
        NSDictionary *dict = @{
                               @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                               @"userName":self.realName,
                               @"email":self.emailAddress,
                               @"userCar":self.IdCard,
                               @"introduce":self.userIntro,
                               @"production":self.workIntro
                               };
        AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
        [manager POST:[ZZTAPI stringByAppendingString:@"record/authorIdentification"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *code = responseObject[@"code"];
            if([code integerValue] == 100){
                [MBProgressHUD showSuccess:@"提交成功~"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showSuccess:@"审请重复提交~"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

-(void)setupTableView{
    
    CGFloat navbarH = Height_NavBar;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar , self.view.bounds.size.width, self.view.bounds.size.height - navbarH - 64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.contentInset = UIEdgeInsetsMake(Height_TabbleViewInset, 0, 0, 0);
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    //隐藏滚动条
    _tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[SBPersonalSettingCell class] forCellReuseIdentifier:AuthorCertificationCellOne];
    
    [_tableView registerClass:[ZZTMeInputOneCell class] forCellReuseIdentifier:AuthorMeInputOneCell];
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return _sectionOne.count;
    }else if (section == 1){
        return _sectionTwo.count;
    }
    else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        SBPersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:AuthorCertificationCellOne];
        ZZTCell *cellModel = self.sectionOne[indexPath.row];
        cell.nameLabel.font = [UIFont systemFontOfSize:18];
        cell.showBottomLine = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = cellModel.cellTitle;
        cell.textFieldPlaceholder = cellModel.cellDetail;
        if(indexPath.row == 0){
            cell.textField.text = self.realName;
            cell.textField.tag = 1;
        }else if (indexPath.row == 1){
            cell.textField.text = self.IdCard;
            cell.textField.tag = 2;
        }else if (indexPath.row == 2){
            cell.textField.text = self.emailAddress;
            cell.textField.tag = 3;
        }else if (indexPath.row == 3){
            cell.textField.text = self.userIntro;
            cell.textField.tag = 4;
        }else{
            cell.textField.text = self.workIntro;
            cell.textField.tag = 5;
            cell.showBottomLine = NO;
        }
        cell.textFieldChange = ^(NSInteger tag) {
            [self textFieldChange:tag];
        };
        return cell;
    }else{
        ZZTMeInputOneCell *cell = [tableView dequeueReusableCellWithIdentifier:AuthorMeInputOneCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellTextView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.index = indexPath.row;
        cell.delegate = self;
        if(indexPath.row == 0){
            self.userIntroCell = cell;
        }else{
            self.wordIntroCell = cell;
            cell.hiddenBottomView = YES;
        }
        ZZTCell *cellModel = self.sectionTwo[indexPath.row];
        cell.cellTextView.font = [UIFont systemFontOfSize:16];
        cell.cellTextView.text = @"";
        cell.titleLab.text = cellModel.cellTitle;
        cell.placeHolderStr = cellModel.cellDetail;
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        SBPersonalSettingCell *cell = (SBPersonalSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }else{
        ZZTMeInputOneCell *cell = (ZZTMeInputOneCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.cellTextView becomeFirstResponder];
    }
}

-(void)textFieldChange:(NSInteger)tag{
    if(tag == 1){
        UITextField *textView = (UITextField *)[self.view viewWithTag:tag];
        self.realName = textView.text;
    }else if (tag == 2){
        UITextField *textView = (UITextField *)[self.view viewWithTag:tag];
        self.IdCard = textView.text;
    }else if (tag == 3){
        UITextField *textView = (UITextField *)[self.view viewWithTag:tag];
        self.emailAddress = textView.text;
    }
}

-(void)contentChange:(ZZTMeInputOneCell *)cell content:(NSString *)content index:(NSInteger)index{
    if(index == 0){
        self.userIntro = content;
    }else{
        self.workIntro = content;
    }
}

-(void)changeCellHeight:(ZZTMeInputOneCell *)cell textHeight:(CGFloat)textHeight index:(NSInteger)index{
    if(textHeight > 100){
        _cellHeight[index] = textHeight;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 60;
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            return _cellHeight[0];
        }else{
            return _cellHeight[1];
        }
    }else{
           return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 2){
        ZZTAuthorAttestationView *aaView = [[ZZTAuthorAttestationView alloc]init];
        aaView.delegate = self;
        return aaView;
    }
    return nil;
}

-(void)getBoxStateWithTag:(NSInteger)tag state:(NSString *)state
{
    if(tag == 0){
        self.isCommitMail = state;
    }else{
        self.isAgreement = state;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 2){
        return SCREEN_HEIGHT * 0.3;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 2){
        return nil;
    }else{
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
        return footerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 2){
        return 0;
    }
    return 4;
}


@end
