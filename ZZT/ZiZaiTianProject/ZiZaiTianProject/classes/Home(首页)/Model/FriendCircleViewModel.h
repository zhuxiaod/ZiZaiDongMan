//
//  FriendCircleViewModel.h
//  WeChat1
//
//  Created by Topsky on 2018/5/11.
//  Copyright © 2018年 Topsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTCircleModel;

@interface FriendCircleViewModel : NSObject

@property (nonatomic,strong) NSMutableArray *circleModelArray;

- (NSMutableArray *)loadDatas;
- (CGFloat)getHeaderHeight:(ZZTCircleModel *)item;
- (void)calculateItemHeight:(ZZTCircleModel *)item;

@end
