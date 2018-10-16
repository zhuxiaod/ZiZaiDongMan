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

@interface ZZTCartoonDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CircleCellDelegate,ZZTCommentHeaderViewDelegate,UITextViewDelegate,NSURLSessionDataDelegate>

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

@property (nonatomic, assign) CGFloat kInputHeight;

@property (nonatomic, strong) UIView *kInputView;

@property (nonatomic, strong) UITextView *kTextView;

@property (nonatomic, assign) NSInteger selectedSection;

@property (nonatomic, strong) NSDictionary *toPeople;

@property (nonatomic, strong) IQKeyboardManager *keyboardManager;
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
    
//
//    //键盘改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    //先把漫画显示出来
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 400;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
//    self.tableView.estimatedRowHeight = 100;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//
    //键盘输入框
//    [self addInputView];
    
    self.kInputHeight = 50;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

//    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://p872ue3rt.bkt.clouddn.com/tn014.txt"] encoding:enc error:nil];
//    htmlString = [self getZZwithString:htmlString];
//    NSLog(@"htmlString:%@",htmlString);
}

- (NSString *)getZZwithString:(NSString *)string{
    
    NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    
    string = [regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    
    return string;
    
}

- (void)addInputView {
    self.kInputView = [UIView new];
    _kInputView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [IQKeyboardManager sharedManager];
    [[UIApplication sharedApplication].keyWindow addSubview:_kInputView];
    [_kInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.right.equalTo([UIApplication sharedApplication].keyWindow);
        make.bottom.equalTo(@(self.kInputHeight));
    }];

    self.kTextView = [UITextView new];
    _kTextView.backgroundColor = [UIColor whiteColor];
    _kTextView.layer.cornerRadius = 5;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _kTextView.typingAttributes = attributes;
    _kTextView.returnKeyType = UIReturnKeySend;
    _kTextView.delegate = self;
    [_kInputView addSubview:_kTextView];
    [_kTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.bottom.equalTo(@(-7));
        make.left.equalTo(@14);
        make.right.equalTo(@(-50));
    }];
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
        return self.commentArray.count + 2;
    }else{
        return 1;
    }
//    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.cartoonDetailArray.count;
    }else if (section == 1){
        return 0;
    }else{
        if(self.commentArray.count > 0){
            ZZTCircleModel *model = self.commentArray[section - 2];
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
        ZZTCircleModel *model = self.commentArray[indexPath.section - 2];
//        ZZTUserReplyModel *item = model.replyComment[indexPath.row];
        CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        [cell setContentData:model index:indexPath.row];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if([self.cartoonModel.type isEqualToString:@"1"]){
            return self.view.height;
        }else{
            ZZTStoryModel *model = self.cartoonDetailArray[indexPath.row];
            if(model.content.length > 300){
                return [self calculateStringHeight:model.content];
            }else{
                return 0;
            }
        }
    }else{
        return UITableViewAutomaticDimension;
    }
}
- (CGFloat)calculateStringHeight:(NSString *)text {
    return ceil([text contentSizeWithWidth:Screen_Width - 20 font:[UIFont systemFontOfSize:SectionHeaderBigFontSize] lineSpacing:0].height);
}
#pragma mark - detailContentApi
-(void)loadCartoonDetail{
    UserInfo *user = [Utilities GetNSUserDefaults];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];


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
                                    @"chapterinfoId":[NSString stringWithFormat:@"%ld",_dataModel.id],
                                    @"userId":[NSString stringWithFormat:@"%ld",user.id]
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
    NSError *error;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:txtUrl] encoding:enc error:&error];
    if(!error){
        htmlString = [self getZZwithString:htmlString];
        self.stroyModel.content = htmlString;
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        [self reloadCellWithIndex];
    }else{
        NSLog(@"error:%@",error);
    }
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
    UserInfo *user = [Utilities GetNSUserDefaults];

    //评论
    NSDictionary *commentDict = @{
                                  @"itemId":[NSString stringWithFormat:@"%ld",_dataModel.id],
                                  @"type":self.cartoonModel.type,
                                  @"pageNum":@"0",
                                  @"pageSize":@"10",
                                  @"userId":[NSString stringWithFormat:@"%ld",user.id]
                                  };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
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
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
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
    //
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
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
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
    }else if(section == 1)
    {
        return 40;
    }else{
        if(self.commentArray.count > 0){
            ZZTCircleModel *item = self.commentArray[section - 2];
            return item.headerHeight;
        }
        return 0;
    }
}

