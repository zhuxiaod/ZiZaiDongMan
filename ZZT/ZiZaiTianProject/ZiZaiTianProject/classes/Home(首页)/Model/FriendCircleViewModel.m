//
//  FriendCircleViewModel.m
//  WeChat1
//
//  Created by Topsky on 2018/5/11.
//  Copyright © 2018年 Topsky. All rights reserved.
//

#import "FriendCircleViewModel.h"
#import "ZZTCircleModel.h"
#import "ZZTCommentHeaderView.h"
#import "ZZTUserReplyModel.h"
#import "customer.h"

//#import "SectionHeaderView.h"
//#import "PublicDef.h"
//#import "SKYStringManager.h"
//#import "NSString+SKYExtension.h"
//#import "LikeUserCell.h"
#import <UIKit/UIKit.h>

@implementation FriendCircleViewModel

-(NSMutableArray *)circleModelArray{
    if(!_circleModelArray){
        _circleModelArray = [NSMutableArray array];
    }
    return _circleModelArray;
}

//加载数据
- (NSMutableArray *)loadDatas {
    NSMutableArray *muArray = [NSMutableArray array];
    if(_circleModelArray.count > 0){
        for (int i = 0; i < self.circleModelArray.count; i++) {
            
            ZZTCircleModel *circleModel = self.circleModelArray[i];
            
            circleModel.nameLabelHeight = SectionHeaderNameLabelHeight;//20
            
            circleModel.contentLabelHeight = [self calculateStringHeight:circleModel.content];
            
//            circleModel.imgBgViewHeight = [self getImgBgViewHeight:circleModel];
            
            [self calculateItemHeight:circleModel];
            
            [muArray addObject:circleModel];
        }
    }
    return muArray;
}

//添加展开数据
-(NSMutableArray *)addOpenDataWith:(NSMutableArray *)array{
    for (int i = 0; i < array.count; i++) {
        ZZTCircleModel *openmodel = array[i];
        for (int a = 0; a < self.circleModelArray.count; a++) {
            ZZTCircleModel *circleModel = self.circleModelArray[a];
            if([openmodel.id isEqualToString:circleModel.id]){
                circleModel.isOpenComment = openmodel.isOpenComment;
            }
        }
    }
    return self.circleModelArray;
}

-(NSMutableArray *)loadCommentViewDatas{
    NSMutableArray *muArray = [NSMutableArray array];
    if(_circleModelArray.count > 0){
        for (int i = 0; i < self.circleModelArray.count; i++) {
            
            ZZTCircleModel *circleModel = self.circleModelArray[i];
            
            circleModel.nameLabelHeight = SectionHeaderNameLabelHeight;//20
            
            circleModel.contentLabelHeight = [self calculateStringHeight:circleModel.content];
            
            circleModel.headerHeight = 8 + 20 + 4 + circleModel.contentLabelHeight + 8;
            
            circleModel.isOpenComment = NO;
            
            [muArray addObject:circleModel];
        }
    }
    return muArray;
}

//计算高度
- (void)calculateItemHeight:(ZZTCircleModel *)item {
    //如果内容的高度是0
    if (item.contentLabelHeight == 0) {
        //头的高度
        item.headerHeight = SectionHeaderTopSpace + SectionHeaderVerticalSpace + SectionHeaderBottomSpace + item.nameLabelHeight + item.imgBgViewHeight + SectionHeaderTimeLabelHeight;//时间
    } else if (item.contentLabelHeight <= SectionHeaderMaxContentHeight){
        //如果内容的高度小于 节内容最大内容高度
        item.headerHeight = SectionHeaderTopSpace + SectionHeaderVerticalSpace * 2 + SectionHeaderBottomSpace + item.nameLabelHeight + item.contentLabelHeight + item.imgBgViewHeight + SectionHeaderTimeLabelHeight;
    } else {
        //计算高度
        item.headerHeight = [self getHeaderHeight:item];
    }
    //计算点赞的高度
//    item.likerHeight = [self calculateLikeUserCellHeight:item];
    //计算评论的高度
    item.commentHeightArr = [self calculateCellHeight:item];
//    如果没有评论 并且没有人点赞
//    if (item.replyComment.count <= 0 && item.like_users.count <= 0) {
    if (item.replyComment.count <= 0) {
        item.footerHeight = 12 - SectionHeaderBottomSpace - 2;
    } else {
        item.footerHeight = 12;
    }
}

