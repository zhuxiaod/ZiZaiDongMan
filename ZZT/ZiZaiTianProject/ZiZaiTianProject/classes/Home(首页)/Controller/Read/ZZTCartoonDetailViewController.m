//
//  ZZTCartoonDetailViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCartoonDetailViewController.h"
#import "ZZTCartoonContentCell.h"
#import "ZZTCartoonModel.h"
#import "ZZTAuthorHeadView.h"
#import "ZZTContinueToDrawHeadView.h"
#import "ZZTCommentHeadView.h"
#import "ZZTCommentCell.h"
#import "ZZTCircleModel.h"
#import "ZZTStoryDetailCell.h"
#import "ZZTStoryModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZZTJiXuYueDuModel.h"
#import "ZZTCreationCartoonTypeViewController.h"
#import "ZZTChapterlistModel.h"
#import "ZZTCarttonDetailModel.h"

@interface ZZTCartoonDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *cartoonDetailArray;

@property (nonatomic,strong) NSArray *commentArray;

@property (nonatomic,strong) NSArray *userLikeArray;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) BOOL isNavHide;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,assign) BOOL isOnce;

@property (nonatomic,assign) BOOL isJXYD;

@property (nonatomic,strong) ZZTJiXuYueDuModel *model;

@property (nonatomic,strong) UserInfo *author;
//剧本
@property (nonatomic,strong) ZZTStoryModel *stroyModel;

@end

NSString *CartoonContentCellIdentifier = @"CartoonContentCellIdentifier";

NSString *Comment = @"Comment";

NSString *story = @"story";

NSString *storyDe = @"storyDe";

@implementation ZZTCartoonDetailViewController

-(ZZTStoryModel *)stroyModel{
    if(!_stroyModel){
        _stroyModel = [[ZZTStoryModel alloc] init];
    }
    return _stroyModel;
}

-(UserInfo *)author{
    if(!_author){
        _author = [[UserInfo alloc] init];
    }
    return _author;
}

-(NSArray *)userLikeArray{
    if (!_userLikeArray) {
        _userLikeArray = [NSArray array];
    }
    return _userLikeArray;
}

-(NSArray *)cartoonDetailArray{
    if (!_cartoonDetailArray) {
        _cartoonDetailArray = [NSArray array];
    }
    return _cartoonDetailArray;
}

-(NSArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSArray array];
    }
    return _commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //先把漫画显示出来
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 400;
    
    [tableView registerClass:[ZZTCartoonContentCell class] forCellReuseIdentifier:CartoonContentCellIdentifier];
    tableView.showsVerticalScrollIndicator = YES;
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"ZZTCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:Comment];
     [tableView registerNib:[UINib nibWithNibName:@"ZZTStoryDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:story];

    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //显示
    self.isNavHide = NO;
    [self hideOrShowHeadView:self.isNavHide];
    
    //title
    [self setupTitleView];
    
    self.isOnce = NO;
    if(self.model){
        self.isOnce = YES;
    }
    
    [self loadData];
}

-(void)loadData{
    [self loadCartoonDetail];
}

//中间内容
- (void)setupTitleView{
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.8, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:textView.frame];
    
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.cartoonModel.bookName;
    label.textColor = [UIColor whiteColor];
    [textView addSubview:label];
    
    self.titleLabel = label;
    
    self.navigationItem.titleView = textView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.cartoonDetailArray.count;
    }else{
        return self.commentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        //漫画   是这里的数据
        if([self.cartoonModel.type isEqualToString:@"1"]){
            ZZTCartoonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CartoonContentCellIdentifier];
            ZZTCartoonModel *model = self.cartoonDetailArray[indexPath.row];
            cell.model = model;
            return cell;
        }else{
            ZZTStoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:story];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ZZTStoryModel *model = self.cartoonDetailArray[indexPath.row];
            cell.str = model.content;
            return cell;
        }
    }else if (indexPath.section == 1){
        ZZTCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:Comment];
        if (self.commentArray.count > 0) {
            ZZTCircleModel *model = self.commentArray[indexPath.row];
            cell.model = model;
        }
        return cell;
    }else{
        ZZTCartoonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CartoonContentCellIdentifier];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if([self.cartoonModel.type isEqualToString:@"1"]){
            return self.view.height;
        }else{
            return [self.tableView fd_heightForCellWithIdentifier:story configuration:^(id cell) {
                ZZTStoryDetailCell *storyCell = (ZZTStoryDetailCell *)cell;
                ZZTStoryModel *model = self.cartoonDetailArray[indexPath.row];
                storyCell.str = model.content;
            }];
        }
    }else if(indexPath.section == 1){
        return [self.tableView fd_heightForCellWithIdentifier:Comment cacheByIndexPath:indexPath configuration:^(id cell) {
            ZZTCommentCell *CommentCell = (ZZTCommentCell *)cell;
            CommentCell.model = self.commentArray[indexPath.row];
            
        }];
    }else{
        return 0;
    }
}

