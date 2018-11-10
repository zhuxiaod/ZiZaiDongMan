//
//  ZZTNewestCommentView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTNewestCommentView.h"
#import "ZZTStatusCell.h"
#import "ZZTCircleModel.h"
#import "FriendCircleViewModel.h"
#import "CircleCell.h"
#import "ZZTStatusFooterView.h"
#import "ZZTCommentOpenCell.h"

@interface ZZTNewestCommentView () <UITableViewDataSource,UITableViewDelegate,CircleCellDelegate,UITextViewDelegate,ZZTStatusFooterViewDelegate,ZZTStatusCellDelegate>
{
    NSInteger page_num;
}

@property (nonatomic,strong)ZZTStatusCell *statusCell;

@property (nonatomic,strong) NSMutableArray *commentArray;

@property (nonatomic,assign) NSInteger page_num;

@property (nonatomic,assign) NSInteger size_num;
//判断是否有评论
@property (nonatomic,assign) BOOL isHaveComment;
//记录展开开关
@property (nonatomic,strong) NSMutableArray *openArray;

@end

static NSString *const airView = @"airView";

@implementation ZZTNewestCommentView

//设置2种数据
-(NSMutableArray *)openArray{
    if(!_openArray){
        _openArray = [NSMutableArray array];
    }
    return _openArray;
}

-(NSMutableArray *)commentArray{
    if(!_commentArray){
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        
        _page_num = 1;
        
        _size_num = 10;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        self.estimatedRowHeight = 200;
        
        //注册cell应该可以修改的
        [self registerClass:[CircleCell class] forCellReuseIdentifier:statusCellReuseIdentifier];
        
        [self registerClass:[ZZTCommentOpenCell class] forCellReuseIdentifier:statusOpenReuseIdentifier];

        [self registerClass:[ZZTStatusCell class] forHeaderFooterViewReuseIdentifier:statusHeaderReuseIdentifier];
        //上拉更新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(update)];
        
        [header.arrowView setImage:[UIImage imageNamed:@"ic_pull_refresh_arrow_22x22_"]];
        //下拉
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];
        
        self.mj_header = header;
        
        self.mj_footer = footer;
        
        self.mj_footer.hidden = YES;
        
        self.estimatedRowHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        
        self.showsVerticalScrollIndicator = NO;
        //有评论的
        self.isHaveComment = YES;
    }
    return self;
}

-(void)setChapterId:(NSString *)chapterId{
    _chapterId = chapterId;
}

