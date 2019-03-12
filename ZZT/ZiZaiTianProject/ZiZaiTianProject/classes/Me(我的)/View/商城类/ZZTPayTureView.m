//
//  ZZTPayTureView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTPayTureView.h"

@interface ZZTPayTureView ()

//@property (weak, nonatomic) IBOutlet UILabel *ZbLab;
//
//@property (weak, nonatomic) IBOutlet UILabel *originalPriceLab;
//@property (weak, nonatomic) IBOutlet UILabel *salePriceLab;

@property (weak, nonatomic) IBOutlet UILabel *ZbLab;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (assign, nonatomic) NSInteger saleMoney;
@end

@implementation ZZTPayTureView

+(instancetype)payTureView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZZTPayTureView" owner:nil options:nil] firstObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.payBtn.layer.cornerRadius = 15;
}

//确认支付
- (IBAction)confirmPayment:(UIButton *)sender {
    NSLog(@"[Utilities GetNSUserDefaults].userVip:%@",[Utilities GetNSUserDefaults].userVip);
    NSString *zbNum;
    if([[Utilities GetNSUserDefaults].userVip isEqualToString:@"0"]){
        zbNum = _originalPrice;
    }else{
        zbNum = [NSString stringWithFormat:@"%ld",_saleMoney];
    }
    
    if(self.payTureBlock){
        self.payTureBlock(zbNum);
    }
}

//进入界面
- (IBAction)gotoTopupView:(UIButton *)sender {
    if(self.GotoTopupViewBlock){
        self.GotoTopupViewBlock();
    }
}

//设置原价
-(void)setOriginalPrice:(NSString *)originalPrice{
    _originalPrice = originalPrice;
    self.originalPriceLab.text = [NSString stringWithFormat:@"应付%@Z币",originalPrice];
    _saleMoney = [originalPrice integerValue] * 0.85;
    self.salePriceLab.text = [NSString stringWithFormat:@"%ldZ币",_saleMoney];
}

-(void)setZbNum:(NSString *)zbNum{
    self.ZbLab.text = zbNum;
}
@end
