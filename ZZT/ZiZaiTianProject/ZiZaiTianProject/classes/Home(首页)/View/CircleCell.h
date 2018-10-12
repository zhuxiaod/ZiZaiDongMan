//
//  CircleCell.h
//  WeChat1
//
//  Created by Topsky on 2018/5/11.
//  Copyright © 2018年 Topsky. All rights reserved.
//


@protocol CircleCellDelegate <NSObject>

@optional

- (void)didSelectPeople:(NSDictionary *)dic;

@end

@class ZZTCircleModel;

@interface CircleCell : UITableViewCell

@property (nonatomic, weak) id <CircleCellDelegate> delegate;

- (void)setContentData:(ZZTCircleModel *)item index:(NSInteger)index;

@end
