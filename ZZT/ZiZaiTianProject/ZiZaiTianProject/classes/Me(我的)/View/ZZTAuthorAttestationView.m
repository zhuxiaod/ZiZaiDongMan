//
//  ZZTAuthorAttestationView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/13.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTAuthorAttestationView.h"
#import "ZZTLittleBoxView.h"
#import "ZZTWorkInstructionsViewController.h"

@interface ZZTAuthorAttestationView ()<TTTAttributedLabelDelegate,ZZTLittleBoxViewDelegate>

@property (nonatomic, strong) TTTAttributedLabel *textView;
@property (nonatomic, strong) TTTAttributedLabel *commitToMailLab;
@property (nonatomic, strong) TTTAttributedLabel *agreeLab;

@property (nonatomic, strong) ZZTLittleBoxView *boxOne;

@property (nonatomic, strong) ZZTLittleBoxView *boxTwo;

@property (nonatomic, assign) CGFloat labW;

@property (nonatomic, strong) UIButton *labBtn;

@end

@implementation ZZTAuthorAttestationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    CTUnderlineStyle linkUnderLineStyle = kCTUnderlineStyleSingle;

    //说明
    TTTAttributedLabel *textView = [TTTAttributedLabel new];
    textView.textColor = [UIColor lightGrayColor];
    NSString *textViewStr = @"作者认证会于三天内完成审核;\n提交审核前必须将作品部分章节与个人信息\n发送到自在动漫邮箱zjd@zztian.cn\n认证作者可发布个人原创的长漫画、素材、\n并获得收费、锁章节等权限。";
    textView.numberOfLines = 0;
    textView.lineSpacing = 3;
    textView.kern = 1.5;
    // 没有点击时候的样式
    textView.linkAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                         (NSString *)kCTForegroundColorAttributeName: ZZTSubColor,
                                         (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:linkUnderLineStyle]};
    textView.activeLinkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor colorWithRed:137.0/255.0 green:134.0/255.0 blue:219.0/255.0 alpha:1.0],(NSString *)kCTForegroundColorAttributeName,nil];
    NSRange selRange=[textViewStr rangeOfString:@"zjd@zztian.cn"];
    [textView setText:textViewStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[UIColor colorWithRed:137.0/255.0 green:134.0/255.0 blue:219.0/255.0 alpha:1.0] range:selRange];
        return mutableAttributedString;
    }];
    [textView addLinkToTransitInformation:@{@"select":@"zjd@zztian.cn"} withRange:selRange];

    textView.delegate = self;
    textView.lineBreakMode =NSLineBreakByTruncatingTail;
    self.textView = textView;
    [self addSubview:textView];

    //小按钮 2个
    ZZTLittleBoxView *boxOne = [[ZZTLittleBoxView alloc] init];
    boxOne.delegate = self;
    self.boxOne = boxOne;
    [self addSubview:boxOne];
    
    ZZTLittleBoxView *boxTwo = [[ZZTLittleBoxView alloc] init];
    self.boxTwo = boxTwo;
    boxTwo.delegate = self;
    [self addSubview:boxTwo];
    
    //label
    TTTAttributedLabel *commitToMailLab = [TTTAttributedLabel new];
    commitToMailLab.numberOfLines = 0;
    commitToMailLab.lineSpacing = SectionHeaderLineSpace;
    commitToMailLab.font = [UIFont systemFontOfSize:16];
    NSString *commitToMailStr = @"已提交了作品预览到邮箱";
    // 没有点击时候的样式
    commitToMailLab.linkAttributes = @{
                                (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    
    commitToMailLab.activeLinkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor blackColor],(NSString *)kCTForegroundColorAttributeName,nil];
    
    NSRange selRange1 = [commitToMailStr rangeOfString:@"已提交了作品预览到邮箱"];
    
    commitToMailLab.text = commitToMailStr;
    
