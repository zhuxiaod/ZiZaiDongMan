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
#import "ZZTWordListCell.h"

@interface ZZTHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *cartoons;

@property (nonatomic,strong) UITableView *contentView;

@property (nonatomic,strong) NSMutableArray *cartoonIdArray;

@end

static NSString *zztCartoonHistoryCell = @"zztCartoonHistoryCell";

//NSString *zztWordListCell = @"zztWordListCell";

@implementation ZZTHistoryViewController

#pragma mark - 懒加载

- (NSMutableArray *)cartoonIdArray{
    if (!_cartoonIdArray) {
        _cartoonIdArray = [NSMutableArray array];
    }
    return _cartoonIdArray;
}

- (NSArray *)cartoons{
    if (!_cartoons) {
        _cartoons = [NSArray array];
    }
    return _cartoons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //viewTitle
//    self.navigationItem.title = @"浏览历史";
    //右边
//    UIButton *leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    
//    [leftbutton setTitle:@"清空" forState:UIControlStateNormal];
    
//    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    
//    self.navigationItem.rightBarButtonItem = rightitem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

//    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
    [self loadData];
    
//    [self addBackBtn];
    
    [self.viewNavBar.centerButton setTitle:@"浏览历史" forState:UIControlStateNormal];
    
    [self.viewNavBar.rightButton setTitle:@"清空" forState:UIControlStateNormal];
    [self.viewNavBar.rightButton addTarget:self action:@selector(deletHistory) forControlEvents:UIControlEventTouchUpInside];
    
    [self setMeNavBarStyle];

}

-(void)deletHistory{
    //提示页面
    ZZTRemindView *remindView = [ZZTRemindView sharedInstance];
    remindView.viewTitle = @"是否清空";
    remindView.tureBlock = ^(UIButton *btn) {
        AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
        UserInfo *user = [Utilities GetNSUserDefaults];
        NSString *string = [self.cartoonIdArray componentsJoinedByString:@","];
        NSLog(@"string:%@",string);
        NSDictionary *dict = @{
                               @"userId":[NSString stringWithFormat:@"%ld",user.id],
                               @"id":string
                               };
        [manager POST:[ZZTAPI stringByAppendingString:@"record/delBrowsehistory"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self loadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    };
    [remindView show];
    
}

-(void)setupTableView{
    UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, [GlobalUI getNavibarHeight], self.view.width, self.view.height - [GlobalUI getNavibarHeight]) style:UITableViewStylePlain];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.delegate = self;
    contentView.dataSource = self;
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;

//    self.automaticallyAdjustsScrollViewInsets = YES;
    self.contentView = contentView;
    //注册cell
    [contentView registerNib:[UINib nibWithNibName:@"ZZTCartoonHistoryCell" bundle:nil] forCellReuseIdentifier:zztCartoonHistoryCell];
    
    [self.view addSubview:contentView];
}

-(void)loadData{
    UserInfo *user = [Utilities GetNSUserDefaults];
    //请求参数
    NSDictionary *paramDict = @{
                                @"userId":[NSString stringWithFormat:@"%ld",user.id]
                                };

    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/selBrowsehistory"] parameters:paramDict progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
              NSArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
              self.cartoons = array;
              [self getCartoonId];
              [self.contentView reloadData];
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
    }];
}

-(void)getCartoonId{
    NSMutableArray *cartoonIdArray = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        for (int i = 0; i < self.cartoons.count; i++) {
            ZZTCarttonDetailModel *model = self.cartoons[i];
            [cartoonIdArray addObject:model.id];
        }
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            self.cartoonIdArray = cartoonIdArray;
        });
    });
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCarttonDetailModel *model = self.cartoons[indexPath.row];
    //漫画
    if(model.cover){
        ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
        //yes 就是有Id
        detailVC.isId = NO;
        detailVC.cartoonDetail = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        //空间
        ZZTMyZoneViewController *zoneView = [[ZZTMyZoneViewController alloc] init];
        zoneView.userId = model.userId;
        [self.navigationController pushViewController:zoneView animated:NO];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCarttonDetailModel *model = self.cartoons[indexPath.row];
    return model.rowHeight;
}

@end