//- (CGFloat)calculateLikeUserCellHeight:(ZZTCircleModel *)item {
//    NSArray *likeUserArr = item.like_users;
//    if (item.like_users.count <= 0) {
//        return 0;
//    }
//    NSString *str = [prefixStr copy];
//    for (int i = 0; i < likeUserArr.count; i++) {
//        NSString *userName = [likeUserArr[i] valueForKey:@"userName"];
//        str = [str stringByAppendingString:userName];
//        if (i != likeUserArr.count - 1) {
//            str = [str stringByAppendingString:@", "];
//        }
//    }
//    return ceil([str contentSizeWithWidth:SCREEN_MIN_LENGTH - (36 + SectionHeaderHorizontalSpace * 2 + 5) - SectionHeaderHorizontalSpace font:[UIFont systemFontOfSize:15] lineSpacing:SectionHeaderLineSpace].height) + 6;
//}

- (CGFloat)calculateStringHeight:(NSString *)text {
    return ceil([text contentSizeWithWidth:SCREEN_WIDTH - SectionHeaderHorizontalSpace * 3 - 36 font:[UIFont systemFontOfSize:SectionHeaderBigFontSize] lineSpacing:SectionHeaderLineSpace].height);
}

- (NSMutableArray *)calculateCellHeight:(ZZTCircleModel *)item {
    NSMutableArray *muArr = [NSMutableArray array];
    //内容
    for (int i = 0; i < item.replyComment.count; i++) {
        NSString *text = nil;
        ZZTUserReplyModel *model = item.replyComment[i];
        //回复人
        customer *replyer = model.replyCustomer;
        //说话的人
        customer *plyer = model.customer;
        //发布者
        customer *customer = item.customer;
        
        if(replyer.nickName == nil || [replyer.nickName length] <= 0 || [replyer.id isEqualToString:customer.id]){
            text = [NSString stringWithFormat:@"%@: %@",plyer.nickName,model.content];
        }else{
            text = [NSString stringWithFormat:@"%@回复%@: %@",plyer.nickName,replyer.nickName,model.content];
//            NSLog(@"text:%@ length:%lu",text,text.length);
        }
//        [[UIScreen mainScreen].bounds];
        // 8   8  2
        CGFloat height = ceil([text contentSizeWithWidth:326 font:[UIFont systemFontOfSize:15] lineSpacing:SectionHeaderLineSpace].height) + 6;
        
//        NSLog(@"height:%f",SCREEN_MIN_LENGTH - (36 + SectionHeaderHorizontalSpace * 2 + 5) - SectionHeaderHorizontalSpace);
//        NSLog(@"MIN(SCREEN_WIDTH, SCREEN_HEIGHT):%f",(MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)));
//        NSLog(@"width :%f",[UIScreen mainScreen].scale);
//        NSLog(@"height :%f",[UIScreen mainScreen].bounds.size.height);
        [muArr addObject:@(height)];
    }
    return muArr;
}

- (CGFloat)getImgBgViewHeight:(ZZTCircleModel *)item {
    switch (item.imageArray.count) {
        case 0:
            return 0;
        case 1:
            return SectionHeaderOnePictureHeight + SectionHeaderVerticalSpace;
        case 2:

        case 3:
            return SectionHeaderSomePicturesHeight + SectionHeaderVerticalSpace;
        case 4:

        case 5:

        case 6:
            return SectionHeaderSomePicturesHeight * 2 + SectionHeaderPictureSpace + SectionHeaderVerticalSpace;
        case 7:

        case 8:

        case 9:
            return SectionHeaderSomePicturesHeight * 3 + SectionHeaderPictureSpace * 2 + SectionHeaderVerticalSpace;
        default:
            return 0;
    }
}

- (CGFloat)getHeaderHeight:(ZZTCircleModel *)item {
    CGFloat height = 0;
    if (item.isSpread) {
        height = SectionHeaderTopSpace + SectionHeaderVerticalSpace * 3 + SectionHeaderBottomSpace + item.nameLabelHeight + item.contentLabelHeight + item.imgBgViewHeight + SectionHeaderTimeLabelHeight + SectionHeaderMoreBtnHeight;
    } else {
        height = SectionHeaderTopSpace + SectionHeaderVerticalSpace * 3 + SectionHeaderBottomSpace + item.nameLabelHeight + SectionHeaderMaxContentHeight + item.imgBgViewHeight + SectionHeaderTimeLabelHeight + SectionHeaderMoreBtnHeight;
    }
    return height;
}

@end
