//
//  ChangePhoneNumStep3.m
//  unicomOA
//
//  Created by zr-mac on 16/3/23.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ChangePhoneNumStep3.h"
#import "StaffInfoViewController.h"

@interface ChangePhoneNumStep3 ()

@property (nonatomic,strong) UIButton *btn_send;

@end

@implementation ChangePhoneNumStep3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"更换手机账号";
    
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;

    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:243/255.0f];
    
    UIButton *btn_next=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [btn_next setTitle:@"完成" forState:UIControlStateNormal];
    [btn_next addTarget:self action:@selector(MoveNextVc:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn_next];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UILabel *lbl_text=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.08, self.view.frame.size.width*0.8, self.view.frame.size.height*0.1)];
    //lbl_text.textColor=[UIColor colorWithRed:151/255.0f green:151/255.0f blue:151/255.0f alpha:1];
    lbl_text.textColor=[UIColor colorWithRed:151/255.0f green:151/255.0f blue:151/255.0f alpha:1];
    lbl_text.text=[NSString stringWithFormat:@"%@%@",@"验证码短信已发送至",_str_phonenum];
    
    UITextField *txt_Certificate=[[UITextField alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.16, self.view.frame.size.width, self.view.frame.size.height*0.06)];
    txt_Certificate.backgroundColor=[UIColor whiteColor];
    txt_Certificate.placeholder=@"请输入短信验证码";
    txt_Certificate.keyboardType=UIKeyboardTypeNumberPad;
    
    _btn_send=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.26, self.view.frame.size.width*0.28, self.view.frame.size.height*0.04)];
    _btn_send.backgroundColor=[UIColor colorWithRed:22/255.0f green:155/255.0f blue:213/255.0f alpha:1];
    [_btn_send setTitle:@"重新获取短信" forState:UIControlStateNormal];
    _btn_send.titleLabel.font=[UIFont systemFontOfSize:14];
    [_btn_send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn_send addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:lbl_text];
    [self.view addSubview:txt_Certificate];
    [self.view addSubview:_btn_send];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MoveNextVc:(UIButton*)sender {
    StaffInfoViewController *viewController=[[StaffInfoViewController alloc]init];
    if (_str_phonenum!=nil) {
         viewController.str_cellphone=_str_phonenum;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startTime {
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_btn_send setTitle:@"发送验证码" forState:UIControlStateNormal];
                _btn_send.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_btn_send setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _btn_send.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
