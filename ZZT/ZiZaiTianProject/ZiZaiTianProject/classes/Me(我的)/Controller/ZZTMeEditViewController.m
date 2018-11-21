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

@property (nonatomic,strong) NSMutableDictionary *imgeDict;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) ZXDNavBar *navbar;


@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *sectionOne;

@property (nonatomic,strong) NSArray *sectionTwo;

@property (nonatomic,strong) NSArray *sectionThree;

@property (nonatomic,strong) SBPersonalSettingCell *cell;

@end

@implementation ZZTMeEditViewController

-(NSMutableDictionary *)imgeDict{
    if(!_imgeDict){
        _imgeDict = [NSMutableDictionary dictionary];
    }
    return _imgeDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewNavBar.centerButton setTitle:@"个人信息" forState:UIControlStateNormal];
    [self.viewNavBar.rightButton setTitle:@"上传" forState:UIControlStateNormal];
    //左边
    [self addBackBtn];
    
    //设置mainView
    [self setupMainView];
    
    self.sectionOne = @[@"昵称",@"账号",@"空间二维码"];
    
    self.sectionTwo = @[@"性别",@"年龄"];
    
    self.sectionThree = @[@"个性签名"];


    
//    [self setupTopView];
//
//
//    [self setupBottomView];
//
//    //初始化图像选择控制器
//    _picker = [[UIImagePickerController alloc]init];
//    _picker.allowsEditing = YES;  //重点是这两句
//
//    //遵守代理
//    _picker.delegate =self;
//
//    //注册观察键盘的变化
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
//
//    [self setupNavBar];
//
//    [self hiddenViewNavBar];
   
}

-(void)setupNavBar{
    ZXDNavBar *navbar = [[ZXDNavBar alloc] init];
    self.navbar = navbar;
    navbar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navbar];
    
    [navbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@(navHeight));
    }];
    
    navbar.showBottomLabel = NO;
    
    //设置内容
    //返回
    [navbar.leftButton setImage:[UIImage imageNamed:@"返回键"] forState:UIControlStateNormal];
    navbar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
    [navbar.leftButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    
    //中
    [navbar.centerButton setTitle:@"编辑个人信息" forState:UIControlStateNormal];
    [navbar.centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [navbar.rightButton setTitle:@"上传" forState:UIControlStateNormal];
    [navbar.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navbar.rightButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dismissVC{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)setupMainView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHeight , SCREEN_WIDTH, SCREEN_HEIGHT - navHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    //让tableview不显示分割线
    //隐藏滚动条
    _tableView.showsVerticalScrollIndicator = NO;
    
    //添加头视图
    ZZTMePersonalView *personalView = [ZZTMePersonalView mePersonalView];
    personalView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.36);
    _tableView.tableHeaderView = personalView;
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
    if(indexPath.section == 0){
        NSString *personalCellOne = @"personalCellOne";
        SBPersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:personalCellOne forIndexPath:indexPath];
        if (!cell) {
            cell = [[SBPersonalSettingCell alloc] initWithStyle:0 reuseIdentifier:personalCellOne];
        }
        cell.nameLabel.text = [self.sectionOne objectAtIndex:indexPath.row];
        if(indexPath.row == 0){
            //用户名
        }else if (indexPath.row == 1){
            //账号
        }else{
            //二维码
        }
        return cell;
    }else if (indexPath.section == 1){
        NSString *personalCellTwo = @"personalCellTwo";
        SBPersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:personalCellTwo forIndexPath:indexPath];
        if (!cell) {
            cell = [[SBPersonalSettingCell alloc] initWithStyle:0 reuseIdentifier:personalCellTwo];
        }
        cell.nameLabel.text = [self.sectionTwo objectAtIndex:indexPath.row];
        cell.rightTextLabel.text = @"请选择";
        return cell;
    }else{
        NSString *personalCellThree = @"personalCellThree";
        SBPersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:personalCellThree forIndexPath:indexPath];
        if (!cell) {
            cell = [[SBPersonalSettingCell alloc] initWithStyle:0 reuseIdentifier:personalCellThree];
        }
        cell.nameLabel.text = [self.sectionTwo objectAtIndex:indexPath.row];
            //个性签名
        return cell;
    }
}




-(void)setupTopView{
    //添加topView
    ZZTMeEditTopView *topView = [ZZTMeEditTopView ZZTMeEditTopView];
    _topView = topView;
    //假如现在有数据  添加进去
    topView.backImage = self.backImg;
    topView.headImage = self.headImg;
    
    topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
    topView.buttonAction = ^(UIButton *sender) {
        [self clickBtn:sender];
    };
    [_scrollView addSubview:topView];
}

