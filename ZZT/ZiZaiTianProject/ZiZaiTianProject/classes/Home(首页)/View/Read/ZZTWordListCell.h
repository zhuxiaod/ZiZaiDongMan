//
//  ZZTWordListCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/22.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTChapterlistModel;
@class ZZTWordListCell;

typedef void (^RtValueBlock) (ZZTWordListCell *cell,ZZTChapterlistModel *model);

@interface ZZTWordListCell : UITableViewCell

@property (nonatomic,copy) RtValueBlock btnBlock;

@property (nonatomic,strong) ZZTChapterlistModel *model;

@end
