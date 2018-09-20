//
//  ZZTMeEditTopView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/4.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMeEditTopView.h"
@interface ZZTMeEditTopView()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@end
@implementation ZZTMeEditTopView

+(instancetype)ZZTMeEditTopView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

-(void)awakeFromNib{
    _imageBtn.tag = 1;
    [_imageBtn addTarget:self action:@selector(clickBrn:) forControlEvents:UIControlEventTouchUpInside];
    _headBtn.tag = 2;
    [_headBtn addTarget:self action:@selector(clickBrn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setBackImage:(NSString *)backImage{
    _backImage = backImage;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:backImage]];
    [self.imageBtn setTitle:@"" forState:UIControlStateNormal];
}


-(void)setHeadImage:(NSString *)headImage{
    _headImage = headImage;
    [self.headView sd_setImageWithURL:[NSURL URLWithString:headImage]];
}

-(void)clickBrn:(UIButton *)btn{
    if(self.buttonAction){
        self.buttonAction(btn);
    }
}
@end
