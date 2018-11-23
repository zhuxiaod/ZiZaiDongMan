//
//  ZZTMeEditViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/4.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMeEditViewController.h"
#import "ZZTMeEditTopView.h"
#import "ZZTMeEditButtomView.h"
#import "TypeButton.h"
#import "ZZTMePersonalView.h"

@interface ZZTMeEditViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) NSInteger btnTag;

@property (nonatomic,strong) UIImage *resultImage;

@property (nonatomic,strong) UIImagePickerController *picker;

@property (nonatomic,strong) ZZTMeEditButtomView *meButtomView;

@property (nonatomic,strong) UIButton *doneButton;

@property(nonatomic, strong) BAKit_PickerView *pickView;

@property(nonatomic, strong)BAKit_DatePicker *tempView;

@property(nonatomic, strong) ZZTMeEditTopView *topView;
//背景图
@property (nonatomic,strong) NSString *backImg;

@property (nonatomic,strong) UIImage *backImage;
//头像图
@property (nonatomic,strong) NSString *headImg;

@property (nonatomic,strong) UIImage *headImage;
//昵称
@property (nonatomic,strong) NSString *userName;
//性别
@property (nonatomic,assign) NSString *sex;
//生日
@property (nonatomic,strong) NSString *birthday;
//签名
@property (nonatomic,strong) NSString *signature;
//电话
@property (nonatomic,strong) NSString *phone;
//简介
@property (nonatomic,strong) NSString *intro;

@property (nonatomic,strong) NSMutableDictionary *imgeDict;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) ZXDNavBar *navbar;


@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *sectionOne;

@property (nonatomic,strong) NSArray *sectionTwo;

@property (nonatomic,strong) NSArray *sectionThree;

@property (nonatomic,strong) SBPersonalSettingCell *cell;

/** 选择性别提示 */
@property (nonatomic, strong) UIActionSheet     *sexActionSheet;
@property (nonatomic, strong) UITextField       *emailField;
@property (nonatomic, strong) UITextView        *signTextView;
@property (nonatomic, strong) UILabel           *placeText;

@end

@implementation ZZTMeEditViewController

static NSString *personalCellOne = @"personalCellOne";
static NSString *personalCellTwo = @"personalCellTwo";
static NSString *personalCellThree = @"personalCellThree";

-(NSMutableDictionary *)imgeDict{
    if(!_imgeDict){
        _imgeDict = [NSMutableDictionary dictionary];
    }
    return _imgeDict;
}

-(NSArray *)sectionOne{
    if(!_sectionOne){
        _sectionOne = [NSArray array];
    }
    return _sectionOne;
}

-(NSArray *)sectionTwo{
    if(!_sectionTwo){
        _sectionTwo = [NSArray array];
    }
    return _sectionTwo;
}

-(NSArray *)sectionThree{
    if(!_sectionThree){
        _sectionThree = [NSArray array];
    }
    return _sectionThree;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewNavBar.centerButton setTitle:@"个人信息" forState:UIControlStateNormal];
    [self.viewNavBar.rightButton setTitle:@"上传" forState:UIControlStateNormal];
    [self.viewNavBar.rightButton addTarget:self action:@selector(successUp) forControlEvents:UIControlEventTouchUpInside];

    //左边
    [self addBackBtn];
    
    
    self.sectionOne = @[@"昵称",@"账号"];
    
    self.sectionTwo = @[@"性别",@"年龄"];
    
    self.sectionThree = @[@"个性签名"];
    
    //设置mainView
    [self setupMainView];



    
    [self setupTopView];

    //初始化图像选择控制器
    _picker = [[UIImagePickerController alloc]init];
    _picker.allowsEditing = YES;  //重点是这两句
    
    //遵守代理
    _picker.delegate =self;

//    //注册观察键盘的变化
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
//
//    [self setupNavBar];
//
//    [self hiddenViewNavBar];
   
}

