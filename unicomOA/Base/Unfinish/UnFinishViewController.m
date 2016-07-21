//
//  UnFinishViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/7/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "UnFinishViewController.h"
#import "LXAlertView.h"

@interface UnFinishViewController ()

@end

@implementation UnFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_str_title;
    
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_back setTitle:@"  " forState:UIControlStateNormal];
    [btn_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_back setTintColor:[UIColor whiteColor]];
    [btn_back setImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(BackToAppCenter:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_back];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imgView.image=[UIImage imageNamed:@"unfinish"];
    
    [self.view addSubview:imgView];
    
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"该功能正在审核中\n敬请期待" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    [alert showLXAlertView];
    
    
    
   // self.view.backgroundColor=[UIColor colorWithRed:154/255.0f green:154/255.0f blue:154/255.0f alpha:0.9];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BackToAppCenter:(UIButton*)Btn {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buildView:(NSString*)str_title {
    
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
