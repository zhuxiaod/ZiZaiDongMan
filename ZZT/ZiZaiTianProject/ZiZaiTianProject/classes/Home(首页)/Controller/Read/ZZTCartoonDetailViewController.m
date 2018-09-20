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

@interface ZZTCartoonDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *cartoonDetailArray;

@property (nonatomic,strong) NSArray *commentArray;


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) BOOL isNavHide;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,assign) BOOL isOnce;

@property (nonatomic,assign) BOOL isJXYD;

@property (nonatomic,strong) ZZTJiXuYueDuModel *model;

@end

NSString *CartoonContentCellIdentifier = @"CartoonContentCellIdentifier";

NSString *Comment = @"Comment";

NSString *story = @"story";

NSString *storyDe = @"storyDe";

@implementation ZZTCartoonDetailViewController

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
}

//中间内容
- (void)setupTitleView {
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.8, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:textView.frame];
    
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.viewTitle;
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
        //漫画
        if([self.type isEqualToString:@"1"]){
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
        if([self.type isEqualToString:@"1"]){
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

-(void)setType:(NSString *)type{
    _type = type;
}

//需要传1 或者2
-(void)setCartoonId:(NSString *)cartoonId{
    weakself(self);
    if([_type isEqualToString:@"1"]){
        NSDictionary *paramDict = @{
                                    @"id":cartoonId
                                    };
        [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"cartoon/cartoonImg"] parameters:paramDict success:^(id responseObject) {
            NSString *data = responseObject[@"result"];
            NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:data];
            NSArray *array = [ZZTCartoonModel mj_objectArrayWithKeyValuesArray:dic];
            weakSelf.cartoonDetailArray = array;
            [self.tableView reloadData];
//            [self.tableView layoutIfNeeded];
            [self reloadCellWithIndex];
        } failure:^(NSError *error) {
            
        }];
    }else{
        //章节
        NSDictionary *paramDict = @{
                                    @"cartoonId":@"7"
                                    };
        [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"cartoon/selChapterinfo"] parameters:paramDict success:^(id responseObject) {
            NSString *data = responseObject[@"result"];
            NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:data];
            NSArray *array = [ZZTStoryModel mj_objectArrayWithKeyValuesArray:dic];
            weakSelf.cartoonDetailArray = array;
            [self.tableView reloadData];
//            [self.tableView layoutIfNeeded];
            [self reloadCellWithIndex];
        } failure:^(NSError *error) {
            
        }];
    }
    //评论
    NSDictionary *Dict = @{
                            @"itemId":@"1"
                            };
    [AFNHttpTool POST:[ZZTAPI stringByAppendingString:@"cartoon/cartoonComment"] parameters:Dict success:^(id responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        //这里有问题 应该是转成数组 然后把对象取出
        NSArray *array1 = [ZZTCircleModel mj_objectArrayWithKeyValuesArray:dic];
        
        weakSelf.commentArray = array1;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

//请求数据后显示那一行
-(void)reloadCellWithIndex{
    if(self.isJXYD){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSIndexPath *dayOne = [NSIndexPath indexPathForRow:[self.model.bookIndex integerValue] inSection:0];
            [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    }
}

#pragma mark UITableViewDataSource 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 100;
    }{
        return 40;
    }
}

//添加头 ZZTCartoonDetailFoot
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        ZZTAuthorHeadView *authorHead = [ZZTAuthorHeadView AuthorHeadView];
        return authorHead;
    }else{
        ZZTCommentHeadView *commentHeadView = [[ZZTCommentHeadView alloc] init];
        commentHeadView.backgroundColor = [UIColor whiteColor];
        return commentHeadView;
    }
}

//续画
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        ZZTContinueToDrawHeadView *view = [ZZTContinueToDrawHeadView ContinueToDrawHeadView];
        view.array = self.cartoonDetailArray;
        return view;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 150;
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
#pragma mark 滚动更新
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITableViewCell *cell = [self.tableView visibleCells].firstObject;
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
//    NSLog(@"第几组%ld::::第几个%ld",index.section,index.row);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UITableViewCell *cell = [self.tableView visibleCells].firstObject;
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    //持续更新
    self.model.bookIndex = [NSString stringWithFormat:@"%ld",(long)index.row];
    self.model.bookName = self.viewTitle;
    ZZTCartoonModel *model = self.cartoonDetailArray[0];
    self.model.bookChapter = model.chapterId;
    //保存记录
    BOOL isHave = NO;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    NSArray *getArray = [NSKeyedUnarchiver unarchiveObjectWithData:[user objectForKey:@"saveModelArray"]];
    NSMutableArray *getArray1 = [getArray mutableCopy];
    for (int i = 0; i < getArray.count; i++) {
        ZZTJiXuYueDuModel *model = getArray[i];
        //如果找到名字相同的对象 更新
        if([model.bookName isEqualToString:self.viewTitle]){
            model = self.model;
            NSLog(@"index====:%@",model.bookIndex);
            [getArray1 replaceObjectAtIndex:i withObject:model];
            isHave = YES;
            break;
        }
    }
    
    if(isHave == YES){
        NSLog(@"数组里面有这个");
        //直接保存了
        NSData *modelDataArr = [NSKeyedArchiver archivedDataWithRootObject:[getArray1 copy]];
        [user setObject:modelDataArr forKey:@"saveModelArray"];
        [user synchronize];
    }else{
        NSLog(@"数组里面没有这个");
        NSMutableArray *array = [NSMutableArray array];
        //如果没有  保存进去
        if(getArray == nil){
            array = [NSMutableArray array];
            [array addObject:self.model];
        }else{
            array = [getArray mutableCopy];
            [array addObject:self.model];
        }

        NSData *modelDataArr = [NSKeyedArchiver archivedDataWithRootObject:[array copy]];
        [user setObject:modelDataArr forKey:@"saveModelArray"];
        [user synchronize];
    }
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
