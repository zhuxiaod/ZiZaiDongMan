//
//  ZZTMaterialTypeView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/23.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMaterialTypeView.h"
#import "ZZTDetailModel.h"

@interface ZZTMaterialTypeView ()

@property (nonatomic,strong) NSArray *buttonData;

@property (nonatomic,assign) CGFloat btnWidth;

@property (nonatomic,strong)NSString *recodeStr;

@property (nonatomic,strong) NSMutableArray *buttons;


@end

@implementation ZZTMaterialTypeView

-(NSMutableArray *)buttons{
    if(!_buttons){
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(instancetype)init:(NSArray *)array Width:(CGFloat)width{
    if(self = [self init]){
        self.buttonData = array;
        self.showsHorizontalScrollIndicator = NO;
        _btnWidth = 60;
        [self initButtons];
        if(self.buttons.count > 0){
            UIButton *btn = self.buttons[0];
            [self buttonSelected:btn];
        }
    }
    return self;
}

-(void)initButtons{
    CGFloat H = 20;
    //每行列数
    NSInteger rank = _buttonData.count;
    //每列间距
    //每行间距
    CGFloat rowMargin = 5;
    //Item索引 ->根据需求改变索引
    NSUInteger index = _buttonData.count;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
   

    CGFloat X = 5;
    for (int i = 0 ; i< index; i++) {
        ZZTDetailModel *model = self.buttonData[i];
        CGSize size = [model.detail sizeWithAttributes:attrs];
        size.width = size.width + 20;
        
        if(i == 0){
            X = 5;
        }else{
            UIButton *btn = self.buttons[i - 1];
            X = CGRectGetMaxX(btn.frame) + 5;
        }
        
        NSLog(@"X:%f",X);
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        //Item top
        UIButton *btn = [[UIButton alloc] init];
        
        [btn setTitle:model.detail forState:UIControlStateNormal];
        //判断title字的数量 处理宽度
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor grayColor]];
        btn.frame = CGRectMake(X, Y, size.width, H);
        btn.selected = NO;
        btn.tag = index;
        [btn addTarget:self action:@selector(buttonSelected:)
      forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:btn];
        [self addSubview:btn];
    }
    self.contentSize = CGSizeMake(5 + _buttonData.count * (_btnWidth + 5), 20);
}

//ok
-(void)buttonSelected:(UIButton *)btn{
    self.recodeStr = btn.titleLabel.text;
    for (UIButton *button in self.buttons) {
        if([btn.titleLabel.text isEqualToString:button.titleLabel.text]){
            //被选中按钮
            button.selected = YES;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithHexString:@"#4AA1FC"]];
            button.layer.cornerRadius = 5.0f;
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = [UIColor colorWithHexString:@"#0069C3"].CGColor;
            //代理传值
            NSDictionary *dic = @{
                                  @"text":btn.titleLabel.text
                                  };
            NSNotification *notification = [NSNotification notificationWithName:@"btnIndex" object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else{
            button.selected = NO;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithHexString:@"#A1A2A3"]];
            button.layer.cornerRadius = 5.0f;
            button.layer.borderWidth = 2.0f;
            button.layer.borderColor = [UIColor colorWithHexString:@"#5C5D5E"].CGColor;
        }
    }
}
@end
