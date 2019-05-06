//
//  ZZTStatusViewModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ZZTStatusViewModel.h"

@implementation ZZTStatusViewModel

+(instancetype)initViewModel:(ZZTMyZoneModel *)model{
    
    ZZTStatusViewModel *viewModel = [[ZZTStatusViewModel alloc] init];
    
    viewModel.statusId = model.id;
    
    viewModel.headImgUrl = model.headimg;
    //下载图片
    viewModel.nickName = model.nickName;
    
    viewModel.ifConcern = [model.ifConcern integerValue];
    
    viewModel.userId = model.userId;
    
    viewModel.content = model.content;
    

    if(![model.contentImg isEqualToString:@""]){
        viewModel.imgArray = [model.contentImg componentsSeparatedByString:@","];
    }

    
    viewModel.dataText = [NSString compareCurrentTime:model.publishtime];
    
    viewModel.replyCount = [NSString stringWithFormat:@"%ld",model.replycount];
    
    viewModel.ifPraise = [model.ifpraise integerValue];
    
    viewModel.praisecount = [NSString stringWithFormat:@"%ld",model.praisecount];
    
    viewModel.isUser = [Utilities GetNSUserDefaults].id == [model.userId integerValue];
    
    viewModel.isVip = model.userVip;
    
    viewModel.publishtime = model.publishtime;
    
    return viewModel;
}
@end
