//
//  ZZTStatusCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZTStatusViewModel;

@interface ZZTStatusTabCell : UITableViewCell

@property (nonatomic, strong) ZZTStatusViewModel *viewModel;
@property (weak, nonatomic) IBOutlet ZZTReportBtn *reportBtn;

@property (nonatomic,strong) void(^reloadDataBlock)(void);


@end

NS_ASSUME_NONNULL_END
