//
//  SBDatePickerView.h
//  DatePickerView
//
//  Created by mac on 2018/11/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBDatePickerView;

@protocol SBDatePickerViewDelegate <NSObject>

@optional

- (void)confirmDate:(SBDatePickerView *)datePickerView dateStr:(NSString *)str;

@end

@interface SBDatePickerView : UIView

@property (nonatomic,strong) NSString *date;

@property(nonatomic,weak)id<SBDatePickerViewDelegate> delegate;

@end