-(void)setDataNum:(NSInteger)dataNum{
    _dataNum = dataNum;
    [self update];
    _page_num++;
}
//请求数据
- (void)update{
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dict = @{
                           @"chapterId":_chapterId,
                           @"type":@"1",
                           @"userId":[NSString stringWithFormat:@"%ld",user.id],
                           @"pageNum":@"1",
                           @"pageSize":[NSString stringWithFormat:@"%ld",self.size_num],
                           @"host":[NSString stringWithFormat:@"%ld",_dataNum]
                           };
    [session POST:[ZZTAPI stringByAppendingString:@"circle/comment"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.mj_header endRefreshing];
        NSDictionary *commenDdic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSDictionary *list = commenDdic[@"list"];
        NSString *totaldic = [commenDdic objectForKey:@"total"];
        NSMutableArray *array1 = [ZZTCircleModel mj_objectArrayWithKeyValuesArray:list];
        if(array1.count == 0){
            //没有数据的时候
            ZZTCircleModel *airModel = [[ZZTCircleModel alloc] init];
            NSMutableArray *airArray = [NSMutableArray arrayWithObject:airModel];
            self.commentArray = airArray;
            self.isHaveComment = NO;
        }else{
            //外面的数据
            FriendCircleViewModel *circleViewModel = [[FriendCircleViewModel alloc] init];
            circleViewModel.circleModelArray = array1;
            [circleViewModel loadDatas];
            self.commentArray = [circleViewModel addOpenDataWith:self.openArray];
            self.isHaveComment = YES;
        }
        if(self.commentArray.count >= [totaldic integerValue]){
            self.mj_footer.hidden = YES;
        }else{
            self.mj_footer.hidden = NO;
        }
        //加工一下评论的数据
        [self reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)loadMoreDate{
    UserInfo *user = [Utilities GetNSUserDefaults];
//    [self.mj_footer resetNoMoreData];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dict = @{
                           @"chapterId":_chapterId,
                           @"type":@"1",
                           @"userId":[NSString stringWithFormat:@"%ld",user.id],
                           @"pageNum":[NSString stringWithFormat:@"%ld",_page_num],
                           @"pageSize":@"10",
                           @"host":[NSString stringWithFormat:@"%ld",_dataNum]
                           };
    [session POST:[ZZTAPI stringByAppendingString:@"circle/comment"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *commenDdic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSDictionary *list = commenDdic[@"list"];
        //总数
        NSString *totaldic = [commenDdic objectForKey:@"total"];
        NSInteger total = [totaldic integerValue];
        NSMutableArray *array1 = [ZZTCircleModel mj_objectArrayWithKeyValuesArray:list];
        if(array1.count == 0){
            //没有数据的时候
            [self.commentArray addObject:@"1"];
            self.isHaveComment = NO;
        }else{
            //外面的数据
            FriendCircleViewModel *circleViewModel = [[FriendCircleViewModel alloc] init];
            circleViewModel.circleModelArray = array1;
            [circleViewModel loadDatas];
            NSArray *array = [circleViewModel addOpenDataWith:self.openArray];

            [self.commentArray addObjectsFromArray:array];
            if (self.commentArray.count >= total) {
                //停止刷新
                [self.mj_footer endRefreshingWithNoMoreData];
//                [self.mj_footer setHidden:YES];
            }else{
                self.page_num++;
                [self.mj_footer endRefreshing];
            }
            self.size_num += 10;
            self.isHaveComment = YES;
        }
        //加工一下评论的数据
        [self fd_reloadDataWithoutInvalidateIndexPathHeightCache];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTCircleModel *model = self.commentArray[indexPath.section];
    if(model.replyComment.count > 4 && model.isOpenComment == NO){
        if(indexPath.row == 3){
            return 20;
        }
    }
    return UITableViewAutomaticDimension;
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commentArray.count;
}

//行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!self.isHaveComment){
        return 0;
    }else{
        ZZTCircleModel *model = self.commentArray[section];
        //如果大于3并且关闭  显示4条 还有一条是展开cell
        if(model.replyComment.count > 3 && model.isOpenComment == NO){
            return 4;
        }else{
            return model.replyComment.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTCircleModel *model = self.commentArray[indexPath.section];
    if(model.isOpenComment == NO && indexPath.row == 3){
        //展开cell
        ZZTCommentOpenCell *cell = [tableView dequeueReusableCellWithIdentifier:statusOpenReuseIdentifier];
        cell.cellNum = model.replyComment.count;
        cell.openBtnBlock = ^{
          //记录当前的操作
            ZZTCircleModel *openModel = [[ZZTCircleModel alloc] init];
            openModel.id = model.id;
            openModel.isOpenComment = YES;
            [self.openArray addObject:openModel];
            //更新当前的操作
            model.isOpenComment = YES;
            [self.commentArray replaceObjectAtIndex:indexPath.section withObject:model];
            [self reloadData];
        };
        return cell;
    }else{
        //回复cell
        ZZTCircleModel *model = self.commentArray[indexPath.section];
        CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:statusCellReuseIdentifier forIndexPath:indexPath];
        [cell setContentData:model index:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCircleModel *model = self.commentArray[indexPath.section];

    if ([_adelegate respondsToSelector:@selector(commentView:sendCellReply:indexRow:)]) {
        [_adelegate commentView:self sendCellReply:model indexRow:indexPath.row];
    }
}

//头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(!self.isHaveComment){
        return 150;
    }else{
        ZZTCircleModel *model = self.commentArray[section];
        return model.headerHeight;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.isHaveComment){
        //评论
        ZZTCircleModel *model = self.commentArray[section];
        self.statusCell = [[ZZTStatusCell alloc] initWithReuseIdentifier:statusHeaderReuseIdentifier];
        self.statusCell.delegate = self;
        self.statusCell.model = model;
        return _statusCell;
    }else{
        //显示占位图
        ZZTCommentAirView *airHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:airView];
        //如果没有头视图
        if(!airHeaderView){
            airHeaderView = [[ZZTCommentAirView alloc] initWithReuseIdentifier:airView];
        }
        [self.mj_footer setHidden:YES];
        return airHeaderView;
    }
}

//足
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(!self.isHaveComment){
        return 0;
    }else{
        return 30;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(self.isHaveComment){
        static NSString *statusFooterView = @"statusFooterView";
        ZZTStatusFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:statusFooterView];
        if(!footerView){
            footerView = [[ZZTStatusFooterView alloc] initWithReuseIdentifier:statusFooterView];
        }
        footerView.delegate = self;
        ZZTCircleModel *model = self.commentArray[section];
        footerView.model = model;
        return footerView;
    }else{
        UIView *footerView = [[UIView alloc] init];
        return footerView;
    }
}

-(void)didClickCommentButton:(ZZTCircleModel *)section{
    if ([_adelegate respondsToSelector:@selector(commentView:sendReply:)]) {
        [_adelegate commentView:self sendReply:section];
    }
}
-(void)longPressDeleteReply:(ZZTCircleModel *)model{
    if ([_adelegate respondsToSelector:@selector(longPressDeleteComment:)]) {
        [_adelegate longPressDeleteComment:model];
    }
}

- (ZZTStatusCell *)statusCell {
    if (!_statusCell) {
        
        _statusCell = [[ZZTStatusCell alloc] initWithFrame:self.bounds];
        _statusCell.backgroundColor = [UIColor clearColor];

    }
    return _statusCell;
}
-(void)beginHeaderUpdate{
    [self.mj_header beginRefreshing];
}
@end
