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

static NSString *AuthorMeInputOneCell1 = @"AuthorMeInputOneCell1";


@interface ZZTCartReleaseViewController ()<UITableViewDataSource,UITableViewDelegate,ZZTMeInputOneCellDelegate,ZZTChapterChooseViewDelegate,chapterPriceViewDelegate>{
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
    
    [self.viewNavBar.centerButton setTitle:@"漫画信息" forState:UIControlStateNormal];
    
    [self addBackBtn];
    
    _sectionOne = [NSArray arrayWithObjects:[ZZTCell initCellModelWithTitle:@"作品名称" cellDetail:@"再次输入作品名称,最多8个汉字"],[ZZTCell initCellModelWithTitle:@"作品介绍" cellDetail:@"在此输入作品文字介绍..."], nil];
    
    [self setupTableView];
    
    //40加字体大小加
    _cellHeight[0] = 100;
    _cellHeight[1] = 100;
    
    [self loadChapterDataWithCartID:@"9"];
}

-(void)loadChapterDataWithCartID:(NSString *)cartoonId{
    
//    self.chooseNum = pageNum;
    
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
        self.chapterChooseView.total = [totalData integerValue];
        
        //非5个  取余
        self.remainder = self.chapterChooseView.total % 5;
        self.remainderIndex = self.chapterChooseView.total / 5;
        
        
//        //列表大于1 第一次
//        if(array.count > 0){
//            ZZTChapterlistModel *model = array[0];
//            //没有历史
//            if(self.isHave == NO){
//                if([self.cartoonDetail.type isEqualToString:@"1"]){
//                    [self.pageBtn setTitle:[NSString stringWithFormat:@"%@画",model.chapterPage] forState:UIControlStateNormal];
//                }else{
//                    [self.pageBtn setTitle:[NSString stringWithFormat:@"%@",model.chapterName] forState:UIControlStateNormal];
//                }
//                //将开始阅读的内容 储存起来
//                self.startReadData = model;
//            }
//        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];


}

- (void)setupTableView{
    
    CGFloat navbarH = Height_NavBar;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar , self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
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
    cell.cellTextView.text = @"";
    if(indexPath.row == 0){
        cell.cellTextView.maxTextNum = 8;
    }
    cell.titleLab.text = cellModel.cellTitle;
    cell.placeHolderStr = cellModel.cellDetail;
    return cell;
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
        ZZTCartCoverSetView *coverView = [[ZZTCartCoverSetView alloc] init];
        return coverView;
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
        ZZTChapterPriceView *chapterPriceView = [[ZZTChapterPriceView alloc] init];
        chapterPriceView.delegate = self;
        _chapterPriceView = chapterPriceView;
        return chapterPriceView;
    }else{
        return nil;
    }
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
}

#pragma mark - lazyLoad
- (ZZTChapterChooseView *)chapterChooseView{
    if(!_chapterChooseView){
        _chapterChooseView = [[ZZTChapterChooseView alloc] initWithFrame:self.view.bounds];
        _chapterChooseView.delegate = self;
        _chapterChooseView.total = 100;
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
    
    //
}
@end
