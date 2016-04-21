//
//  settingPasswordViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "settingPasswordViewController.h"
#import "settingHeaderViewController.h"
#import "LoginViewController.h"

@interface settingPasswordViewController ()
{
    
    BOOL b_isSecure;

}

@property (nonatomic,strong) UITextField *txt_Pwd;

@property (nonatomic,strong) UITextField *txt_Pwd2;

@end

@implementation settingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"找回密码";
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItemNx = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(MoveNextVc:)];
    [barButtonItemNx setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barButtonItemNx;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    if (iPhone6_plus || iPhone6) {
        _txt_Pwd=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.06, self.view.frame.size.width*0.9, 50) placeholder:@"     请输入新密码" security:YES];
        
        
        _txt_Pwd2=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.20, self.view.frame.size.width*0.9, 50) placeholder:@"     再次输入密码" security:YES];
    }
    else {
        
        _txt_Pwd=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.06, self.view.frame.size.width*0.9, 50) placeholder:@"     请输入新密码" security:YES];
        
        
        _txt_Pwd2=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.25, self.view.frame.size.width*0.9, 50) placeholder:@"     再次输入密码" security:YES];
        
    }
    

    b_isSecure=YES;
    
    //UISwitch *sw_pwd=[[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.3, self.view.frame.size.height*0., self.view.frame.size.height*0.08, self.view.frame.size.height*0.08)];
    
    UIButton *checkbox=[[UIButton alloc]initWithFrame:CGRectZero];
    
    if (iPhone6_plus) {
        checkbox.frame=CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.14, 30, 30);
    }
    else if (iPhone6) {
        checkbox.frame=CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.145, 30, 30);
    }
    else {
        checkbox.frame=CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.18, 30, 30);
    }
    
    
    [checkbox setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    
    [checkbox setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
    
    
    [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [checkbox setSelected:YES];
    
    UILabel *lbl_Pwd;
    if (iPhone6) {
       lbl_Pwd =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.18, self.view.frame.size.height*0.125, self.view.frame.size.width*0.5, self.view.frame.size.height*0.08)];
    }
    else if (iPhone6_plus) {
         lbl_Pwd =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.18, self.view.frame.size.height*0.12, self.view.frame.size.width*0.5, self.view.frame.size.height*0.08)];
    }
    else {
        lbl_Pwd =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.18, self.view.frame.size.height*0.16, self.view.frame.size.width*0.5, self.view.frame.size.height*0.08)];
    }
    
    
    lbl_Pwd.text=@"显示密码";
    lbl_Pwd.font=[UIFont systemFontOfSize:20];
    
    lbl_Pwd.textColor=[UIColor blackColor];
    
    [self.view addSubview:_txt_Pwd];
    [self.view addSubview:lbl_Pwd];
    //[self.view addSubview:sw_pwd];
    [self.view addSubview:_txt_Pwd2];
    [self.view addSubview:checkbox];
    
    /*
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    [self createTextFields];
     */
}


-(void)MovePreviousVc:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)MoveNextVc:(UIButton*)sender {
    LoginViewController *vc=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITextField*)CreateTextFiled:(CGRect)rect placeholder:(NSString*)str_placeholder security:(BOOL)b_secure {
    UITextField *txt_tmp=[[UITextField alloc]initWithFrame:rect];
    
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc]initWithString:str_placeholder];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1] range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, attributedStr.length)];
    
    txt_tmp.attributedPlaceholder=attributedStr;
    
    txt_tmp.backgroundColor=[UIColor whiteColor];
    txt_tmp.keyboardType=UIKeyboardTypeDefault;
    txt_tmp.layer.cornerRadius=25.0f;
    [txt_tmp.layer setMasksToBounds:YES];
    
    txt_tmp.secureTextEntry=b_secure;
    
    return txt_tmp;
}

-(void)checkboxClick:(UIButton*)btn {
    btn.selected=!btn.selected; //每次点击都改变按钮状态
    
    if (btn.selected) {
        b_isSecure=YES;
        _txt_Pwd.secureTextEntry=YES;
        _txt_Pwd2.secureTextEntry=YES;
    }
    else {
        b_isSecure=NO;
        _txt_Pwd.secureTextEntry=NO;
        _txt_Pwd.secureTextEntry=NO;
    }
    
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
