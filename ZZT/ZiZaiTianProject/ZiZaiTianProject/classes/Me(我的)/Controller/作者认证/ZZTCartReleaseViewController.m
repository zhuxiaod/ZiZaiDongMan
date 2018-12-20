//
//  ZZTCartReleaseViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/14.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTCartReleaseViewController.h"
#import "ZZTCartCoverSetView.h"
#import "ZZTMeInputOneCell.h"
#import "ZZTCell.h"
#import "ZZTChapterChooseView.h"
#import "ZZTChapterPriceView.h"
#import "ZZTChapterlistModel.h"
#import "ZZTChapterlistModel.h"
#import "ZZTChapterChooseView.h"
#import "ZZTChapterChooseModel.h"
#import "ZZTChapterPriceModel.h"
#import "ZZTLittleBoxView.h"
#import "ZZTCarttonDetailModel.h"
#import "ZZTCartInfoModel.h"

static NSString *AuthorMeInputOneCell1 = @"AuthorMeInputOneCell1";


@interface ZZTCartReleaseViewController ()<UITableViewDataSource,UITableViewDelegate,ZZTMeInputOneCellDelegate,ZZTChapterChooseViewDelegate,chapterPriceViewDelegate,ZZTLittleBoxViewDelegate>{
    CGFloat _cellHeight[2];
}

@property(nonatomic,strong) UITableView *tableView;
//节2
@property (nonatomic,strong) NSArray *sectionOne;

@property (nonatomic,strong) ZZTChapterChooseView *chapterChooseView;
//记录选择
@property (nonatomic,strong) NSString *chooseNum;

@property (nonatomic,strong) NSArray *allChapterArray;

@property (nonatomic,strong) NSArray *selectChapterArray;

//选择价格视图
@property (nonatomic,strong) ZZTChapterPriceView *chapterPriceView;

@property (nonatomic,strong) NSMutableDictionary *priceDict;
//余几个数
@property (nonatomic,assign) NSInteger remainder;

//索引第几个取余
@property (nonatomic,assign) NSInteger remainderIndex;

//是否设定付费章节
@property (nonatomic,strong) NSString *isPayChapter;

@property (nonatomic,strong) NSString *payPrice;


@property (nonatomic,strong) ZZTChapterlistModel *nowModel;

@property (nonatomic,strong) ZZTCartCoverSetView *coverView;

@property (nonatomic,strong) ZZTCarttonDetailModel *cartModel;

//作品名称
@property (nonatomic,strong) NSString *wordName;

//作品介绍
@property (nonatomic,strong) NSString *wordIntro;

@end

@implementation ZZTCartReleaseViewController

-(NSMutableDictionary *)priceDict{
    if(!_priceDict){
        _priceDict = [NSMutableDictionary dictionary];
    }
    return _priceDict;
}
//选择的章节 5条
-(NSArray *)selectChapterArray{
    if(!_selectChapterArray){
        _selectChapterArray = [NSArray array];
    }
    return _selectChapterArray;
}

//所有章节
-(NSArray *)allChapterArray{
    if(!_allChapterArray){
        _allChapterArray = [NSArray array];
    }
    return _allChapterArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wordName = @"";
    
    self.wordIntro = @"";
    
    [self.viewNavBar.centerButton setTitle:@"漫画信息" forState:UIControlStateNormal];
    
    [self addBackBtn];
    
    _sectionOne = [NSArray arrayWithObjects:[ZZTCell initCellModelWithTitle:@"作品名称" cellDetail:@"再次输入作品名称,最多8个汉字"],[ZZTCell initCellModelWithTitle:@"作品介绍" cellDetail:@"在此输入作品文字介绍..."], nil];
    
    [self setupTableView];
    
    //40加字体大小加
    _cellHeight[0] = 100;
    _cellHeight[1] = 100;
    
    [self loadChapterDataWithCartID:@"9"];
    
    self.isPayChapter = @"0";
    self.payPrice = @"0";
    //设置发布按钮
    [self setupReleseBtn];
}

-(void)setupReleseBtn{
    //漫画下架
    UIButton *soldOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [soldOutBtn setTitle:@"漫画下架" forState:UIControlStateNormal];
    [soldOutBtn addTarget:self action:@selector(soldOutTarget) forControlEvents:UIControlEventTouchUpInside];
    [soldOutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [soldOutBtn setBackgroundColor:[UIColor colorWithRGB:@"222,223,224"]];
    [self.view addSubview:soldOutBtn];
    
    //发布
    UIButton *releseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [releseBtn setTitle:@"发布" forState:UIControlStateNormal];
    [releseBtn setBackgroundColor:ZZTSubColor];
    [releseBtn addTarget:self action:@selector(releaseTarget) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releseBtn];
    
    [soldOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(66);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.62);
    }];
    
    [releseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(66);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.38);
    }];
}

