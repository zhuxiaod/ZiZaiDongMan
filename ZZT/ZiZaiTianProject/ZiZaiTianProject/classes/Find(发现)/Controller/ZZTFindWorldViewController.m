//
//  ZZTFindWorldViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTFindWorldViewController.h"
#import "ZZTFindCommentCell.h"
#import "ZZTCaiNiXiHuanView.h"
#import "ZZTMyZoneModel.h"
#import <SDCycleScrollView.h>

@interface ZZTFindWorldViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UITableView *contentView;

@property (nonatomic,assign) NSInteger pageNumber;

@property (nonatomic,strong) NSArray *imagesURLStrings;

@end

static NSString *CaiNiXiHuanView1 = @"CaiNiXiHuanView1";

@implementation ZZTFindWorldViewController

-(NSArray *)imagesURLStrings{
    if(!_imagesURLStrings){
        _imagesURLStrings = [NSArray array];
    }
    return _imagesURLStrings;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //猜你喜欢
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height - 49 - 20) style:UITableViewStyleGrouped];
    contentView.delegate = self;
    contentView.dataSource = self;
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView = contentView;
    [self.view addSubview:contentView];
    self.pageNumber = 0;
    [self loadData];
    
    //banner数据
    self.imagesURLStrings = [NSArray arrayWithObjects: @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=b648e41d5d5a3535e5518a545459d351&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161123%2Fbfa082e23cd94089a907a29b021946bf_th.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=d2ddcf88c11b57887d64db25c870bd4f&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20170919%2F210211af972f4e3c8c5a7fda0fda7493.jpeg", nil];
}

-(void)loadData{
    //请求世界数据
    NSDictionary *dic = @{
                          //                          @"pageNum":self.pageNumber,
                          @"pageNum":[NSString stringWithFormat:@"%ld",self.pageNumber],
                          @"pageSize":@"12",
                          //                          @"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
                          @"userId":@"1",
                          @"type":@"1"
                          };
    [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"circle/selDiscover"] parameters:dic success:^(id responseObject) {
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
    } failure:^(NSError *error) {
        
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
    [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"] parameters:dic success:^(id responseObject) {
//        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
//        NSMutableArray *array = [ZZTMyZoneModel mj_objectArrayWithKeyValuesArray:dic];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTMyZoneModel *model = _dataArray[indexPath.row];
    NSArray *imgs = [model.contentImg componentsSeparatedByString:@","];
    return  [ZZTFindCommentCell cellHeightWithStr:model.content imgs:imgs];
}
#pragma mark - headView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //网络轮播图
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) delegate:self placeholderImage:[UIImage imageNamed:@"peien"]];
    //数组
    cycleScrollView.imageURLStringsGroup = self.imagesURLStrings;
    cycleScrollView.autoScrollTimeInterval = 5.0f;// 自动滚动时间间隔
    return cycleScrollView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 150;
}

@end
