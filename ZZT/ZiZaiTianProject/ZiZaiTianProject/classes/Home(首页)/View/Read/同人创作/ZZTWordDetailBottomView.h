//
//  ZZTWordDetailBottomView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/16.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

@interface ZZTWordDetailBottomView : UIView

@property (nonatomic, strong) NSString *cartoonType; /**< 众创2/独创1 */

@property (nonatomic, strong) ZZTChapterlistModel *lastReadData;

@property (nonatomic, strong) ZZTChapterlistModel *lastMultiReadData;

//开始阅读Bolck
@property (nonatomic,copy) void (^startRead)(void);

//继续阅读原版
@property (nonatomic,copy) void (^lastReadBook)(void);
//继续阅读同人
@property (nonatomic,copy) void (^lastMultiReadBook)(void);

@end

//NS_ASSUME_NONNULL_END
