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

static NSString *AuthorCertificationCellOne = @"AuthorCertificationCellOne";

static NSString *AuthorMeInputOneCell = @"AuthorMeInputOneCell";


@interface ZZTAuthorCertificationViewController ()<UITableViewDataSource,UITableViewDelegate,ZZTMeInputOneCellDelegate>{
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
//邮箱地址
@property (nonatomic,strong) NSString *workIntro;

@property (nonatomic,strong) ZZTMeInputOneCell *userIntroCell;

@property (nonatomic,strong) ZZTMeInputOneCell *wordIntroCell;

@property (nonatomic,assign) CGFloat TextH;

@property (nonatomic,strong) NSArray *cellHeightArray;

@end

@implementation ZZTAuthorCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewNavBar.centerButton setTitle:@"作者认证申请" forState:UIControlStateNormal];
    
    [self setMeNavBarStyle];
    
    //初始化
    self.realName = @"";
    self.IdCard = @"";
    self.emailAddress = @"";
    self.userIntro = @"";
    self.workIntro = @"";

    _sectionOne = [NSArray arrayWithObjects:[ZZTCell initCellModelWithTitle:@"真实姓名" cellDetail:@"用于实名认证"],[ZZTCell initCellModelWithTitle:@"身份证" cellDetail:@"居民身份证号码"],[ZZTCell initCellModelWithTitle:@"邮箱地址" cellDetail:@"与提交作品一致的邮箱地址"], nil];
    _sectionTwo = [NSArray arrayWithObjects:[ZZTCell initCellModelWithTitle:@"个人介绍" cellDetail:@"个人创作风格,擅长方向,代表作等..."],[ZZTCell initCellModelWithTitle:@"首次提交作品介绍" cellDetail:@"简单介绍提交的作品名称、内容、风格等..."], nil];
    
    //创建tabView
    [self setupTableView];
    //提交申请
    self.TextH = 100;
    //40加字体大小加
    _cellHeight[0] = 100;
    _cellHeight[1] = 100;
}

-(void)setupTableView{
    CGFloat navbarH = Height_NavBar;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar , self.view.bounds.size.width, self.view.bounds.size.height - navbarH) style:UITableViewStyleGrouped];
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
        ZZTAuthorAttestationView *aaView = [ZZTAuthorAttestationView AuthorAttestationView];
        return aaView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 2){
        return SCREEN_HEIGHT * 0.3;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 2){
        return 0;
    }
    return 4;
}

-(void)textFieldChange:(NSInteger)tag{


}
@end
