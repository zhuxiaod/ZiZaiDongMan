//
//  ZZTStoryDetailCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/17.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTStoryModel;

@protocol ZZTStoryDetailCellDelegate <NSObject>

-(void)updataStoryCellHeight:(NSString *)story index:(NSUInteger)index;

@end

@interface ZZTStoryDetailCell : UITableViewCell

@property(nonatomic,strong) NSString *str;

@property(nonatomic,strong) ZZTStoryModel *model;

@property (nonatomic, weak) id <ZZTStoryDetailCellDelegate> delegate;

@property(nonatomic,assign) NSUInteger index;

@end
