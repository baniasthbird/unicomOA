//
//  NewsDisplayViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/3/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsDisplayViewController.h"
#import "CommentViewController.h"

@interface NewsDisplayViewController ()



@end

@implementation NewsDisplayViewController


@synthesize delegate;

int i_num;

int i_comment_num;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"公告详情";
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    //[barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    
    if (iPhone6 || iPhone6_plus) {
        _lbl_label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, 5, 15*self.view.frame.size.width/16, self.view.frame.size.height*0.08)];
    }
    else if (iPhone4_4s || iPhone5_5s) {
         _lbl_label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, 5, 15*self.view.frame.size.width/16, self.view.frame.size.height*0.14)];
    }
    _lbl_label.numberOfLines=0;
    _lbl_label.textAlignment=NSTextAlignmentCenter;
    [_lbl_label setLineBreakMode:NSLineBreakByWordWrapping];
    _lbl_label.font=[UIFont systemFontOfSize:20];
    _lbl_label.textColor=[UIColor blackColor];
    _lbl_label.text=_str_label;
    
    if (iPhone6 || iPhone6_plus) {
         _lbl_depart=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.07, 15*self.view.frame.size.width/16, self.view.frame.size.height*0.08)];
    }
    else if (iPhone5_5s || iPhone4_4s) {
        _lbl_depart=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.14, 15*self.view.frame.size.width/16, self.view.frame.size.height*0.08)];
    }
   
    _lbl_depart.numberOfLines=1;
    [_lbl_depart setLineBreakMode:NSLineBreakByWordWrapping];
    _lbl_depart.textColor=[UIColor lightGrayColor];
    _lbl_depart.font=[UIFont systemFontOfSize:14];
    if (iPhone6 || iPhone6_plus) {
        _lbl_depart.text=@"           综合管理部                        张三   2016-01-26 ";
    }
    else if (iPhone5_5s || iPhone4_4s) {
        _lbl_depart.text=@"     综合管理部          张三   2016-01-26 ";
    }
    
    
    if (iPhone6 || iPhone6_plus) {
       _txt_content=[[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.13, 15*self.view.frame.size.width/16, self.view.frame.size.height*0.60)];
    }
    else if (iPhone4_4s || iPhone5_5s) {
         _txt_content=[[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.20, 15*self.view.frame.size.width/16, self.view.frame.size.height*0.51)];
    }
    
    //[_lbl_content setLineBreakMode:NSLineBreakByWordWrapping];
    
    _txt_content.font=[UIFont systemFontOfSize:14];
    _txt_content.textColor=[UIColor blackColor];
    _txt_content.text=@"国务院有关部门、直属机构，各省、自治区、直辖市发展改革委、物价局：\n        为贯彻落实党的十八届三中全会精神和国务院关于进一步简政放权、推进职能转变的要求，根据当前市场竞争情况，经商住房和城乡建设部同意，决定放开部分建设项目服务收费标准。现就有关事项通知如下：\n        放开除政府投资项目及政府委托服务以外的建设项目前期工作咨询、工程勘察设计、招标代理、工程监理等4项服务收费标准，实行市场调节价。采用直接投资和资本金注入的政府投资项目，以及政府委托的上述服务收费，继续实行政府指导价管理，执行规定的收费标准；实行市场调节价的专业服务收费，由委托双方依据服务成本、服务质量和市场供求状况等协商确定。\n        各级价格主管部门要强化市场价格监测，加强市场价格行为监管和反价格垄断执法，依法查处各类价格违法行为，维护正常的市场秩序，保障市场主体合法权益。\n        在放开收费标准过程中遇到的问题和建议，请及时报告我委（价格司）。\n        上述规定自2014年8月1日起执行。此前有关规定与本通知不符的，按本通知规定执行。\n                   国家发展改革委                2014年7月10日";
    _txt_content.scrollEnabled=YES;
    _txt_content.editable=NO;
    [self.view addSubview:_lbl_depart];
    [self.view addSubview:_lbl_label];
    [self.view addSubview:_txt_content];
    
   // self.delegate=self;
    
    i_num=0;
    i_comment_num=5;
    
    UILabel *lbl_line;
    
    
    
    
    
#pragma mark 最底下为三个button
    
    UIButton *btn_read;
    UIButton *btn_focus;
    UIButton *btn_comment;
    
    CGFloat i_Height;
    if (iPhone6 || iPhone6_plus) {
        i_Height=self.view.frame.size.height*0.75;
    }
    else {
        i_Height=self.view.frame.size.height*0.72;
    }
    
    lbl_line=[[UILabel alloc]initWithFrame:CGRectMake(0, i_Height,self.view.frame.size.width, 1)];
    lbl_line.backgroundColor=[UIColor lightGrayColor];
    
    
    [self.view addSubview:lbl_line];
    btn_read=[self createButton:0 y:i_Height w:self.view.frame.size.width*0.329 h:self.view.frame.size.height*0.08 title:@"阅读" image:@"read"];
    [btn_read addTarget:self action:@selector(ReadNum:) forControlEvents:UIControlEventTouchUpInside];
    
    btn_focus=[self createButton:self.view.frame.size.width*0.33 y:i_Height w:self.view.frame.size.width*0.329 h:self.view.frame.size.height*0.08 title:@"关注" image:@"focus"];
    [btn_focus addTarget:self action:@selector(FocusEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    btn_comment=[self createButton:self.view.frame.size.width*0.66 y:i_Height w:self.view.frame.size.width*0.34 h:self.view.frame.size.height*0.08 title:@"评论" image:@"comment"];
    [btn_comment addTarget:self action:@selector(CommentEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn_comment];
    [self.view addSubview:btn_focus];
    [self.view addSubview:btn_read];
    
    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ReadNum:(UIButton*)btn {
    i_num= i_num+1;
    NSString *str_num=[NSString stringWithFormat:@"%d",i_num];
    NSString *str_titile=[NSString stringWithFormat:@"%@%@%@",@"阅读（",str_num,@")"];
    [btn setTitle:str_titile forState:UIControlStateNormal];
}

-(void)FocusEvent:(UIButton*)btn {
    if ([btn.titleLabel.text isEqualToString:@"关注"]) {
        [btn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.delegate passFocusValue:@"AAA"];
    }
    else if ([btn.titleLabel.text isEqualToString:@"已关注"]) {
        [btn setTitle:@"关注" forState:UIControlStateNormal];
    }
}

-(void)CommentEvent:(UIButton*)btn {
    CommentViewController *viewController=[[CommentViewController alloc]init];
    viewController.userInfo=_userInfo;
   // viewController.str=[NSString stringWithFormat:@"%d",i_comment_num];
    [self.navigationController pushViewController:viewController animated:YES];
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(UIButton*)createButton:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h title:(NSString*)str_title image:(NSString*)str_imgname {
    UIButton *btn_tmp=[[UIButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
    [btn_tmp setTitle:str_title forState:UIControlStateNormal];
    [btn_tmp setTitleColor:[UIColor colorWithRed:25/255.0f green:186/255.0f blue:142/255.0f alpha:1] forState:UIControlStateNormal];
    [btn_tmp.layer setBorderWidth:1.0];
    btn_tmp.layer.borderColor=[[UIColor colorWithRed:185/255.0f green:180/255.0f blue:181/255.0f alpha:1] CGColor];
    [btn_tmp setImage:[UIImage imageNamed:str_imgname] forState:UIControlStateNormal];
    [btn_tmp setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    btn_tmp.titleLabel.font=[UIFont systemFontOfSize:22];
    btn_tmp.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    return btn_tmp;
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
