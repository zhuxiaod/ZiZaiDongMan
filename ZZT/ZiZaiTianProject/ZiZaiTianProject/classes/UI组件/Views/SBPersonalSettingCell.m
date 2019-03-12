//
//  SBPersonalSettingCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "SBPersonalSettingCell.h"

@interface SBPersonalSettingCell ()<UITextFieldDelegate>

@end

@implementation SBPersonalSettingCell

- (UIView *)mainView{
    if (!_mainView) {
        self.mainView = [[UIView alloc] init];
        self.mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.mainView];
        [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _mainView;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:@"postDetail_arrow~iphone"];
        _arrowImageView.image = image;
        [self.mainView addSubview:_arrowImageView];
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(image.size);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(self.mainView);
        }];
    }
    return _arrowImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.mainView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.mainView);
            make.width.mas_equalTo(100);
        }];
    }
    return _nameLabel;
}

- (UILabel *)rightTextLabel{
    if (!_rightTextLabel) {
        _rightTextLabel = [UILabel new];
        _rightTextLabel.font = [UIFont systemFontOfSize:15];
        _rightTextLabel.textAlignment = NSTextAlignmentRight;
        _rightTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
//        _rightTextLabel.textColor = [UIColor redColor];
        [self.mainView addSubview:_rightTextLabel];
        [_rightTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).with.offset(20);
            make.right.mas_equalTo(self.arrowImageView.mas_left).with.offset(-10);
            make.centerY.mas_equalTo(self.mainView);
        }];
    }
    return _rightTextLabel;
}

-(UITextField *)textField{
    if(!_textField){
        _textField = [UITextField new];
        _textField.textColor = [UIColor blackColor];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.delegate = self;
        [self.mainView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).with.offset(20);
            make.right.mas_equalTo(self.arrowImageView.mas_left).with.offset(-10);
            make.centerY.mas_equalTo(self.mainView);
        }];
    }
    return _textField;
}

-(void)setTextFieldText:(NSString *)textFieldText{
    _textFieldText = textFieldText;
    if([textFieldText isEqualToString:@""]){
        self.textField.placeholder = @"未填写";
    }
    self.textField.text = textFieldText;
}

-(void)setTextFieldPlaceholder:(NSString *)textFieldPlaceholder{
    _textFieldPlaceholder = textFieldPlaceholder;

    self.textField.placeholder = textFieldPlaceholder;
    
    UIColor *color = [UIColor lightGrayColor];
    
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textFieldPlaceholder attributes:@{NSForegroundColorAttributeName: color}];

}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    NSString *blank = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if(![string isEqualToString:blank]) {
        return NO;
    }
    if(self.textFieldChange){
        self.textFieldChange(textField.tag);
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.textFieldChange){
        self.textFieldChange(textField.tag);
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(self.textFieldBeginEditing){
        self.textFieldBeginEditing(textField.tag);
    }
}



- (UIImageView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIImageView new];
        _bottomLine.image = [YYImage createImageWithColor:[UIColor colorWithHexString:@"#DCDCDC"]];
        [self.mainView addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(0);
        }];
    }
    return _bottomLine;
}

- (UIImageView *)topLine{
    if (!_topLine) {
        _topLine = [UIImageView new];
        _topLine.image = [YYImage createImageWithColor:[UIColor colorWithHexString:@"#DCDCDC"]];
        [self.mainView addSubview:_topLine];
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return _topLine;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setShowBottomLine:(BOOL)showBottomLine{
    self.bottomLine.hidden = !showBottomLine;
}

- (void)setShowTopLine:(BOOL)showTopLine{
    self.topLine.hidden = !showTopLine;
}

-(void)setShowTextField:(BOOL)showTextField{
    if(showTextField){
        //展示文本框 隐藏lab
        self.rightTextLabel.hidden = YES;
    }else{
        self.textField.hidden = YES;
    }
}
@end
