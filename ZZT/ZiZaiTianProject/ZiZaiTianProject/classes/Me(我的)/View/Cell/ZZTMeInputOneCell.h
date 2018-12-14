//
//  ZZTMeInputOneCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/12.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMInputView;
@class ZZTMeInputOneCell;
@protocol ZZTMeInputOneCellDelegate <NSObject>

@optional

- (void)changeCellHeight:(ZZTMeInputOneCell *)cell textHeight:(CGFloat)textHeight index:(NSInteger)index;

- (void)contentChange:(ZZTMeInputOneCell *)cell content:(NSString *)content index:(NSInteger)index;

@end


@interface ZZTMeInputOneCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) CMInputView *cellTextView;

@property (nonatomic,strong) NSString *placeHolderStr;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) BOOL hiddenBottomView;

@property (nonatomic,weak)id<ZZTMeInputOneCellDelegate>   delegate;

- (CGFloat)myHeight ;

@end
