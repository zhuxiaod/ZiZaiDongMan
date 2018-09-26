//
//  ZZTWordDetailViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/22.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTWordDetailViewController.h"
#import "ZZTWordsDetailHeadView.h"
#import "ZZTWordDescSectionHeadView.h"
#import "ZZTWordListCell.h"
#import "ZZTChapterlistModel.h"
#import "ZZTCartoonDetailViewController.h"
#import "ZZTJiXuYueDuModel.h"

@interface ZZTWordDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) ZZTWordsDetailHeadView *head;

@property (nonatomic,strong) ZZTWordDescSectionHeadView *descHeadView;

@property (nonatomic,strong) ZZTCarttonDetailModel *ctDetail;

@property (nonatomic,strong) UITableView *contentView;

@property (nonatomic,strong) NSMutableArray *wordList;

@property (nonatomic,strong) ZZTJiXuYueDuModel *model;

@property (nonatomic,assign) BOOL isHave;

@property (nonatomic,strong) UIButton *starRead;

@end

NSString *zztWordListCell = @"zztWordListCell";

@implementation ZZTWordDetailViewController

-(NSMutableArray *)wordList{
    if(!_wordList){
        _wordList = [NSMutableArray array];
    }
    return _wordList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHave = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    //设置顶部页面
    [self setupTopView];
    //设置底部View
    [self setupBottomView];
}

//设置底部View
-(void)setupBottomView{
    UIView *bottom = [[UIView alloc] init];
    bottom.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    bottom.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottom];
    //页码
    UIButton *pageBtn = [[UIButton alloc] init];
    pageBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3*2, 50);
    pageBtn.backgroundColor = [UIColor colorWithHexString:@"#DBDCDD"];
    [pageBtn setTitle:@"1 - 12页" forState:UIControlStateNormal];
    [pageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottom addSubview:pageBtn];
    //开始阅读 继续阅读
    UIButton *starRead = [[UIButton alloc] init];
    starRead.frame = CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 50);
    starRead.backgroundColor = [UIColor colorWithHexString:@"#7778B2"];
    [starRead addTarget:self action:@selector(starReadTarget) forControlEvents:UIControlEventTouchUpInside];
    [starRead setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _starRead = starRead;
    [starRead setTitle:@"开始阅读" forState:UIControlStateNormal];
    [bottom addSubview:starRead];
    
    //有的话 说明有记录
    if(self.isHave == YES){
        NSLog(@"数组里面有这个");
        [starRead setTitle:@"继续阅读" forState:UIControlStateNormal];
    }else{
        NSLog(@"数组里面没有这个");
        //如果没有  保存进去
        [starRead setTitle:@"开始阅读" forState:UIControlStateNormal];
    }
}

//开始阅读
-(void)starReadTarget{
    ZZTCartoonDetailViewController *cartoonDetailVC = [[ZZTCartoonDetailViewController alloc] init];
    cartoonDetailVC.hidesBottomBarWhenPushed = YES;
    cartoonDetailVC.type = _cartoonDetail.type;
    cartoonDetailVC.cartoonId = self.cartoonDetail.id;
    cartoonDetailVC.viewTitle = _cartoonDetail.bookName;
    cartoonDetailVC.bookNameId = _cartoonDetail.id;

    if(self.isHave == YES){
        cartoonDetailVC.testModel = _model;
        cartoonDetailVC.cartoonId = _model.bookChapter;
    }
    [self.navigationController pushViewController:cartoonDetailVC animated:YES];
}

//设置数据
-(void)setCartoonDetail:(ZZTCarttonDetailModel *)cartoonDetail{
    _cartoonDetail = cartoonDetail;
    if(cartoonDetail.id){
        //上部分View
        [self loadtopData:cartoonDetail.id];
       //目录
        [self loadListData:cartoonDetail.id];
       //评论
//        [self loadCommentData:cartoonDetail.id];
    }
}

//请求该漫画的资料
-(void)loadtopData:(NSString *)ID{
    //加载用户信息
    weakself(self);
    NSDictionary *paramDict = @{
                                @"id":ID
                                };
    [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"cartoon/particulars"] parameters:paramDict success:^(id responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        ZZTCarttonDetailModel *mode = [ZZTCarttonDetailModel mj_objectWithKeyValues:dic];
        weakSelf.ctDetail = mode;

        [self.contentView reloadData];
    } failure:^(NSError *error) {
        
    }];
    [self.contentView reloadData];
}

