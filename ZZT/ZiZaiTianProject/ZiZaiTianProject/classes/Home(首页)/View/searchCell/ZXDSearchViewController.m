//
//  ZXDSearchViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/20.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZXDSearchViewController.h"
//search
#import "ZZTSearchCartoonCell.h"
#import "ZZTSearchZoneCell.h"
#import "ZZTFindCommentCell.h"
#import "ZXDSearchViewController.h"
#import "ZZTCartoonHeaderView.h"


@interface ZXDSearchViewController () <UITableViewDelegate,UITableViewDataSource,PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>
@property (nonatomic,strong) NSMutableArray *searchSuggestionArray;
@property (nonatomic,strong) ZZTNavigationViewController *nav;
@end

@implementation ZXDSearchViewController

- (NSMutableArray *)searchSuggestionArray{
    if(!_searchSuggestionArray){
        _searchSuggestionArray = [NSMutableArray array];
    }
    return _searchSuggestionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取热门搜索
    [self getHotSearch];
    NSArray *hotSeaches = @[@"妖神记", @"大霹雳", @"镖人", @"偷星九月天"];
    
    
    PYSearchViewController *searchVC = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索作品名、作者名、社区内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {

    }];

    searchVC.searchSuggestionView.delegate = self;
    searchVC.searchSuggestionView.dataSource = self;

    searchVC.hotSearchTitle = @"热门搜索";
    searchVC.delegate = self;
    searchVC.dataSource = self;

    //set cancelButton
    [searchVC.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [searchVC.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    ZZTNavigationViewController *nav = [[ZZTNavigationViewController alloc] initWithRootViewController:searchVC];
    _nav = nav;
    [self presentViewController:nav animated:NO completion:nil];
}

-(void)getHotSearch{
    //添加数据
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/hotSelect"]  parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)didClickCancel:(PYSearchViewController *)searchViewController{
    [self.navigationController popViewControllerAnimated:NO];
}

//搜索文字已经改变
#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        weakself(self);
        UserInfo *user = [Utilities GetNSUserDefaults];
        NSDictionary *dic = @{
                              @"fuzzy":searchText,
                              @"userId":[NSString stringWithFormat:@"%ld",user.id]
                              };
        //添加数据
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/queryCartoon"]  parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
            NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
            weakSelf.searchSuggestionArray = array;
            [searchViewController.searchSuggestionView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}
//搜索结果多少节
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView{
    return 1;
}
//多少行
- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section{
    return self.searchSuggestionArray.count;
}

//每行显示什么
- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.section == 0){
        ZZTSearchCartoonCell *cell = [ZZTSearchCartoonCell cellWithTableView:searchSuggestionView];
        ZZTCarttonDetailModel *model = self.searchSuggestionArray[indexPath.row];
        cell.model = model;
        return cell;
//    }else if (indexPath.section == 1){
//        ZZTSearchZoneCell *cell = [ZZTSearchZoneCell cellWithTableView:searchSuggestionView];
//        return cell;
//    }else{
//        ZZTFindCommentCell *cell = [ZZTFindCommentCell cellWithTableView:searchSuggestionView];
//        //        cell.model = self.dataArray[indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
}

//高度
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return SCREEN_HEIGHT * 0.22;
    }else if(indexPath.section == 1){
        return SCREEN_HEIGHT * 0.142;
    }else{
        return 100;
        //        ZZTMyZoneModel *model = _dataArray[indexPath.row];
        //        NSArray *imgs = [model.contentImg componentsSeparatedByString:@","];
        //        return  [ZZTFindCommentCell cellHeightWithStr:model.content imgs:imgs];
    }
}

- (UIView *)searchSuggestionView:(UITableView *)searchSuggestionView viewForHeaderInSection:(NSInteger)section{
    NSString *title;
//    if(section == 0){
        title = @"相关漫画";
//    }
//    else if (section == 1){
//        title = @"相关空间";
//    }else{
//        title = @"相关帖子";
//    }
    ZZTCartoonHeaderView *head = [[ZZTCartoonHeaderView alloc] init];
    head.title = title;
    return head;
}

-(void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath searchBar:(UISearchBar *)searchBar{
    ZZTCarttonDetailModel *md = self.searchSuggestionArray[indexPath.row];
    ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
    detailVC.isId = YES;
    detailVC.cartoonDetail = md;
    detailVC.hidesBottomBarWhenPushed = YES;
    [_nav pushViewController:detailVC animated:YES];
}

-(CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)searchSuggestionView:(UITableView *)searchSuggestionView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRGB:@"230,230,230"];
    return footerView;
}

- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForFooterInSection:(NSInteger)section{
    return 4;
}


@end