-(void)setupBottomView{
    //添加buttomView
    __block ZZTMeEditViewController *blockSelf = self;
    ZZTMeEditButtomView *meButtomView = [ZZTMeEditButtomView ZZTMeEditButtomView];
    _meButtomView = meButtomView;
    meButtomView.model = self.model;
    _meButtomView.TextChange = ^(UITextField *texyField) {
        [blockSelf textChange:texyField];
    };
    meButtomView.frame = CGRectMake(0, 300, SCREEN_WIDTH, 400);
    
    _meButtomView.BtnInside = ^(TypeButton *btn) {
        [blockSelf clickPickBtn:btn];
    };
    [_scrollView addSubview:_meButtomView];
}

//保存
-(void)save{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *imgDict = [self.imgeDict allKeys];
        for (int i = 0; i < imgDict.count; i++) {
            //文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = [formatter stringFromDate:[NSDate date]];
            NSString *imgName = [formatter stringFromDate:[NSDate date]];
            NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            NSMutableString *randomString = [NSMutableString stringWithCapacity:32];
            for (NSInteger i = 0; i < 32; i++) {
                [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)letters.length)]];
            }
            imgName = [NSString stringWithFormat:@"%@%@.png",imgName,randomString];
            //写入本地
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imgName];
            
            NSString *imgType = imgDict[i];
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
                
                [AFNHttpTool putImagePath:filePath key:imgName token:toke complete:^(id objc) {
                    NSLog(@"%@",objc); //  上传成功并获取七牛云的图片地址
                    //                self.headImg = objc;
                    [self.imgeDict setObject:objc forKey:imgType];
                    [self successUp];
                }];
                
            }else{
                NSLog(@"保存失败");
            }
        }
        if(imgDict.count == 0){
            [self successUp];
        }
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
    
    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"nickName":self.userName,
                          @"intro":self.signature,//空
                          @"sex":self.sex,
                          @"birthday":self.birthday,//空
                          @"headimg":self.headImg,//空
                          @"cover":self.backImg
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"login/upUser"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //保存本地
        //请求一次 拿到数据
        [self loadUserData];
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
        [self pickView4:btn];
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

#pragma mark - 相册代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%@",info);
    UIButton *button = (UIButton *)[self.view viewWithTag:_btnTag];
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //改变后的图片 记录 加了什么
    if(_btnTag == 1){
        _backImage = resultImage;
        [self.imgeDict setObject:resultImage forKey:@"backImg"];
    }else{
        _headImage = resultImage;
        [self.imgeDict setObject:resultImage forKey:@"headImg"];
    }
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
//    _picker.delegate = self;
    [self.navigationController presentViewController:_picker animated:YES completion:nil];
    
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
//    // imagePickerVc.navigationBar.translucent = NO;
//    
//    imagePickerVc.naviBgColor = [UIColor grayColor];
//    
//#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
//    imagePickerVc.isSelectOriginalPhoto = YES;
//    
//    
//    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
//    
//    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
//        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
//    }];
//    
//    //主题颜色
//    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
//    //显示照片不能选择图层
//    imagePickerVc.showPhotoCannotSelectLayer = YES;
//    //    无法选择图层颜色
//    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
//    //设置照片选择器页面UI配置块
//    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
//        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    }];
//    
//    // 3. 设置是否可以选择视频/图片/原图
//    imagePickerVc.allowPickingVideo = NO;
//    imagePickerVc.allowPickingImage = YES;
//    imagePickerVc.allowPickingOriginalPhoto = YES;
//    imagePickerVc.allowPickingGif = NO;
//    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
//    
//    // 4. 照片排列按修改时间升序
//    imagePickerVc.sortAscendingByModificationDate = YES;
//    
//    /// 5. 单选模式,maxImagesCount为1时才生效
//    imagePickerVc.showSelectBtn = NO;
//    imagePickerVc.allowCrop = NO;
//    imagePickerVc.needCircleCrop = NO;
//    // 设置竖屏下的裁剪尺寸
//    NSInteger left = 30;
//    NSInteger widthHeight = self.view.width - 2 * left;
//    NSInteger top = (self.view.height - widthHeight) / 2;
//    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
//    
//    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
//    
//    // 设置是否显示图片序号
//    imagePickerVc.showSelectedIndex = YES;
//    
//    // 你可以通过block或者代理，来得到用户选择的照片.
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        
//        UIButton *button = (UIButton *)[self.view viewWithTag:self.btnTag];
//        UIImage *resultImage = [photos objectAtIndex:0];
//        //改变后的图片 记录 加了什么
//        if(self.btnTag == 1){
//            self.backImage = resultImage;
//            [self.imgeDict setObject:resultImage forKey:@"backImg"];
//        }else{
//            self.headImage = resultImage;
//            [self.imgeDict setObject:resultImage forKey:@"headImg"];
//        }
//        button.imageView.image = resultImage;
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    }];
//    
//    [self presentViewController:imagePickerVc animated:YES completion:nil];

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

- (void)pickView4:(UIButton *)tf
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
        [tf setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tf setTitle:[NSString stringWithFormat:@"%@",resultString] forState:UIControlStateNormal];
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
    [self save];
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

@end
