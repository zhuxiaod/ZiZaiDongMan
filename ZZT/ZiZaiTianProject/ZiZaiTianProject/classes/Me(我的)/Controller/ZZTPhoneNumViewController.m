//
//  ZZTPhoneNumViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/25.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTPhoneNumViewController.h"
#import "ZZTSettingModel.h"
#import "ZZTUpdataPhoneViewController.h"

@interface ZZTPhoneNumViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *array1;

@end

@implementation ZZTPhoneNumViewController

NSString *phoneCell = @"phoneCell";

-(NSMutableArray *)array1{
    if(!_array1){
        _array1 = [NSMutableArray array];
    }
    return _array1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"电话";

    //创建tableView
    [self setupTableView];
    
    [self titleData];
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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:phoneCell];

}

#pragma mark - title数据
-(void)titleData{
    UserInfo *user = [Utilities GetNSUserDefaults];
    NSString *numberString = [user.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    _array1 = [NSMutableArray arrayWithObjects:[ZZTSettingModel initSettingModelWith:[NSString stringWithFormat:@"你已绑定手机%@",numberString] detail:nil],[ZZTSettingModel initSettingModelWith:@"变更手机号" detail:nil],
               nil];
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array1.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZZTSettingModel *model = self.array1[indexPath.row];
    cell.textLabel.text = model.modelTitle;
    if(indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return;
    }
    ZZTUpdataPhoneViewController *updataPhoneVC = [[ZZTUpdataPhoneViewController alloc] init];
    [self.navigationController pushViewController:updataPhoneVC animated:YES];
}

@end
