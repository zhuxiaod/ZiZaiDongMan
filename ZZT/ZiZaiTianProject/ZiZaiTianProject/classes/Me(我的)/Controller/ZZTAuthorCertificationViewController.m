//
//  ZZTAuthorCertificationViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/12.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTAuthorCertificationViewController.h"

static NSString *AuthorCertificationCellOne = @"AuthorCertificationCellOne";

@interface ZZTAuthorCertificationViewController ()<UITableViewDataSource,UITableViewDelegate>


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

    _sectionOne = [NSArray arrayWithObjects:@"真实姓名",@"身份证",@"邮箱地址", nil];
    _sectionTwo = [NSArray arrayWithObjects:@"个人介绍",@"首次提交作品介绍", nil];
    
    //创建tabView
    [self setupTableView];
    //提交申请
}

-(void)setupTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar , self.view.bounds.size.width, self.view.bounds.size.height - Height_NavBar) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
//    _tableView.contentInset = UIEdgeInsetsMake(Height_TabbleViewInset, 0, 0, 0);
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    //隐藏滚动条
    _tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[SBPersonalSettingCell class] forCellReuseIdentifier:AuthorCertificationCellOne];

    
    
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return _sectionOne.count;
    }else if (section == 1){
        return _sectionTwo.count;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section == 0){
        SBPersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:AuthorCertificationCellOne];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = [self.sectionOne objectAtIndex:indexPath.row];
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
        }
        cell.textFieldChange = ^(NSInteger tag) {
            [self textFieldChange:tag];
        };
//    }
    return cell;
//    }else if (indexPath.section == 1){
//
//    }
}

-(void)textFieldChange:(NSInteger)tag{


}
@end
