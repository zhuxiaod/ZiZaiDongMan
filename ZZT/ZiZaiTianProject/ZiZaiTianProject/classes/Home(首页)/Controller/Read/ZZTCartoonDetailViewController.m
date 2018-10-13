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
#include <sys/time.h>
#import "CircleCell.h"
#import "ZZTUserReplyModel.h"
#import "FriendCircleViewModel.h"

@interface ZZTCartoonDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CircleCellDelegate>

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

@property (nonatomic,assign) CGPoint readPoint;

@end

NSString *CartoonContentCellIdentifier = @"CartoonContentCellIdentifier";

NSString *Comment = @"Comment";

NSString *story = @"story";

NSString *storyDe = @"storyDe";

static NSString *const kCellId = @"CircleCell";

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
//    [tableView registerNib:[UINib nibWithNibName:@"ZZTCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:Comment];
//    [tableView registerNib:[UINib nibWithNibName:@"ZZTStoryDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:story];

    tableView.pagingEnabled = NO;
    
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
    
    //评论
    //注册cell
    [self.tableView registerClass:[CircleCell class] forCellReuseIdentifier:kCellId];
    [self.tableView registerClass:[ZZTStoryDetailCell class] forCellReuseIdentifier:story];

    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)loadData{
    [self loadCartoonDetail];
}

#pragma mark - navigationItem
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

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.commentArray.count > 0){
        return self.commentArray.count + 1;
    }else{
        return 1;
    }
//    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.cartoonDetailArray.count;
    }else{
        if(self.commentArray.count > 0){
            ZZTCircleModel *model = self.commentArray[section - 1];
            return model.replyComment.count;

        }else{
            return 0;
        }
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
            NSLog(@"model.content:%@",model.content)
            return cell;
        }
    }else{
        ZZTCircleModel *model = self.commentArray[indexPath.section - 1];
//        ZZTUserReplyModel *item = model.replyComment[indexPath.row];
        CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        [cell setContentData:model index:indexPath.row];
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    }else{
        return UITableViewAutomaticDimension;

    }
}

#pragma mark - detailContentApi
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
//            [self.tableView layoutIfNeeded];
            //
            [self loadCommentData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else{
        //章节
        NSDictionary *paramDict = @{
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
            [self loadCommentData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
        }];
    }
}

//下载txt
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
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //拼接文件全路径
        NSString *fullpath = [caches stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *filePathUrl = [NSURL URLWithString:fullpath];
        return filePathUrl;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载完成走这个block
        if (!error) {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *filenData = [NSString stringWithContentsOfFile:filePath.path encoding:enc error:&error];
            self.stroyModel.content = filenData;
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
            [self reloadCellWithIndex];
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
                                  @"itemId":[NSString stringWithFormat:@"%ld",_dataModel.id],
                                  @"type":self.cartoonModel.type,
                                  @"pageNum":@"0",
                                  @"pageSize":@"10"
                                  };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/cartoonComment"] parameters:commentDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *commenDdic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSMutableArray *array1 = [ZZTCircleModel mj_objectArrayWithKeyValuesArray:commenDdic];
        //外面的数据
        FriendCircleViewModel *circleViewModel = [[FriendCircleViewModel alloc] init];
        circleViewModel.circleModelArray = array1;
        self.commentArray = [circleViewModel loadDatas];

        //加工一下评论的数据
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
    
    if(![self.cartoonModel.type isEqualToString:@"1"]){
        UserInfo *user = [[UserInfo alloc] init];
        user.headimg = self.stroyModel.headimg;
        user.nickName = self.stroyModel.nickName;
        user.id = self.stroyModel.id;
        user.userId = self.stroyModel.userId;
        self.author = user;
        [self.tableView reloadData];
        [self reloadCellWithIndex];
        return;
    }
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
        [self reloadCellWithIndex];
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
            // 刷新完成
            [self.tableView layoutIfNeeded];

            [self.tableView setContentOffset:self.model.readPoint];
        });
        NSLog(@"model.conte");
    }
}

#pragma mark UITableViewDataSource 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 100;
    }else{
        if(self.commentArray.count > 0){
            ZZTCircleModel *item = self.commentArray[section - 1];
            return item.cellHeight;
        }
        return 0;
    }
}

//添加头 ZZTCartoonDetailFoot
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        //作者 上数据
        ZZTAuthorHeadView *authorHead = [ZZTAuthorHeadView AuthorHeadView];
        authorHead.userModel = self.author;
        return authorHead;
    }else if(section == 1){
        ZZTCommentHeadView *commentHeadView = [[ZZTCommentHeadView alloc] init];
        commentHeadView.backgroundColor = [UIColor whiteColor];
        return commentHeadView;
    }else{
        static NSString *viewIdentfier = @"headView";
        ZZTCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
        //如果没有头视图
        if(!headerView){
            headerView = [[ZZTCommentHeaderView alloc] initWithReuseIdentifier:viewIdentfier];
        }
        ZZTCircleModel *model = self.commentArray[section - 1];
        [headerView setContentData:model section:section];
        return headerView;
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
    NSMutableArray *arrayDict = [NSKeyedUnarchiver unarchiveObjectWithFile:JiXuYueDuAPI];
    if (arrayDict == nil) {
        arrayDict = [NSMutableArray array];
    }
    NSLog(@"arrayDict:%@",arrayDict);
    
    //先看有没有这篇文章
    BOOL isHave = NO;
    int arrayIndex = 0;
    //因为有很多本书 所以会有很多对象
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
        model.bookName = _cartoonModel.bookName;
        model.bookChapter = _dataModel.chapterPage;//第几画
        model.bookId = _cartoonModel.id;    //判断那本书
        model.bookContentId = [NSString stringWithFormat:@"%ld",_dataModel.id];//内容ID
        model.readPoint = self.readPoint;//到那个位置
//        model.chapterIndex = self.indexRow;
        model.chapterIndex = [NSString stringWithFormat:@"%ld",self.indexRow];
        [arrayDict replaceObjectAtIndex:arrayIndex withObject:model];
    }else{
        
        /*
         记录书ID。知道是哪一本书          ok
         记录章节ID 得到显示12-23画  直接获得    ok
         记录内容ID 方便能够获取数据
         记录 type。如果是剧本的话 不要找转cell 如果是cartoon的话 需要
         记录 cartoonType 众创还是独创 如果是 总床
         */
        
        //没有看过 添加
        ZZTJiXuYueDuModel *model = [[ZZTJiXuYueDuModel alloc] init];
        model.bookName = _cartoonModel.bookName;
        model.bookChapter = _dataModel.chapterPage;//第几画
        model.bookId = _cartoonModel.id;    //判断那本书
        model.bookContentId = [NSString stringWithFormat:@"%ld",_dataModel.id];//内容ID
        model.readPoint = self.readPoint;//到那个位置
        model.chapterIndex = [NSString stringWithFormat:@"%ld",(long)self.indexRow];
        [arrayDict addObject:model];
    }
    //存
    NSString *path = JiXuYueDuAPI;
    [NSKeyedArchiver archiveRootObject:arrayDict toFile:path];
    NSLog(@"readPoint111111:%@",NSStringFromCGPoint(_readPoint));
}

//点击继续阅读的时候 才会传这个
//
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint readPoint = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    _readPoint = readPoint;
//    NSLog(@"readPoint:%@",NSStringFromCGPoint(readPoint));
}

-(void)setIndexRow:(NSInteger)indexRow{
    _indexRow = indexRow;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"width:%f",[UIScreen mainScreen].bounds.size.width);
}

@end