-(void)dismissVC{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)setupMainView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHeight , SCREEN_WIDTH, SCREEN_HEIGHT - navHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    _tableView.sectionHeaderHeight = 0;
//    _tableView.sectionFooterHeight = 0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    //让tableview不显示分割线
    //隐藏滚动条
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[SBPersonalSettingCell class] forCellReuseIdentifier:personalCellOne];
    [_tableView registerClass:[SBPersonalSettingCell class] forCellReuseIdentifier:personalCellTwo];
    [_tableView registerClass:[SBPersonalSettingCell class] forCellReuseIdentifier:personalCellThree];

}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return self.sectionOne.count;
    }else if(section == 1){
        return self.sectionTwo.count;
    }else{
        return self.sectionThree.count;
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfo *user = [Utilities GetNSUserDefaults];
    if(indexPath.section == 0){
        SBPersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:personalCellOne];
        if (!cell) {
            cell = [[SBPersonalSettingCell alloc] initWithStyle:0 reuseIdentifier:personalCellOne];
        }
        cell.nameLabel.text = [self.sectionOne objectAtIndex:indexPath.row];
        if(indexPath.row == 0){
            //用户名
            cell.showTextField = YES;
            cell.textField.text = self.userName;
            cell.textField.tag = 99;
            cell.textFieldChange = ^(NSInteger tag) {
                [self textFieldChange:tag];
            };
            cell.showBottomLine = YES;
        }else{
            //账号
            cell.showTextField = NO;
            cell.rightTextLabel.text = self.phone;
        }
        return cell;
    }else if (indexPath.section == 1){
        SBPersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:personalCellTwo];
        if (!cell) {
            cell = [[SBPersonalSettingCell alloc] initWithStyle:0 reuseIdentifier:personalCellTwo];
        }
        cell.nameLabel.text = [self.sectionTwo objectAtIndex:indexPath.row];
        if(indexPath.row == 0){
            if([user.sex isEqualToString:@"1"]){
                cell.rightTextLabel.text = @"男";
            }else{
                cell.rightTextLabel.text = @"女";
            }
            cell.showBottomLine = YES;
        }else{
            cell.rightTextLabel.text = self.birthday;
        }
        return cell;
    }else{
        SBPersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:personalCellThree];
        if (!cell) {
            cell = [[SBPersonalSettingCell alloc] initWithStyle:0 reuseIdentifier:personalCellThree];
        }
        cell.nameLabel.text = [self.sectionThree objectAtIndex:indexPath.row];
        //个性签名
        cell.showTextField = YES;
        cell.textField.text = self.signature;
        cell.textField.tag = 100;
        cell.textFieldChange = ^(NSInteger tag) {
            [self textFieldChange:tag];
        };
        return cell;
    }
}

-(void)textFieldChange:(NSInteger)tag{
    if(tag == 99){
        //更新userName
        UITextField *textView = (UITextField *)[self.view viewWithTag:tag];
        self.userName = textView.text;
        NSLog(@"textView:%@",textView.text);
    }else{
        UITextField *textView = (UITextField *)[self.view viewWithTag:tag];
        //更新个人签名数据
        self.signature = textView.text;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            //性别
            NSLog(@"性别");
            //选择性别
            [self callSexActionSheet];
        }else{
            //年龄
            NSLog(@"年龄");
            [self setupBirthday];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Screen_Height * 0.36;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRGB:@"231,231,231"];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}

-(void)setupTopView{
    //添加topView
    ZZTMeEditTopView *topView = [ZZTMeEditTopView ZZTMeEditTopView];
    _topView = topView;
    //假如现在有数据  添加进去
    topView.backImage = self.backImg;
    topView.headImage = self.headImg;
    
   
    topView.buttonAction = ^(UIButton *sender) {
        [self clickBtn:sender];
    };
    _tableView.tableHeaderView = topView;
}

//-(void)setupBottomView{
//    //添加buttomView
//    __block ZZTMeEditViewController *blockSelf = self;
//    ZZTMeEditButtomView *meButtomView = [ZZTMeEditButtomView ZZTMeEditButtomView];
//    _meButtomView = meButtomView;
//    meButtomView.model = self.model;
//    _meButtomView.TextChange = ^(UITextField *texyField) {
//        [blockSelf textChange:texyField];
//    };
//    meButtomView.frame = CGRectMake(0, 300, SCREEN_WIDTH, 400);
//
//    _meButtomView.BtnInside = ^(TypeButton *btn) {
//        [blockSelf clickPickBtn:btn];
//    };
//    [_scrollView addSubview:_meButtomView];
//}

//保存
-(void)saveWithImgType:(NSString *)imgType{
    //传字典 知道刚才点的是哪一张 知道是哪一张上传
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *imageName = [NSString getCurrentTimes];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        //判断是上传什么的
        BOOL result = NO;
        if([imgType isEqualToString:@"headImg"]){
            result = [UIImagePNGRepresentation(self.headImage) writeToFile:filePath atomically:YES];
        }else{
            result = [UIImagePNGRepresentation(self.backImage) writeToFile:filePath atomically:YES];
        }

        if (result == YES) {
            NSLog(@"保存成功");

            AFNHttpTool *tool = [[AFNHttpTool alloc] init];
            NSString *toke = [tool makeToken:ZZTAccessKey secretKey:ZZTSecretKey];

            [AFNHttpTool putImagePath:filePath key:imageName token:toke complete:^(id objc) {
//                NSLog(@"111%@",objc); //  上传成功并获取七牛云的图片地址
                self.headImg = objc;
                [self.imgeDict setObject:objc forKey:imgType];
            }];

        }else{
            NSLog(@"保存失败");
        }
//        }
//        if(imgDict.count == 0){
//            [self successUp];
//        }
    });
}

