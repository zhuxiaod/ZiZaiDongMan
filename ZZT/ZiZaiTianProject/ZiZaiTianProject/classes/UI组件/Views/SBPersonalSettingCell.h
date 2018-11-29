//
//  SBPersonalSettingCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBPersonalSettingCell : UITableViewCell

@property (nonatomic, strong) UIView        *mainView;//主视图
@property (nonatomic, strong) UILabel       *nameLabel;//名字

@property (nonatomic, strong) UILabel       *rightTextLabel;//右边显示文字
@property (nonatomic, strong) UIImageView   *arrowImageView;//箭头View
@property (nonatomic, strong) UIImageView   *topLine;//上分割线
@property (nonatomic, strong) UIImageView   *bottomLine;//下分割线
@property (nonatomic, strong) UITextField   *textField;

@property (nonatomic, assign) BOOL          showBottomLine;//显示底线
@property (nonatomic, assign) BOOL          showTopLine;//显示上边线
@property (nonatomic, assign) BOOL          showTextField;//显示上边线

@property (nonatomic,copy) void (^textFieldChange)(NSInteger tag);
@property (nonatomic,copy) void (^textFieldBeginEditing)(NSInteger tag);
@property (nonatomic,copy) void (^textFieldEndEditing)(NSInteger tag);

@property (nonatomic, strong) NSString *textFieldText;


@end