//漫画接口
-(void)loadCartoonDetail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    if([self.cartoonModel.type isEqualToString:@"1"]){
        NSDictionary *paramDict = @{
                                    @"id":[NSString stringWithFormat:@"%ld",_dataModel.id]
                                    };
        [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/cartoonImg"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *data = responseObject[@"result"];
            NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:data];
            NSArray *array = [ZZTCartoonModel mj_objectArrayWithKeyValuesArray:dic];
            self.cartoonDetailArray = array;
            [self.tableView reloadData];
            [self reloadCellWithIndex];
            //
            [self loadCommentData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else{
        //章节
        NSDictionary *paramDict = @{
//                                    @"chapterinfoId":[NSString stringWithFormat:@"%ld",_dataModel.id]
                                    @"chapterinfoId":@"1"
                                    };
        [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *data = responseObject[@"result"];
            NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:data];
            NSArray *array = [ZZTStoryModel mj_objectArrayWithKeyValuesArray:dic];
            self.cartoonDetailArray = array;
            if(array.count > 0) {
                ZZTStoryModel *model = array[0];
                self.stroyModel = model;
                //下载txt
                [self downLoadTxt:model.content];
            }
            [self.tableView reloadData];
            //            [self.tableView layoutIfNeeded];
//            [self reloadCellWithIndex];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
        }];
    }
}

-(void)downLoadTxt:(NSString *)txtUrl{
    //构造资源链接
//    NSString *urlString = @"http://img1.sc115.com/uploads/sc/jpg/HD/1/204.jpg";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //创建AFN的manager对象
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    //构造URL对象
    NSURL *url = [NSURL URLWithString:txtUrl];
    //构造request对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //使用系统类创建downLoad Task对象
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
        //下载进度
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //返回下载到哪里(返回值是一个路径)
        //拼接存放路径
//
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //拼接文件全路径
        NSString *fullpath = [caches stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *filePathUrl = [NSURL URLWithString:fullpath];
        NSLog(@"filePathUrl:%@",[NSString stringWithFormat:@"%@",filePathUrl])
        return filePathUrl;
//        NSURL *pathURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
//
//        [pathURL URLByAppendingPathComponent:[response suggestedFilename]];
////
////        NSURL *filePathUrl = [NSURL fileURLWithPath:pathURL];
////
//        NSLog(@"pathURL%@",pathURL);
//        return pathURL;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载完成走这个block
        if (!error) {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ssdf.txt" ofType:nil];
            NSData *data = [NSData dataWithContentsOfFile:filePath.path options:NSUTF8StringEncoding error:&error];
            NSString *str  = [NSString stringWithUTF8String:[data bytes]];
//            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", str);
            NSLog(@"error:%@",error);
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"ssdf" ofType:@"txt"];
//            NSError *error;
//            NSString *content = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@",filePath] encoding:NSUTF8StringEncoding error:&error];
//            NSLog(@"error:%@",error);
//            NSArray *array = [self jsonStringToKeyValues:content];
//            for (NSDictionary *dict in array) {
//                NSLog(@"name=%@ sex=%@ phone=%@",[dict objectForKey:@"name"],[dict objectForKey:@"sex"],[dict objectForKey:@"phone"]);
//            }
        }else{
            NSLog(@"%@",error);

        }
    }];
    //开始请求
    [task resume];
}
//json字符串转化成OC键值对
- (id)jsonStringToKeyValues:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = nil;
    if (JSONData) {
        responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    }
    return responseJSON;
}

-(void)loadCommentData{
    //评论
    NSDictionary *commentDict = @{
                                  @"itemId":[NSString stringWithFormat:@"%ld",_dataModel.id]
                                  };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/cartoonComment"] parameters:commentDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *commenDdic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSArray *array1 = [ZZTCircleModel mj_objectArrayWithKeyValuesArray:commenDdic];
        
        self.commentArray = array1;
        [self.tableView reloadData];
        
        [self loadLikeData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)loadLikeData{
    //点赞人
    NSDictionary *likeDict = @{
                               @"cartoonId":_cartoonModel.id,//书
                               @"chapterId":[NSString stringWithFormat:@"%ld",_dataModel.id]
                               };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/listChapterinfo"] parameters:likeDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *likeDic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSArray *array2 = [ZZTChapterlistModel mj_objectArrayWithKeyValuesArray:likeDic];
        NSLog(@"likeDic:%@",likeDic);
        self.userLikeArray = array2;
        [self.tableView reloadData];
        
        [self loadAuthorHead];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)loadAuthorHead{
//        dispatch_semaphore_t  sema = dispatch_semaphore_create(0);
        //头像
    NSDictionary *headDict = @{
                               @"id":[NSString stringWithFormat:@"%ld",_dataModel.id]
                               };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getCartoonCenter"] parameters:headDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        NSArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
        if(array.count != 0){
            UserInfo *author = array[1];
            self.author = author;
        }
        //            NSLog(@"likeDic:%@",dic);
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//需要传1 或者2
-(void)setDataModel:(ZZTChapterlistModel *)dataModel{
    _dataModel = dataModel; // 你的问题在哪里  是没有数据还是数据错乱
//    weakself(self);
    
}

-(void)setCartoonModel:(ZZTCarttonDetailModel *)cartoonModel{
    _cartoonModel = cartoonModel;
}

//请求数据后显示那一行
-(void)reloadCellWithIndex{
    if(self.isJXYD){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSIndexPath *dayOne = [NSIndexPath indexPathForRow:[self.model.bookIndex integerValue] inSection:0];
            if([self.model.bookIndex integerValue] > 0){
                [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        });
    }
}

#pragma mark UITableViewDataSource 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 100;
    }{
        if(self.commentArray.count == 0){
            return 0;
        }
        return 40;
    }
}

