//
//  settingHeaderViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "settingHeaderViewController.h"
#import "LoginViewController.h"

@interface settingHeaderViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView *bgView;
    UITextField *username;   //昵称
}

@property (nonatomic,strong) UIButton *head; //头像

@end

@implementation settingHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"注册3/3";
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    [self createUI];
    [self createTextFields];
}

-(void)createTextFields
{
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 270,frame.size.width, 50)];
    //bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    username=[self createTextFielfFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入昵称"];
    username.textAlignment=NSTextAlignmentCenter;
    username.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"完成" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(landClick)];
    landBtn.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    landBtn.layer.cornerRadius=5.0f;
    
    [bgView addSubview:username];
    
    [self.view addSubview:landBtn];
}

-(void)landClick
{
    /*
    //测试发送post请求
    NSURL *URL=[NSURL URLWithString:@"http://192.168.12.25:8080/default/org.gocom.components.coframe.auth.LoginManager.login.biz.ext?userId=sysadmin&password=000000"];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=2.0;   //设置请求超时为5秒
    request.HTTPMethod=@"POST";
    */
    [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
    
}

-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI
{
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    [bg setImage:[UIImage imageNamed:@"mycenter_bg.png"]];
    bg.backgroundColor=[UIColor grayColor];
    [self.view addSubview:bg];
    
    _head=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, 110, 80, 80)];
    [_head setImage:[UIImage imageNamed:@"head"] forState:UIControlStateNormal];
    _head.layer.cornerRadius=40;
    _head.layer.masksToBounds = YES;
    _head.backgroundColor=[UIColor whiteColor];
    [_head addTarget:self action:@selector(changeHeadView1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_head];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, 180, 80, 80)];
    label.text=@"点击设置头像";
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
}



-(void)changeHeadView1:(UIButton *)tap
{
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"更改图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册上传", nil];
    menu.delegate=self;
    menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
    
}

//*************************代理方法*******************************
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"index:%zd",buttonIndex);
    //0->拍照，1->相册
    
    if (buttonIndex == 0) {
        [self snapImage];
    } else if (buttonIndex == 1) {
        [self localPhoto];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //完成选择
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //NSLog(@"type:%@",type);
    if ([type isEqualToString:@"public.image"]) {
        //转换成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            //设置头像
            [_head setImage:image forState:UIControlStateNormal];
            //上传头像
            //[self updatePhotoFor:image];
        }];
        
    }
}


#pragma mark --头像上传
-(void)updatePhoto:(NSString *)base64Str
{
    //    NSString *url =[NSString stringWithFormat:@"%@%@",Host_DSXVipManager,@"/service/member"];
    //
    //    NSDictionary *dict = @{@"action":@"avatar",@"owner":@"guide",@"username":[UserModel getUserDefaultLoginName],@"password":[UserModel getUserDefaultPassword],@"filename":@"head.jpg",@"data":base64Str,@"operId":[UserModel getUserDefaultId],@"operType":@"guide"};
    //    [[NetRequestManager sharedInstance] sendRequest:[NSURL URLWithString:url] parameterDic:dict requestTag:0 delegate:self userInfo:nil];
}

//*****************************拍照**********************************
- (void) snapImage
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        __block UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        ipc.navigationBar.barTintColor =[UIColor whiteColor];
        ipc.navigationBar.tintColor = [UIColor whiteColor];
     //   ipc.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor]};
        ipc.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self presentViewController:ipc animated:YES completion:^{
            ipc = nil;
        }];
    } else {
        NSLog(@"模拟器无法打开照相机");
    }
}

#define CommonThimeColor HEXCOLOR(0x11a0ee)
-(void)localPhoto
{
    __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    picker.navigationBar.barTintColor =[UIColor whiteColor];
    picker.navigationBar.tintColor = [UIColor blackColor];
 //   picker.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor blackColor]};
    picker.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor]};
    [self presentViewController:picker animated:YES completion:^{
        picker = nil;
    }];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