//添加头 ZZTCartoonDetailFoot
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSLog(@"section%ld",section);
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
        headerView.delegate = self;
        ZZTCircleModel *model = self.commentArray[section - 2];
        [headerView setContentData:model section:section - 2];
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
//
//    //弹出键盘
//    ZZTCircleModel *item = self.commentArray[indexPath.section - 2];
//    ZZTUserReplyModel *model = item.replyComment[indexPath.row];
//    if(model){
//        customer *toUser = model.replyCustomer;
//        self.selectedSection = indexPath.section;
//        self.toPeople = @{
////                          @"comment_to_user_id": toUser.ID,
//                          @"comment_to_user_name":toUser.nickName,
//                          };
//        [self startComment];
//    }
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
    _keyboardManager.enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;


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
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    _keyboardManager = keyboardManager;
    keyboardManager.enableAutoToolbar = NO;
}

#pragma mark - SectionHeaderViewDelegate
- (void)spreadContent:(BOOL)isSpread section:(NSUInteger)section{
    ZZTCircleModel *item = self.commentArray[section - 2];
    item.isSpread = isSpread;
    item.headerHeight = [[FriendCircleViewModel new] getHeaderHeight:item];
    [self.tableView reloadData];
}

-(void)didClickLikeButton:(NSInteger)section{
    UserInfo *user = [Utilities GetNSUserDefaults];
    ZZTCircleModel *item = self.commentArray[section];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"type":@"3",
                          @"typeId":item.id,
                              @"cartoonId":self.cartoonModel.id
                          };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"great/cartoonPraise"]  parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//// 开始拖拽
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self hideKeyBoard];
//}
//
//- (void)hideKeyBoard {
//    [self.kTextView resignFirstResponder];
//}
//- (void)startComment {
//    [self.kTextView becomeFirstResponder];
//}

//- (void)dealloc {
//    [self.kInputView removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
//}
//
//
//- (void)textViewDidChange:(UITextView *)textView {
//    if (textView.text.length > 5000) { // 限制5000字内
//        textView.text = [textView.text substringToIndex:5000];
//    }
//    static CGFloat maxHeight = 36 + 24 * 2;//初始高度为36，每增加一行，高度增加24
//    CGRect frame = textView.frame;
//    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
//    CGSize size = [textView sizeThatFits:constraintSize];
//    if (size.height >= maxHeight) {
//        size.height = maxHeight;
//        textView.scrollEnabled = YES;   // 允许滚动
//    } else {
//        textView.scrollEnabled = NO;    // 不允许滚动
//    }
//    if ((ceil(size.height) + 14) != self.kInputHeight) {
//        CGPoint offset = self.tableView.contentOffset;
//        CGFloat delta = ceil(size.height) + 14 - self.kInputHeight;
//        offset.y += delta;
//        if (offset.y < 0) {
//            offset.y = 0;
//        }
//        [self.tableView setContentOffset:offset animated:NO];
//        self.kInputHeight = ceil(size.height) + 14;
//        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(ceil(size.height) + 14));
//        }];
//    }
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]){
//        if (self.kTextView.text.length > 0) {     // send Text
////            [self sendMessage:self.kTextView.text];
//        }
//        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@50);
//        }];
//        [self.kTextView setText:@""];
//        self.kInputHeight = 50;
//        [self hideKeyBoard];
//        return NO;
//    }
//    return YES;
//}
//
//#pragma mark - 通知方法
//- (void)keyboardWillChangeFrame:(NSNotification *)notification {
//    NSDictionary *userInfo = notification.userInfo;
//    // 1,取出键盘动画的时间
//    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    // 2,取得键盘将要移动到的位置的frame
//    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    // 3,计算kInputView需要平移的距离
//    CGFloat moveY = self.view.frame.size.height + TOPBAR_HEIGHT - keyboardFrame.origin.y;
//    // 4,执行动画
//
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
////    SectionHeaderView *headerView = (SectionHeaderView *)[self.tableView headerViewForSection:self.selectedSection];
////    CGRect rect = [headerView.superview convertRect:headerView.frame toView:window];
////    CircleItem *item = self.dataMuArr[self.selectedSection];
////    CGFloat cellHeight = item.likerHeight;
////    for (NSNumber *num in item.commentHeightArr) {
////        cellHeight += [num floatValue];
////    }
////    CGFloat footerMaxY = CGRectGetMaxY(rect) + cellHeight + item.footerHeight;
////    CGFloat delta = footerMaxY - (SCREEN_MAX_LENGTH - (moveY + self.kInputHeight));
////    CGPoint offset = self.tableView.contentOffset;
//////    offset.y += delta;
////    if (offset.y < 0) {
////        offset.y = 0;
////    }
////    [self.tableView setContentOffset:offset animated:NO];
////    [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
////        if (moveY == 0) {
////            make.bottom.equalTo(@(self.kInputHeight));
////        } else {
////            make.bottom.equalTo(@(-moveY));
////        }
////    }];
////    [UIView animateWithDuration:duration animations:^{
////        [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
////    }];
//}
////cell 漫画 3
//
@end
