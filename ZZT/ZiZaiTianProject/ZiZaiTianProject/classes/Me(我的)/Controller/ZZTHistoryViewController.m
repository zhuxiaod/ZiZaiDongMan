//
//  ZZTHistoryViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTHistoryViewController.h"
#import "ZZTCartoonHistoryCell.h"
#import "ZZTCarttonDetailModel.h"

@interface ZZTHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *cartoons;

@property (nonatomic,strong) UITableView *contentView;


@end

static NSString *zztCartoonHistoryCell = @"zztCartoonHistoryCell";

@implementation ZZTHistoryViewController

#pragma mark - 懒加载
- (NSArray *)cartoons{
    if (!_cartoons) {
        _cartoons = [NSArray array];
    }
    return _cartoons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //viewTitle
    self.navigationItem.title = @"浏览历史";
    //右边
    UIButton *leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    
    [leftbutton setTitle:@"清空" forState:UIControlStateNormal];
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    
    self.navigationItem.rightBarButtonItem = rightitem;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
    [self loadData];
}

-(void)setupTableView{
    UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.delegate = self;
    contentView.dataSource = self;
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;

//    self.automaticallyAdjustsScrollViewInsets = YES;
    self.contentView = contentView;
    //注册cell
    [contentView registerClass:[ZZTCartoonHistoryCell class] forCellReuseIdentifier:zztCartoonHistoryCell];
    [self.view addSubview:contentView];
}

-(void)loadData{
    //请求参数
    NSDictionary *paramDict = @{
                                @"userId":@"32",
                                };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/selBrowsehistory"] parameters:paramDict progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
              NSArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
              self.cartoons = array;
              [self.contentView reloadData];
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cartoons.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCartoonHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:zztCartoonHistoryCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZZTCarttonDetailModel *car = self.cartoons[indexPath.row];
    cell.model = car;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCarttonDetailModel *model = self.cartoons[indexPath.row];
    if(model.cover){
        return 150;
    }else{
        ZZTCarttonDetailModel *model = _cartoons[indexPath.row];
        NSArray *imgs = [model.contentImg componentsSeparatedByString:@","];
        return  [ZZTCartoonHistoryCell cellHeightWithStr:model.content imgs:imgs];
    }
}

@end