-(void)successUp{
    //遍历字典
    NSArray *imgDict = [self.imgeDict allKeys];
    for (int i = 0; i < imgDict.count; i++) {
        NSString *key = imgDict[i];
        if ([key isEqualToString:@"headImg"]) {
            self.headImg = [self.imgeDict objectForKey:@"headImg"];
        }else{
            self.backImg = [self.imgeDict objectForKey:@"backImg"];
        }
    }
    

    //判断有无前缀 有前缀的 把前缀取消
    if([[self.headImg substringToIndex:4]isEqualToString:@"http"]){
        self.headImg = [self.headImg substringFromIndex:25];
    }
    
    if([[self.backImg substringToIndex:4]isEqualToString:@"http"]){
        self.backImg = [self.backImg substringFromIndex:25];
    }

    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"nickName":self.userName,
                          @"intro":self.signature,//空
                          @"sex":self.sex,//
                          @"birthday":self.birthday,//空
                          @"headimg":self.headImg,//空
                          @"cover":self.backImg
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"login/upUser"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //保存本地
        //请求一次 拿到数据
        [self loadUserData];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//走了
-(void)textChange:(UITextField *)tf{
    if(tf.tag == 0){
        //名字
        self.userName = tf.text;
    }else if(tf.tag == 2){
        //签名
        self.signature = tf.text;
    }
}

-(void)clickPickBtn:(TypeButton *)btn{
    //男
    if(btn.tag == 1){
        [self pickView2:btn];
        //生日
    }else if(btn.tag == 3){
//        [self pickView4:btn];
    }else if(btn.tag == 4){
        [self pickView2:btn];
    }
}

#pragma mark - topView
-(void)clickBtn:(UIButton *)btn{
    //背景
    if (btn.tag == 1) {
         [self pushPhotoAlbum:btn];
    }else if (btn.tag == 2){
        //头像
        [self alert:btn];
    }
}

#pragma mark - 相册回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%@",info);
    UIButton *button = (UIButton *)[self.view viewWithTag:_btnTag];
    //选取的图片
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //判断分类
    NSString *imageType;
    if(_btnTag == 1){
        _backImage = resultImage;
        [self.imgeDict setObject:resultImage forKey:@"backImg"];
        imageType = @"backImg";
    }else{
        _headImage = resultImage;
        [self.imgeDict setObject:resultImage forKey:@"headImg"];
        imageType = @"headImg";
    }
    //上传七牛云
    [self saveWithImgType:imageType];
    //展示
    [button setImage:[resultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
    button.imageView.clipsToBounds = YES;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//调用相册
-(void)pushPhotoAlbum:(UIButton *)btn{
    //告诉是哪一个btn
    _btnTag = btn.tag;
    //调用系统相册的类
//    _picker = [[UIImagePickerController alloc]init];
    //设置选取的照片是否可编辑
    _picker.allowsEditing = YES;
    //设置相册呈现的样式
    _picker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    [self.navigationController presentViewController:_picker animated:YES completion:nil];
}

//调用相机
-(void)pushCamera:(UIButton *)btn{
    //告诉是哪一个btn
    _btnTag = btn.tag;
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        // 将sourceType设为UIImagePickerControllerSourceTypeCamera代表拍照或拍视频
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置拍摄照片
        _picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModePhoto;
        // 设置使用手机的后置摄像头（默认使用后置摄像头）
        _picker.cameraDevice =UIImagePickerControllerCameraDeviceRear;
        // 设置使用手机的前置摄像头。
        //picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        // 设置拍摄的照片允许编辑
        _picker.allowsEditing =YES;
    }else{
        NSLog(@"模拟器无法打开摄像头");
    }
    // 显示picker视图控制器
    [self presentViewController:_picker animated:YES completion:nil];
}

-(void)alert:(UIButton *)btn{
    //标题
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择打开方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //相机
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushCamera:btn];
    }];
    //相册
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushPhotoAlbum:btn];
    }];

    //取消按钮
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    //添加各个按钮事件
    [alert addAction:camera];
    [alert addAction:photo];
    [alert addAction:cancel];
    //弹出sheet提示框
    [self presentViewController:alert animated:YES completion:nil];
}

