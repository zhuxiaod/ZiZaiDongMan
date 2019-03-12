//
//  ZZTZoneWordView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/3/6.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTZoneWordView : UITableViewHeaderFooterView

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) CGFloat viewHeight;

@property (nonatomic,strong) void(^changeHeight)(void);

@property (nonatomic,assign) BOOL isSpreadWordHeight;

@property (nonatomic,assign) BOOL isShowView;


@end
