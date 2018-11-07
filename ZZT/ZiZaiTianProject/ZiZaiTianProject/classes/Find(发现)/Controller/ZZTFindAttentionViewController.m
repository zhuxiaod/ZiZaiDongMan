//
//  ZZTFindAttentionViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTFindAttentionViewController.h"
#import "ZZTCaiNiXiHuanView.h"
#import "ZZTFindCommentCell.h"
#import "ZZTMyZoneModel.h"

@interface ZZTFindAttentionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *contentView;
@property (nonatomic,assign) NSInteger pageNumber;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray *CNXHArray;

@end

static NSString *CaiNiXiHuanView = @"CaiNiXiHuanView";

@implementation ZZTFindAttentionViewController

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSArray *)CNXHArray{
    if(!_CNXHArray){
        _CNXHArray = [NSArray array];
    }
    return _CNXHArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //猜你喜欢
    self.view.backgroundColor = [UIColor redColor];
    
    UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height - 49) style:UITableViewStyleGrouped];
    contentView.delegate = self;
    contentView.dataSource = self;
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView = contentView;
    [self.view addSubview:contentView];
    self.pageNumber = 0;
    [self loadData];
    [self loadCaiNiXiHuanData];
    
    [self setupMJRefresh];

}

-(void)setupMJRefresh{
    self.contentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadCaiNiXiHuanData];
        [self loadData];
    }];
}

-(void)loadCaiNiXiHuanData{

//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"circle/guessYouLike"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        NSMutableArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
        self.CNXHArray = array;
        [self.contentView reloadData];
        [self.contentView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.contentView.mj_header endRefreshing];
    }];
}
-(void)loadData{
    //请求世界数据
    NSDictionary *dic = @{
                          //                          @"pageNum":self.pageNumber,
                          @"pageNum":[NSString stringWithFormat:@"%ld",self.pageNumber],
                          @"pageSize":@"12",
                          //                          @"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
                          @"userId":@"1",
                          @"type":@"2"
                          };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];

    [manager POST:[ZZTAPI stringByAppendingString:@"circle/selDiscover"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        id to = [dic objectForKey:@"total"];
        NSInteger total = [to integerValue];
        NSArray *list = [dic objectForKey:@"list"];
        NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:list];
        [self.dataArray addObjectsFromArray:array];
        [self.contentView reloadData];
        if(self.dataArray.count >= total){
            [self.contentView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.contentView.mj_footer endRefreshing];
        }
        //page+size
        self.pageNumber += 6;
        [self.contentView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.contentView.mj_footer endRefreshing];
    }];
}

#pragma mark - 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
#pragma mark - 内容设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTFindCommentCell *cell = [ZZTFindCommentCell dynamicCellWithTable:tableView];
    cell.btnBlock = ^(ZZTFindCommentCell *cell,ZZTMyZoneModel *model,BOOL yesOrNo) {
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        if(yesOrNo == YES){
            //点赞接口
        }else{
            //关注接口
            [self loadAttention:model];
        }
    };
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)loadAttention:(ZZTMyZoneModel *)model{
    NSDictionary *dic = @{
                          @"userId":@"1",
                          @"authorId":model.userId
                          };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];

    [manager POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"] parameters:dic progress:nil success:nil failure:nil];
}

#pragma mark 高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTMyZoneModel *model = _dataArray[indexPath.row];
    NSArray *imgs = [model.contentImg componentsSeparatedByString:@","];
    return  [ZZTFindCommentCell cellHeightWithStr:model.content imgs:imgs];
}


#pragma mark - headView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZZTCaiNiXiHuanView *view = [[ZZTCaiNiXiHuanView alloc] init];
    view.dataArray = self.CNXHArray;
    view.buttonAction = ^(UIButton *sender) {
        //换一批
        [self loadCaiNiXiHuanData];
    };
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 150;
}
@end