//移动UIView
-(void)transformView:(NSNotification *)aNSNotification
{
    //获取键盘弹出前的Rect
    NSValue *keyBoardBeginBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyBoardBeginBounds CGRectValue];

    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];

    //获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;

    //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}

- (void)pickView2:(TypeButton *)btn
{
    //如果是男生
    if(btn.tag == 1){
        if(btn.selected == NO){
            btn.selected = YES;
            //设置值
            TypeButton *button = (TypeButton *)[self.meButtomView viewWithTag:4];
            button.selected = NO;
            self.sex = @"1";
        }
    }else{
        //如果是女生
        if(btn.selected == NO){
            btn.selected = YES;
            //设置值
            TypeButton *button = (TypeButton *)[self.meButtomView viewWithTag:1];
            button.selected = NO;
            self.sex = @"2";
        }
        //图片七牛云上传
    }
}

- (void)setupBirthday
{
    [BAKit_DatePicker ba_creatPickerViewWithType:BAKit_CustomDatePickerDateTypeYMD configuration:^(BAKit_DatePicker *tempView) {
        NSDate *maxdDate;
        NSDate *mindDate;
        NSDateFormatter *format = [NSDateFormatter ba_setupDateFormatterWithYMD];
        NSDate *today = [[NSDate alloc]init];
        [format setDateFormat:@"yyyy-MM-dd"];
        
        self.tempView = tempView;
        
        // 最小时间，当前时间
        mindDate = [format dateFromString:[format stringFromDate:today]];

        NSTimeInterval oneDay = 24 * 60 * 60;
        // 最大时间，当前时间+180天
        NSDate *theDay = [today initWithTimeIntervalSinceNow:oneDay * 180];
        maxdDate = [format dateFromString:[format stringFromDate:theDay]];
        tempView.isShowBackgroundYearLabel = YES;

        // 自定义 pickview title 的字体颜色
        tempView.ba_pickViewTitleColor = [UIColor whiteColor];
        // 自定义 pickview title 的字体
        tempView.ba_pickViewTitleFont = [UIFont boldSystemFontOfSize:15];
        // 自定义 pickview背景 title 的字体颜色
        // 自定义：动画样式
        tempView.animationType = BAKit_PickerViewAnimationTypeBottom;

        // 自定义：pickView 文字颜色
        tempView.ba_pickViewTextColor = [UIColor blackColor];
        // 自定义：pickView 文字字体
        tempView.ba_pickViewFont = [UIFont systemFontOfSize:13];

        // 可以自由定制按钮颜色
        tempView.ba_buttonTitleColor_sure = [UIColor whiteColor];
        tempView.ba_buttonTitleColor_cancle = [UIColor whiteColor];

        // 可以自由定制 toolBar 和 pickView 的背景颜色
        tempView.ba_backgroundColor_toolBar = [UIColor colorWithHexString:@"#58006E"];
    } block:^(NSString *resultString) {
        self.birthday = resultString;
        [self.tableView reloadData];
        self.birthday = resultString;
    }];
}

-(void)setModel:(UserInfo *)model{
    _model = model;
    //背景图
    self.backImg = model.cover;
    [self.imgeDict setObject:self.backImg forKey:@"backImg"];
    //头像
    self.headImg = model.headimg;
    
    self.userName = model.nickName;
    
    self.signature = model.intro;
    
    self.sex = model.sex;
    
    self.birthday = model.birthday;//1.男 2.女
    
    self.phone = model.phone;
    
    self.intro = model.intro;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_meButtomView.userNameTF endEditing:YES];
    [_meButtomView.userDetailTF endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.alpha = 0;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self save];
}

-(void)loadUserData{
    //通过id 获取数据
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *paramDict = @{
                                @"userId":[NSString stringWithFormat:@"%ld",_model.id]
                                };
    [manager POST:[ZZTAPI stringByAppendingString:@"login/usersInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        
        NSArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
        if(array.count != 0){
            UserInfo *model = array[0];
            [Utilities SetNSUserDefaults:model];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark - 选择性别
- (void)callSexActionSheet{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"亲~请选择你的性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setupSexWithsex:1];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setupSexWithsex:2];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];

    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    
    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

//选择性别
- (void)setupSexWithsex:(NSInteger)sex{
    NSString *sexStr;
    if (sex == 1) {
        sex = 1;
        //男生
        sexStr = @"1";
    }else{
        sex = 2;
        //女生
        sexStr = @"2";
    }
    self.sex = sexStr;

    //更新用户资料
    [UserInfoManager share].sex = sexStr;
    [self.tableView reloadData];

}
@end
