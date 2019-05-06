//
//  ZZTReportBtn.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/23.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ZZTCommentBtn.h"
#import "ZZTCommentViewController.h"

@implementation ZZTCommentBtn

-(void)gotoCommentViewWithId:(NSString *)Id{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    ZZTCommentViewController *commentView = [[ZZTCommentViewController alloc] init];
    ZZTNavigationViewController *nav = [[ZZTNavigationViewController alloc] initWithRootViewController:commentView];
    commentView.isFind = YES;
    commentView.chapterId = Id;
    commentView.cartoonType = @"3";
    commentView.ishiddenTitleView = YES;
    [[self myViewController].navigationController presentViewController:nav animated:YES completion:nil];
}

@end