//添加头 ZZTCartoonDetailFoot
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        //作者 上数据
        ZZTAuthorHeadView *authorHead = [ZZTAuthorHeadView AuthorHeadView];
        authorHead.userModel = self.author;
        return authorHead;
    }else{
        ZZTCommentHeadView *commentHeadView = [[ZZTCommentHeadView alloc] init];
        commentHeadView.backgroundColor = [UIColor whiteColor];
       
        return commentHeadView;
    }
}

//续画
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        ZZTContinueToDrawHeadView *view = [ZZTContinueToDrawHeadView ContinueToDrawHeadView];
//        view.buttonAction = ^(UIButton *sender) {
//          //跳转续画
//            ZZTCreationCartoonTypeViewController *xuHuaVC = [[ZZTCreationCartoonTypeViewController alloc] init];
//            xuHuaVC.type = self.cartoonModel.type;
//            self.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:xuHuaVC animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
//        };
//        view.array = self.userLikeArray;
//        return view;
//    }else{
        return nil;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 150;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //开始进来是显示的
    if(self.isNavHide == NO){
        self.isNavHide = YES;
        [self hideOrShowHeadView:self.isNavHide];
    }else{
        self.isNavHide = NO;
        [self hideOrShowHeadView:self.isNavHide];
    }
}

-(void)hideOrShowHeadView:(BOOL)needHide{
    
    if(self.navigationController.navigationBar.hidden == needHide) return;
    
    [self.navigationController setNavigationBarHidden:needHide animated:YES];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self.navigationController setNavigationBarHidden:velocity.y > 0 animated:YES];
}

//-(void)setBookNameId:(NSString *)bookNameId{
//    _bookNameId = bookNameId;
//}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //字典转模型
    NSArray *models = [Utilities GetArrayWithPathComponent:@"readHistoryArray"];
    NSMutableArray *arrayDict = [ZZTJiXuYueDuModel mj_objectArrayWithKeyValuesArray:models];
    
    NSLog(@"arrayDict:%@",arrayDict);
    
    //得到了模型数组 arrayDict
    //先看有没有这篇文章
    BOOL isHave = NO;
    int arrayIndex = 0;
    for (int i = 0; i < arrayDict.count; i++) {
        ZZTJiXuYueDuModel *model = arrayDict[i];
        if([model.bookId isEqualToString:_cartoonModel.id]){
            //证明有这一本书
            isHave = YES;
            arrayIndex = i;
            break;
        }
    }
    
    UITableViewCell *cell = [self.tableView visibleCells].firstObject;
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    //持续更新
    //如果有 就修改
    if(isHave == YES){
        ZZTJiXuYueDuModel *model = arrayDict[arrayIndex];
        //修改章节 和 页面
        model.bookIndex = [NSString stringWithFormat:@"%ld",(long)index.row];
        model.bookChapter = [NSString stringWithFormat:@"%ld",_dataModel.id];;
        model.bookId = _cartoonModel.id;
        [arrayDict replaceObjectAtIndex:arrayIndex withObject:model];
    }else{
        //没有看过 添加
        ZZTJiXuYueDuModel *model = [[ZZTJiXuYueDuModel alloc] init];
        model.bookName = _cartoonModel.bookName;
        model.bookChapter = [NSString stringWithFormat:@"%ld",_dataModel.id];
        model.bookId = _cartoonModel.id;
        model.bookIndex = [NSString stringWithFormat:@"%ld",index.row];
        [arrayDict addObject:model];
    }
    
    //存数据   注意清楚
    NSArray *arrayl = [ZZTJiXuYueDuModel mj_keyValuesArrayWithObjectArray:arrayDict];
    NSLog(@"arrayl:%@",arrayl);
    
    [arrayl writeToFile:[Utilities fileWithPathComponent:@"readHistoryArray"] atomically:YES];
}

//-(void)setModel:(ZZTJiXuYueDuModel *)model{
//    _model = model;
//    if(model){
//        self.isJXYD = YES;
//    }
//    else{
//        self.isJXYD = NO;
//    }
//}

-(void)setTestModel:(ZZTJiXuYueDuModel *)testModel{
    _testModel = testModel;
    if(testModel){
        self.isJXYD = YES;
        self.model = testModel;
    }else{
        self.isJXYD = NO;
    }
}

-(ZZTJiXuYueDuModel *)model{
    if(!_model){
        _model = [[ZZTJiXuYueDuModel alloc] init];
    }
    return _model;
}

@end