//    [commitToMailLab setText:commitToMailStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[UIColor colorWithRed:137.0/255.0 green:134.0/255.0 blue:219.0/255.0 alpha:1.0] range:selRange1];
//        return mutableAttributedString;
//    }];
    
    [commitToMailLab addLinkToTransitInformation:@{@"select":@"已提交了作品预览到邮箱"} withRange:selRange1];
    
    commitToMailLab.textColor = [UIColor colorWithRGB:@"111,111,111"];

    commitToMailLab.delegate = self;
    self.commitToMailLab = commitToMailLab;
    [self addSubview:commitToMailLab];
    
    //TTTlab
    TTTAttributedLabel *agreeLab = [TTTAttributedLabel new];
    agreeLab.numberOfLines = 0;
    agreeLab.lineSpacing = SectionHeaderLineSpace;
    agreeLab.font = [UIFont systemFontOfSize:16];
    NSString *agreeLabStr = @"我已阅读并同意《自在动漫作者协议》";
    NSString *agreeStr = @"我已经阅读并同";
    
    _labW = [agreeStr getTextWidthWithFont:agreeLab.font];

    
    // 没有点击时候的样式
    agreeLab.linkAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                       (NSString *)kCTForegroundColorAttributeName:ZZTSubColor,
                                       (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    
    agreeLab.activeLinkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            ZZTSubColor,(NSString *)kCTForegroundColorAttributeName,nil];
    
    NSRange selRange2 = [agreeLabStr rangeOfString:@"《自在动漫作者协议》"];
    [agreeLab setText:agreeLabStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[UIColor colorWithRed:137.0/255.0 green:134.0/255.0 blue:219.0/255.0 alpha:1.0] range:selRange2];
        return mutableAttributedString;
    }];
    
    [agreeLab addLinkToTransitInformation:@{@"select":@"《自在动漫作者协议》"} withRange:selRange2];
    agreeLab.delegate = self;
    agreeLab.textColor = [UIColor colorWithRGB:@"111,111,111"];
    self.agreeLab = agreeLab;
    [self addSubview:agreeLab];
    
    //labButton
    UIButton *labBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [labBtn addTarget:self action:@selector(clickLabBtn) forControlEvents:UIControlEventTouchUpInside];
//    labBtn.backgroundColor = [UIColor redColor];
    _labBtn = labBtn;
    [self addSubview:labBtn];
}

-(void)clickLabBtn{
    [self.boxTwo btnTarget];
}

//点击按钮 获得状态
-(void)clickLittleBoxView:(ZZTLittleBoxView *)littleBoxView selectState:(NSString *)selectState{
    NSInteger tag;
    if(littleBoxView == self.boxOne){
        tag = 0;
    }else{
        tag = 1;
    }
    
    //如果是第一个
    if (self.delegate && [self.delegate respondsToSelector:@selector(getBoxStateWithTag:state:)])
    {
        // 调用代理方法
        [self.delegate getBoxStateWithTag:tag state:selectState];
    }
}

//文字的点击事件
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    NSLog(@"didSelectLinkWithTransitInformation :%@",components);
    NSString *string = [components objectForKey:@"select"];
    if([string isEqualToString:@"zjd@zztian.cn"]){
        NSLog(@"点击了邮箱");
    }else if ([string isEqualToString:@"已提交了作品预览到邮箱"]){
        NSLog(@"已提交了作品预览到邮箱");
        [self.boxOne btnTarget];
    }else if ([string isEqualToString:@"我已阅读并同意"]){
        NSLog(@"我已阅读并同意");
        [self.boxTwo btnTarget];
    }else{
        NSLog(@"《自在动漫作者协议》");
        ZZTWorkInstructionsViewController *workVC = [[ZZTWorkInstructionsViewController alloc] init];
        
        [[self myViewController].navigationController pushViewController:workVC animated:YES];
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-26);
        make.left.equalTo(self).offset(26);
        make.height.equalTo(self).multipliedBy(0.6);
    }];
    
    [self.boxOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView.mas_left);
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.boxTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView.mas_left);
        make.top.equalTo(self.boxOne.mas_bottom).offset(10);
        make.height.width.mas_equalTo(20);
    }];

    [self.commitToMailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boxOne.mas_right).offset(10);
        make.height.mas_equalTo(self.boxOne);
        make.centerY.equalTo(self.boxOne);
        make.right.equalTo(self).offset(-10);
    }];
    
    [self.agreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boxTwo.mas_right).offset(10);
        make.height.mas_equalTo(self.boxTwo);
        make.centerY.equalTo(self.boxTwo);
        make.right.equalTo(self).offset(-10);
    }];
    
    [self.labBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boxTwo.mas_right).offset(10);
        make.height.mas_equalTo(self.boxTwo);
        make.centerY.equalTo(self.boxTwo);
        make.width.mas_equalTo(self.labW);
    }];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    //间距
//    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
//    paragraphStyle.lineSpacing = 5;
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    NSNumber *kern=[NSNumber numberWithFloat:1.5];
//
//    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
//    [attributes setObject:kern forKey:NSKernAttributeName];
//    UIFont *font = [UIFont systemFontOfSize:16];
//    [attributes setObject:font forKey:NSFontAttributeName];
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_textView.text attributes:attributes];
//    NSUInteger length = _textView.text.length;
//    [attrString addAttribute:NSForegroundColorAttributeName value:ZZTSubColor range:NSMakeRange(43,13)];
//    _textView.attributedText = attrString;
    
    
    
}
@end