//目录
-(void)loadListData:(NSString *)ID{
    NSDictionary *paramDict = @{
                                @"cartoonId":ID
                                };
    [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterlist"] parameters:paramDict success:^(id responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSMutableArray *array = [ZZTChapterlistModel mj_objectArrayWithKeyValuesArray:dic];
        self.wordList = array;
        [self.contentView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)setupTopView{
    
    UITableView *contenView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    contenView.backgroundColor = [UIColor whiteColor];
    contenView.contentInset = UIEdgeInsetsMake(wordsDetailHeadViewHeight,0,0,0);
    contenView.delegate = self;
    contenView.dataSource = self;
    contenView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentView = contenView;
    
    [contenView setSeparatorColor:[UIColor blueColor]];
    
    ZZTWordsDetailHeadView *head = [ZZTWordsDetailHeadView wordsDetailHeadViewWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, wordsDetailHeadViewHeight) scorllView:contenView];
    
    //收藏业务
    head.buttonAction = ^(ZZTCarttonDetailModel *detailModel) {
        UserInfo *userInfo = [Utilities GetNSUserDefaults];
        NSDictionary *dic = @{
                              @"cartoonId":detailModel.id,
                              @"userId":[NSString stringWithFormat:@"%ld",userInfo.id]
                              };
        [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"great/collects"] parameters:dic success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    };
    
    self.head = head;
    //设置数据
    self.head.detailModel = self.cartoonDetail;
    
    //先让数据显示
    [contenView registerNib:[UINib nibWithNibName:@"ZZTWordListCell" bundle:nil] forCellReuseIdentifier:zztWordListCell];
    
    [self.view addSubview:contenView];
    [self.view addSubview:head];
}

#pragma mark - 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordList.count;
}

#pragma mark - 内容设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTWordListCell *cell = [tableView dequeueReusableCellWithIdentifier:zztWordListCell];
  
    ZZTChapterlistModel *model = self.wordList[indexPath.row];
    model.type = _cartoonDetail.type;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnBlock = ^(ZZTWordListCell *cell, ZZTChapterlistModel *model) {
//        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
//        [self.wordList replaceObjectAtIndex:indexPath.row withObject:model];
//        [self loadAttention:model];
    };
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZTChapterlistModel *model = self.wordList[indexPath.row];
    //跳页
    ZZTCartoonDetailViewController *cartoonDetailVC = [[ZZTCartoonDetailViewController alloc] init];
    cartoonDetailVC.hidesBottomBarWhenPushed = YES;
    cartoonDetailVC.type = _cartoonDetail.type;
    cartoonDetailVC.cartoonId = [NSString stringWithFormat:@"%ld",model.id];
    cartoonDetailVC.viewTitle = _cartoonDetail.bookName;
    cartoonDetailVC.bookNameId = _cartoonDetail.id;

    if(self.isHave == YES &&  cartoonDetailVC.cartoonId == _model.bookChapter){
        cartoonDetailVC.testModel = _model;
    }
    [self.navigationController pushViewController:cartoonDetailVC animated:YES];
}


-(void)loadAttention:(ZZTChapterlistModel *)model{
    NSDictionary *dic = @{
                          @"userId":@"1",
                          @"authorId":model.userId
                          };
    [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"] parameters:dic success:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

//高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //字符串
    self.descHeadView.desc = self.ctDetail.intro;
    return self.descHeadView.myHeight;
}

//设置头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //介绍
    self.descHeadView.desc = self.ctDetail.intro;
    return self.descHeadView;
}

#pragma mark - lazyLoad
- (ZZTWordDescSectionHeadView *)descHeadView {
    if (!_descHeadView) {
        
        _descHeadView = [[ZZTWordDescSectionHeadView alloc] initWithFrame:self.view.bounds];
        _descHeadView.backgroundColor = [UIColor clearColor];
        weakself(self);
        
        [_descHeadView setNeedReloadHeight:^{
            
            [weakSelf.contentView reloadData];
            
        }];
    }
    return _descHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

//详情
-(ZZTCarttonDetailModel *)ctDetail{
    if (!_ctDetail) {
        _ctDetail = [[ZZTCarttonDetailModel alloc] init];
    }
    return _ctDetail;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self JiXuYueDuTarget];
}

-(ZZTJiXuYueDuModel *)model{
    if(!_model){
        _model = [[ZZTJiXuYueDuModel alloc] init];
    }
    return _model;
}

-(void)JiXuYueDuTarget{
    NSArray *models = [Utilities GetArrayWithPathComponent:@"readHistoryArray"];
    NSMutableArray *arrayDict = [ZZTJiXuYueDuModel mj_objectArrayWithKeyValuesArray:models];
    
    for (int i = 0; i < arrayDict.count; i++) {
        //看这个数组里面的模型是否有这本书
        ZZTJiXuYueDuModel *model = arrayDict[i];
        if([model.bookId isEqualToString:self.cartoonDetail.id]){
            self.isHave = YES;
            self.model = model;
            break;
        }
    }
    //有的话 说明有记录
    if(self.isHave == YES){
//        NSLog(@"数组里面有这个");
        [_starRead setTitle:@"继续阅读" forState:UIControlStateNormal];
    }else{
//        NSLog(@"数组里面没有这个");
        //如果没有  保存进去
        [_starRead setTitle:@"开始阅读" forState:UIControlStateNormal];
    }
}
@end