-(void)soldOutTarget{
    if([self.model.ifrelease isEqualToString:@"0"]){
        [MBProgressHUD showSuccess:@"此作品已经下架！"];
        return;
    }
    NSDictionary *dict = @{
                           @"cartoonChapters":@"",
                           @"bookName": @"",
                           @"cartoonId":self.model.id,
                           @"cover":@"",
                           @"lbCover":@"",
                           @"ifrelease":@"0",
                           @"ifpay":@"",
                           @"chapterMoney":@"",
                           @"intro":@""
                           };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/authorUpChapter"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showSuccess:@"下架成功~"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)releaseTarget{
    //发布
    NSArray *modelArray = [_priceDict allValues];
    
    NSArray *dictArray = [ZZTChapterlistModel mj_keyValuesArrayWithObjectArray:modelArray];
    
    //判断名称是否超过八位数
    if(self.wordName.length > 8){
        [MBProgressHUD showSuccess:@"作品名称超过8个字符"];
        return;
    }
    
//    //判断有没有购买项
//    for (NSInteger i = 0; i < dictArray.count; i++) {
//
//        ZZTChapterlistModel *model = dictArray[i];
//        if(model.ifrelease = )
//
//    }
//
//    if(dictArray.count > 0){
//        if([self.payPrice integerValue] <= 0){
//            [MBProgressHUD showSuccess:@"请设置价格"];
//            return;
//        }
//    }

    NSString *s = [dictArray mj_JSONString];
    
    NSString *coverImgPath = [Utilities getCacheImagePath];
    
    [UIImagePNGRepresentation(self.coverView.coverImgView.image) writeToFile:coverImgPath atomically:YES];

    NSString *bannerImgPath = [Utilities getCacheImagePath];
    
    [UIImagePNGRepresentation(self.coverView.bannerImgView.image) writeToFile:bannerImgPath atomically:YES];
    
    NSLog(@"coverImgPath:%@",coverImgPath);
    
    NSLog(@"bannerImgPath:%@",bannerImgPath);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 处理耗时操作的代码块...
        NSString *coverImg = [SYQiniuUpload QiniuPutSingleImage:coverImgPath complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

        }];

        NSString *bannerImg = [SYQiniuUpload QiniuPutSingleImage:bannerImgPath complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

        }];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            //发送请求 发布
            [self sendPostRequestWithCartoonChapters:s cover:coverImg lbCover:bannerImg ifrelease:@"1"];
        });
        
    });
}
//发布是1 下架是0
-(void)sendPostRequestWithCartoonChapters:(NSString *)cartoonChapters cover:(NSString *)cover lbCover:(NSString *)lbCover ifrelease:(NSString *)ifrelease{
    NSDictionary *dict = @{
                           @"cartoonChapters":cartoonChapters,
                               @"bookName": self.wordName,
                               @"cartoonId":self.model.id,
                               @"cover":cover,
                               @"lbCover":lbCover,
                               @"ifrelease":ifrelease,
                               @"ifpay":self.isPayChapter,
                               @"chapterMoney":self.payPrice,
                               @"intro":self.wordIntro
                           };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/authorUpChapter"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showSuccess:@"发布成功~"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
    
}

-(void)upLoadQiNiuLoad:(NSArray *)array{
    //多图上传
    NSString * imageParms = @"";
    if (array.count > 0) {
        imageParms = [SYQiniuUpload QiniuPutImageArray:array complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"info == %@ \n resp === %@",info,resp);
        }];
    }
    
    //上传
}

-(void)loadChapterDataWithCartID:(NSString *)cartoonId{
        
    NSDictionary *dic = @{
                          @"cartoonId":cartoonId,
                          @"type":@"1",//1.漫画 剧本
                          @"cartoonType":@"1", //1 独创 2 众创
                          @"pageNum":@"1",
                          @"pageSize":@"99",
                          @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id]
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    EncryptionTools *tool = [[EncryptionTools alloc]init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterlist"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic2 = [tool decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSLog(@"dic2:%@",dic2);
        NSMutableArray *array = [ZZTChapterlistModel mj_objectArrayWithKeyValuesArray:dic2[@"list"]];
        self.allChapterArray = array;
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            //将获得的数据中 可以购买的项 提出来
            for (NSInteger i = 0; i < self.allChapterArray.count; i++) {
                ZZTChapterlistModel *model = self.allChapterArray[i];
                if(model.ifrelease == 2){//2是要钱的 1是不要钱的
                    //加入购买dict
                    [self.priceDict setObject:model forKey:[NSString stringWithFormat:@"%ld",(long)model.id]];
                }
            }
        });
        
        self.selectChapterArray = [array subarrayWithRange:NSMakeRange(0, 5)];
        self.chapterPriceView.dataArray = self.selectChapterArray;
        
        //总共的数量
        NSNumber *totalData = dic2[@"total"];
        //非5个  取余
        self.remainder = [totalData integerValue] % 5;
        self.remainderIndex = [totalData integerValue] / 5;
        
        self.chapterChooseView.total = [totalData integerValue];
        
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)setupTableView{
    
    CGFloat navbarH = Height_NavBar;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar , self.view.bounds.size.width, self.view.bounds.size.height - 66) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    //隐藏滚动条
    _tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    
//    [_tableView registerClass:[SBPersonalSettingCell class] forCellReuseIdentifier:AuthorCertificationCellOne];
//
    [_tableView registerClass:[ZZTMeInputOneCell class] forCellReuseIdentifier:AuthorMeInputOneCell1];
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _sectionOne.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTMeInputOneCell *cell = [tableView dequeueReusableCellWithIdentifier:AuthorMeInputOneCell1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellTextView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.index = indexPath.row;
    cell.delegate = self;
  
    ZZTCell *cellModel = self.sectionOne[indexPath.row];
    cell.cellTextView.font = [UIFont systemFontOfSize:16];

    if(indexPath.row == 0){
        cell.cellTextView.text = self.wordName;
    }else{
        cell.cellTextView.text = self.wordIntro;
    }
    
    [cell.cellTextView textDidChange];
    cell.cellTextView.font = [UIFont systemFontOfSize:16];
    cell.titleLab.text = cellModel.cellTitle;
    cell.placeHolderStr = cellModel.cellDetail;
    return cell;
}

-(void)contentChange:(ZZTMeInputOneCell *)cell content:(NSString *)content index:(NSInteger)index{
    if(index == 0){
        self.wordName = content;
    }else{
        self.wordIntro = content;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            return _cellHeight[0];
        }else{
            return _cellHeight[1];
        }
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){

        return _coverView;
    }
    else{
        return self.chapterChooseView;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 200;
    }else{
        return self.chapterChooseView.myHeight;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
//        ZZTChapterPriceView *chapterPriceView = [[ZZTChapterPriceView alloc] init];
//        chapterPriceView.delegate = self;
//        chapterPriceView.littleBox.delegate = self;
//        _chapterPriceView = chapterPriceView;
        return _chapterPriceView;
    }else{
        return nil;
    }
}

-(ZZTChapterPriceView *)chapterPriceView{
    if(!_chapterPriceView){
        _chapterPriceView = [[ZZTChapterPriceView alloc] init];
        _chapterPriceView.delegate = self;
        _chapterPriceView.littleBox.delegate = self;
    }
    return _chapterPriceView;
}
//价格
-(void)setupPriceEnding:(NSString *)price{
    self.payPrice = price;
}

//默认价格
-(void)clickLittleBoxView:(ZZTLittleBoxView *)littleBoxView selectState:(NSString *)selectState{
    self.isPayChapter = selectState;
}

-(void)setChapterPriceViewModel:(ZZTChapterlistModel *)model{
    
    [_priceDict setObject:model forKey:[NSString stringWithFormat:@"%ld",model.id]];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return 300;
    }else{
        return 0;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

#pragma mark - lazyLoad
-(ZZTCartCoverSetView *)coverView{
    if(!_coverView){
        _coverView = [[ZZTCartCoverSetView alloc] init];
    }
    return _coverView;
}


- (ZZTChapterChooseView *)chapterChooseView{
    if(!_chapterChooseView){
        _chapterChooseView = [[ZZTChapterChooseView alloc] initWithFrame:self.view.bounds];
        _chapterChooseView.delegate = self;
//        _chapterChooseView.total = 100;
        _chapterChooseView.title = @"章节信息";
        weakself(self);
        _chapterChooseView.needReloadHeight = ^{
            [weakSelf.tableView reloadData];
        };
        _chapterChooseView.backgroundColor = [UIColor whiteColor];
    }
    return _chapterChooseView;
}

-(void)chapterChooseView:(ZZTChapterChooseView *)chapterChooseView didItemWithModel:(ZZTChapterChooseModel *)model{
    //获得初始数
    NSInteger beginNum = (model.APIPage - 1) * 5;
    NSLog(@"beginNum:%ld",(long)beginNum);
    
    //判断余数
    if(model.APIPage == self.remainderIndex + 1){
        self.selectChapterArray = [self.allChapterArray subarrayWithRange:NSMakeRange(beginNum, self.remainder)];
        self.chapterPriceView.dataArray = self.selectChapterArray;
    }else{
        self.selectChapterArray = [self.allChapterArray subarrayWithRange:NSMakeRange(beginNum, 5)];
        self.chapterPriceView.dataArray = self.selectChapterArray;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
}

-(void)setModel:(ZZTCarttonDetailModel *)model{
    _model = model;

    //获取漫画详情数据
    [self loadtopData:model.id];
}


//请求该漫画的资料
-(void)loadtopData:(NSString *)ID{
    UserInfo *user = [Utilities GetNSUserDefaults];
    
    NSDictionary *paramDict = @{
                                @"id":ID,
                                @"userId":[NSString stringWithFormat:@"%ld",user.id]
                                };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    EncryptionTools *tool = [[EncryptionTools alloc]init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/particulars"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic1 = [tool decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        ZZTCarttonDetailModel *mode = [ZZTCarttonDetailModel mj_objectWithKeyValues:dic1];
        self.cartModel = mode;
        //封面视图给数据
        self.coverView.imgModel = mode;
        
        //介绍给数据
        self.wordName = mode.bookName;
        
        self.wordIntro = mode.intro;

        //设置作品介绍
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
@end
