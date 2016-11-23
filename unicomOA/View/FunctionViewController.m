//
//  FunctionViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "FunctionViewController.h"
#import "UITableGridViewCell.h"
#import "UIImageButton.h"
#import "NotesViewController.h"
#import "NewsManagementViewController.h"
#import "IVotingManamentController.h"
#import "UIView+Frame.h"
#import "WZLBadgeImport.h"
#import "MyShenPiViewController.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "UITabBar+badge.h"
#import "MessageViewController.h"
#import "UnFinishViewController.h"
#import "SysMsgViewController.h"
#import "XSpotLight.h"
#import "WeatherViewController.h"
#import "WBGuide/RAYNewFunctionGuideVC.h"



#define kImageWidth 100      //UITAbleViewCell里面图片的宽度
#define kImageHeight 100     //UITableViewCell里面图片的高度

@interface FunctionViewController ()<MyShenPiViewControllerDelegate,XSpotLightDelegate>

//@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIImage *image;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) UIImageButton *btn_ShenPi;

@property (nonatomic,strong) UIImageButton *btn_BanGong;

@property (nonatomic,strong) UIImageButton *btn_ShouQian;

@property (nonatomic,strong) UIImageButton *btn_ShengChan;

@property (nonatomic,strong) UIImageButton *btn_HeTong;

@property (nonatomic,strong) UIImageButton *btn_ShiWu;

@property (nonatomic,strong) UIImageButton *btn_more;

@end

@implementation FunctionViewController {
    DataBase *db;
    UIActivityIndicatorView *indicator;
    NSInteger i_total;
    NSInteger i_bangong;
    NSInteger i_shiwu;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDictionary * dict;
        if (iPad) {
            dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
        }
        else {
            dict =@{
                    NSForegroundColorAttributeName:   [UIColor whiteColor]};
        }
        self.title=@"应用";
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor=[UIColor yellowColor];
    self.title=@"应用";
    self.view.backgroundColor=[UIColor whiteColor];
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }
 
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    
    CGSize mSize=[[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth=mSize.width;
    //CGFloat screenHeiht=mSize.height;
    
    [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
    
    indicator=[self AddLoop];

    i_total=0;
    CGFloat i_Height=-1;
    if (iPhone4_4s || iPhone5_5s) {
        i_Height=68;
    }
    else if (iPhone6) {
        i_Height=79;
    }
    else if (iPhone6_plus) {
        i_Height=87;
    }
    else if (iPad) {
        i_Height=211;
    }
    UIImageView *img_View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, i_Height)];
    if (iPad) {
        img_View.image=[UIImage imageNamed:@"bg_Nav-IPad.png"];
    }
    else {
        img_View.image=[UIImage imageNamed:@"bg_Nav.png"];
    }
    
    CGFloat i_title1_x=10;
    CGFloat i_title1_y=8;
    CGFloat i_title_w=[UIScreen mainScreen].bounds.size.width-10;
    CGFloat i_title_h=15;
    CGFloat i_title_font=14;
    
    CGFloat view_part_x=0;
    CGFloat view_part1_y=30;
    CGFloat view_part_w=[UIScreen mainScreen].bounds.size.width;
    CGFloat view_part_h=88;

    
    CGFloat btn_x=18;
    CGFloat btn_y=13;
    CGFloat btn_w=50;
    
    CGFloat btn_x_2=96;
    CGFloat btn_x_3=174;
    CGFloat btn_x_4=252;
    
    
    CGFloat i_title2_x=10;
    CGFloat i_title2_y=156;
    CGFloat i_viewpart2_y=178;
    CGFloat shenpi_y=i_viewpart2_y+12;
    
    CGFloat shenpi_y_2=242;
    
    CGFloat i_title3_x=10;
    CGFloat i_title3_y=299;
    
   
    CGFloat i_viewpart3_y=321;
    
    CGFloat i_insets=70;
    
    if (iPhone5_5s) {
        i_title2_y=130;
        i_viewpart2_y=152;
        shenpi_y=i_viewpart2_y+9;
        i_title3_y=249;
        i_viewpart3_y=271;
    }
    else if (iPhone6) {
        btn_x=28;
        btn_x_2=116;
        btn_x_3=204;
        btn_x_4=292;
     //   i_title2_y=205;
     //   i_viewpart2_y=227;
     //   shenpi_y=237;
    //    i_title3_y=361;
    //    i_viewpart3_y=383;
        view_part_h=106;
        btn_w=60;
        i_insets=80;
        shenpi_y_2=295;
    }
    else if (iPhone6_plus) {
        btn_x=25;
        btn_x_2=125;
        btn_x_3=225;
        btn_x_4=325;
      //  i_title3_y=396;
      //  i_viewpart3_y=418;
        view_part_h=110;
        btn_w=65;
        i_insets=90;
        i_title_font=16;
        shenpi_y_2=312;

    }
    else if (iPad) {
      //  i_title1_y=60;
      //  view_part1_y=95;
      //  i_title2_y=250;
      //  i_viewpart2_y=282;
        shenpi_y=292;
        i_title3_y=578;
        i_viewpart3_y=609;
        view_part_h=140;
        btn_w=100;
        i_insets=130;
        i_title_font=18;
        shenpi_y_2=392;

    }
    
    //zr 0906 更新用户引导页面
    RAYNewFunctionGuideVC *ray_vc=[[RAYNewFunctionGuideVC alloc]init];
    ray_vc.titles=@[@"新增:天气预报"];
    if (iPhone5_5s) {
        ray_vc.frames=@[@"{{165,380},{70,70}}"];
    }
    else if (iPhone6) {
        ray_vc.frames=@[@"{{197,445},{80,80}}"];
    }
    else if (iPhone6_plus) {
        ray_vc.frames=@[@"{{216,480},{85,85}}"];
    }
    
   if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
    
     //  [self presentViewController:ray_vc animated:NO completion:^{
           
     //  }];
    
    }
    
    XSpotLight *SpotLight=[[XSpotLight alloc]init];
    SpotLight.messageArray=@[@"调整应用布局"];
    CGFloat i_x=323;
    CGFloat i_y=535;
    if (iPhone5_5s) {
        i_x=277;
        i_y=450;
    }
    else if (iPhone6_plus) {
        i_x=358;
        i_y=585;
    }
   // SpotLight.rectArray=@[[NSValue valueWithCGRect:CGRectMake(i_x, i_y, 50, 500)]];
    SpotLight.rectArray=@[[NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)]];
    SpotLight.delegate=self;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        /*
        [self presentViewController:SpotLight animated:NO completion:^{
            
        }];
         */
    }

    
    UILabel *lbl_title1=[[UILabel alloc]initWithFrame:CGRectMake(i_title1_x, i_title1_y, i_title_w, i_title_h)];
    lbl_title1.textAlignment=NSTextAlignmentLeft;
    lbl_title1.text=@"快捷办公";
    lbl_title1.textColor=[UIColor blackColor];
    lbl_title1.font=[UIFont systemFontOfSize:i_title_font];
    
    UIView *view_part1=[[UIView alloc]initWithFrame:CGRectMake(view_part_x, view_part1_y, view_part_w, view_part_h)];
    view_part1.backgroundColor=[UIColor whiteColor];
    view_part1.layer.borderWidth=1;
    view_part1.layer.borderColor=[[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1] CGColor];
    
    UIImageButton *btn_News=[self createImageButton:btn_x y:btn_y width:btn_w height:btn_w title:@"新闻" image:@"News.png" insets:i_insets isFinish:YES];
    [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageButton *btn_GongGao=[self createImageButton:btn_x_2 y:btn_y width:btn_w height:btn_w title:@"公告" image:@"GongGao.png" insets:i_insets isFinish:YES];
    [btn_GongGao addTarget:self action:@selector(GongGaoClick:) forControlEvents:UIControlEventTouchUpInside];

    UIImageButton *btn_XiaoXi=[self createImageButton:btn_x_3 y:btn_y width:btn_w height:btn_w title:@"消息" image:@"Message.png" insets:i_insets isFinish:YES];
    [btn_XiaoXi addTarget:self action:@selector(XiaoXiClick:) forControlEvents:UIControlEventTouchUpInside];

    UIImageButton *btn_ChuanYue=[self createImageButton:btn_x_4 y:btn_y width:btn_w height:btn_w title:@"传阅" image:@"ChuanYue.png" insets:i_insets isFinish:NO];
    [btn_ChuanYue addTarget:self action:@selector(ChuanYueClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    UILabel *lbl_title2=[[UILabel alloc]initWithFrame:CGRectMake(i_title2_x, i_title2_y, i_title_w, i_title_h)];
    lbl_title2.textAlignment=NSTextAlignmentLeft;
    lbl_title2.text=@"常用审批";
    lbl_title2.textColor=[UIColor blackColor];
    lbl_title2.font=[UIFont systemFontOfSize:i_title_font];
    
    UIView *view_part2=[[UIView alloc]initWithFrame:CGRectMake(view_part_x, i_viewpart2_y, view_part_w, view_part_h)];
    view_part2.backgroundColor=[UIColor whiteColor];
    view_part2.layer.borderWidth=1;
    view_part2.layer.borderColor=[[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1] CGColor];
    
    _btn_ShenPi=[self createImageButton:btn_x y:shenpi_y width:btn_w height:btn_w title:@"审批" image:@"ShenPi.png" insets:i_insets isFinish:YES];
    [_btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
    if (i_total!=0) {
        _btn_ShenPi.badgeBgColor=[UIColor redColor];
       // _btn_ShenPi.badgeCenterOffset=CGPointMake(0, _btn_ShenPi.size.height*0.08);
        [_btn_ShenPi showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone x:0 y:0];
        if (iPad) {
            [_btn_ShenPi setBadgeFrame:CGRectMake(_btn_ShenPi.badge.frame.origin.x, _btn_ShenPi.badge.frame.origin.y, 35, 35)];
            _btn_ShenPi.badge.layer.cornerRadius=17.5;
            _btn_ShenPi.badge.font=[UIFont systemFontOfSize:18];
            // btn_ShenPi.badge.layer.cornerRadius=btn_ShenPi.badge.frame.size.height*2;
        }
    }
    
    _btn_BanGong=[self createImageButton:btn_x_2 y:shenpi_y width:btn_w height:btn_w title:@"办公" image:@"BanGong.png" insets:i_insets isFinish:YES];
    [_btn_BanGong addTarget:self action:@selector(BanGongItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn_ShouQian=[self createImageButton:btn_x_3 y:shenpi_y width:btn_w height:btn_w title:@"售前" image:@"ShouQian.png" insets:i_insets isFinish:NO];
    [_btn_ShouQian addTarget:self action:@selector(ShouQianItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn_ShengChan=[self createImageButton:btn_x_4 y:shenpi_y width:btn_w height:btn_w title:@"生产" image:@"ShengChan.png" insets:i_insets isFinish:NO];
    [_btn_ShengChan addTarget:self action:@selector(ShengChanItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn_HeTong=[self createImageButton:btn_x y:shenpi_y_2 width:btn_w height:btn_w title:@"合同" image:@"HeTong.png" insets:i_insets isFinish:NO];
    [_btn_HeTong addTarget:self action:@selector(HeTongItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
   // _btn_ShiWu=[self createImageButton:btn_x_2 y:shenpi_y_2 width:btn_w height:btn_w title:@"事务" image:@"ShiWu.png" insets:i_insets isFinish:YES];
     _btn_ShiWu=[self createImageButton:btn_x_3 y:shenpi_y width:btn_w height:btn_w title:@"事务" image:@"ShiWu.png" insets:i_insets isFinish:YES];
    [_btn_ShiWu addTarget:self action:@selector(ShiWuItemClick:) forControlEvents:UIControlEventTouchUpInside];

    _btn_more= [self createImageButton:btn_x_4 y:shenpi_y width:btn_w height:btn_w title:@"更多" image:@"More.png" insets:i_insets isFinish:YES];
    [_btn_more addTarget:self action:@selector(ShengChanItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbl_title3=[[UILabel alloc]initWithFrame:CGRectMake(i_title3_x, i_title3_y, i_title_w, i_title_h)];
    lbl_title3.textAlignment=NSTextAlignmentLeft;
    lbl_title3.text=@"应用中心";
    lbl_title3.textColor=[UIColor blackColor];
    lbl_title3.font=[UIFont systemFontOfSize:i_title_font];
    
    UIView *view_part3=[[UIView alloc]initWithFrame:CGRectMake(view_part_x, i_viewpart3_y, view_part_w, view_part_h)];
    view_part3.backgroundColor=[UIColor whiteColor];
    view_part3.layer.borderWidth=1;
    view_part3.layer.borderColor=[[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1] CGColor];
    
    UIImageButton *btn_Notes=[self createImageButton:btn_x y:btn_y width:btn_w height:btn_w title:@"备忘录" image:@"Notes.png" insets:i_insets isFinish:YES];
    [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];

    UIImageButton *btn_IVoting=[self createImageButton:btn_x_2 y:btn_y width:btn_w height:btn_w title:@"投票" image:@"IVoting.png" insets:i_insets isFinish:YES];
    [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageButton *btn_JueCe=[self createImageButton:btn_x_3 y:btn_y width:btn_w height:btn_w title:@"决策" image:@"JueCe.png" insets:i_insets isFinish:NO];
    [btn_JueCe addTarget:self action:@selector(JueCeItemClick:) forControlEvents:UIControlEventTouchUpInside];

    UIImageButton *btn_Weather=[self createImageButton:btn_x_3 y:btn_y width:btn_w height:btn_w title:@"天气" image:@"Weather.png" insets:i_insets isFinish:YES];
    [btn_Weather addTarget:self action:@selector(WeatherItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:lbl_title1];
    [self.view addSubview:lbl_title2];
    [self.view addSubview:lbl_title3];
    [view_part1 addSubview:btn_News];
    [view_part1 addSubview:btn_GongGao];
    [view_part1 addSubview:btn_XiaoXi];
   // [view_part1 addSubview:btn_ChuanYue];
    [self.view addSubview:_btn_ShenPi];
    [self.view addSubview:_btn_BanGong];
  //  [self.view addSubview:_btn_ShouQian];
   // [self.view addSubview:_btn_ShengChan];
   // [self.view addSubview:_btn_HeTong];
    [self.view addSubview:_btn_ShiWu];
    [self.view addSubview:_btn_more];
    [view_part3 addSubview:btn_Notes];
    [view_part3 addSubview:btn_IVoting];
   // [view_part3 addSubview:btn_JueCe];
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    if ([currentNetWorkState isEqualToString:@"wifi"] && f_v>=10.0) {
        [view_part3 addSubview:btn_Weather];
    }
    [self.view addSubview:view_part1];
    [self.view addSubview:view_part2];
    [self.view sendSubviewToBack:view_part2];
    [self.view addSubview:view_part3];
    
    /*
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeiht) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    */
   // [self.view addSubview:img_View];
    
    self.view.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
   // NSMutableDictionary *dic_param1=[NSMutableDictionary dictionary];
   // dic_param1[@"pageIndex"]=_str_page;
    [self PrePareData:nil interface:@"TaskCountUnfinish"];

    [self.view addSubview:indicator];
    [indicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITable datasource and delegate
/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else if (section==1) {
        return 2;
    }
    else {
        return 2;
    }
}
*/

-(UIImageButton *)createImageButton:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height title:(NSString*)str_title image:(NSString *)str_image insets:(CGFloat)insets isFinish:(BOOL)b_Finish{
    UIImageButton *tmp_btn=[UIImageButton buttonWithType:UIButtonTypeCustom];
    [tmp_btn setFrame:CGRectMake(x, y, width, height)];
    
    
    [tmp_btn setValue:[NSNumber numberWithInt:0] forKey:@"column"];
    
    [tmp_btn setTitle:str_title forState:UIControlStateNormal];
   
    tmp_btn.titleEdgeInsets=UIEdgeInsetsMake(insets, 0, 0, 0);
    
    
    
    [tmp_btn setBackgroundImage:[UIImage imageNamed:str_image] forState:UIControlStateNormal];
    
     //tmp_btn.titleLabel.textColor=[UIColor blackColor];
    if (b_Finish==YES) {
        [tmp_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else {
        [tmp_btn setTitleColor:[UIColor colorWithRed:154/255.0f green:154/255.0f blue:154/255.0f alpha:1] forState:UIControlStateNormal];
    }
    
    
    tmp_btn.titleLabel.font=[UIFont systemFontOfSize:14];
    
    return tmp_btn;

}

/*
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"Cell";
    //自定义UITableGridViewCell
    UITableGridViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    //if (cell==nil) {
        cell=[[UITableGridViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectedBackgroundView=[[UIView alloc]init];
        NSMutableArray *array=[NSMutableArray array];
        
#pragma mark 添加通知公告图标
        UIImageButton *btn_News;
        UIImageButton *btn_ShenPi;
        UIImageButton *btn_IVoting;
        UIImageButton *btn_Notes;
    
    
        if (iPhone6) {
            btn_News=[self createImageButton:60 CenterY:70 title:@"公告" image:@"News.png"];
            [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_ShenPi=[self createImageButton:185 CenterY:70 title:@"审批" image:@"ShenPi.png"];
            [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_IVoting=[self createImageButton:315 CenterY:70 title:@"投票" image:@"IVoting.png"];
            [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_Notes=[self createImageButton:60 CenterY:70 title:@"备忘录" image:@"Notes.png"];
            [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        else if (iPhone5_5s || iPhone4_4s) {
            btn_News=[self createImageButton:55 CenterY:55 title:@"公告" image:@"News.png"];
            [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_ShenPi=[self createImageButton:165 CenterY:55 title:@"审批" image:@"ShenPi.png"];
            [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_IVoting=[self createImageButton:270 CenterY:55 title:@"投票" image:@"IVoting.png"];
            [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_Notes=[self createImageButton:55 CenterY:55 title:@"备忘录" image:@"Notes.png"];
            [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
        

        }
        else if (iPhone6_plus)
        {
                btn_News=[self createImageButton:70 CenterY:75 title:@"公告" image:@"News.png"];
                [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_ShenPi=[self createImageButton:200 CenterY:75 title:@"审批" image:@"ShenPi.png"];
               [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_IVoting=[self createImageButton:340 CenterY:75 title:@"投票" image:@"IVoting.png"];
               [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_Notes=[self createImageButton:70 CenterY:75 title:@"备忘录" image:@"Notes.png"];
               [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
                  }
        else if (iPad) {
            btn_News=[self createImageButton:122 CenterY:102 title:@"公告" image:@"News.png"];
            [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
         
            btn_ShenPi=[self createImageButton:378 CenterY:102 title:@"审批" image:@"ShenPi.png"];
            [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
          
            btn_IVoting=[self createImageButton:634 CenterY:102 title:@"投票" image:@"IVoting.png"];
           // [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_Notes=[self createImageButton:122 CenterY:102 title:@"备忘录" image:@"Notes.png"];
            [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
        }
       // btn_News.badgeBgColor=[UIColor redColor];
       // btn_News.badgeCenterOffset=CGPointMake(0, btn_News.size.height*0.08);
        //[btn_News showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeNone];
        
        if (i_total!=0) {
            btn_ShenPi.badgeBgColor=[UIColor redColor];
            btn_ShenPi.badgeCenterOffset=CGPointMake(0, btn_ShenPi.size.height*0.08);
            [btn_ShenPi showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone];
            if (iPad) {
                [btn_ShenPi setBadgeFrame:CGRectMake(btn_ShenPi.badge.frame.origin.x, btn_ShenPi.badge.frame.origin.y, 35, 35)];
                btn_ShenPi.badge.layer.cornerRadius=17.5;
                btn_ShenPi.badge.font=[UIFont systemFontOfSize:18];
               // btn_ShenPi.badge.layer.cornerRadius=btn_ShenPi.badge.frame.size.height*2;
            }

        }
       
    
 
    
    
        if (indexPath.row==0) {
            [cell addSubview:btn_News];
            [cell addSubview:btn_ShenPi];
            [cell addSubview:btn_IVoting];
      
            cell.backgroundColor=[UIColor colorWithRed:244/255.0f green:245/255.0f blue:249/255.0f alpha:1];
            [array addObject:btn_News];
            [array addObject:btn_ShenPi];
            [array addObject:btn_IVoting];
        }
        else if (indexPath.row==1) {
            [cell addSubview:btn_Notes];
            [array addObject:btn_Notes];
            cell.backgroundColor=[UIColor colorWithRed:244/255.0f green:245/255.0f blue:249/255.0f alpha:1];
        }

        
        [cell setValue:array forKey:@"buttons"];
  //  }
        NSArray *imageButtons=cell.buttons;
        
        [imageButtons setValue:[NSNumber numberWithInt:(int)indexPath.row] forKey:@"row"];
        
        return cell;
}
*/

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iPad) {
        return 270;
    }
    else if (iPhone6_plus) {
        return 150;
    }
    else if (iPhone5_5s) {
        return 140;
    }
    else {
        return kImageHeight+30;
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //不让tableViewcellY有选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
*/
-(void)NewsItemClick:(UIImageButton *)button {
#pragma mark 控制红点通知
    
    NewsManagementViewController *newsView=[[NewsManagementViewController alloc]init];
    //newsView.delegate=self;
    newsView.b_isNews=YES;
    newsView.str_title=@"新闻";
    newsView.userInfo=_userInfo;
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:newsView animated:NO];
}

//公告
-(void)GongGaoClick:(UIImageButton *)button {
    NewsManagementViewController *newsView=[[NewsManagementViewController alloc]init];
    //newsView.delegate=self;
    newsView.b_isNews=NO;
    newsView.str_title=@"公告";
    newsView.userInfo=_userInfo;
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:newsView animated:NO];
}

//消息
-(void)XiaoXiClick:(UIImageButton *)button {
    /*
    UnFinishViewController *view=[[UnFinishViewController alloc]init];
    view.str_title=@"系统消息";
    [self.navigationController pushViewController:view animated:YES];
     */
    SysMsgViewController *vc=[[SysMsgViewController alloc]init];
    vc.b_isSysMsg=YES;
    vc.str_title=@"系统消息";
    vc.userInfo=_userInfo;
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:vc animated:NO];
    
}

//传阅
-(void)ChuanYueClick:(UIImageButton *)button {
    UnFinishViewController *view=[[UnFinishViewController alloc]init];
    view.str_title=@"公文传阅";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:view animated:NO];
}

//决策
-(void)JueCeItemClick:(UIImageButton *)button {
    UnFinishViewController *view=[[UnFinishViewController alloc]init];
    view.str_title=@"决策辅助";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:view animated:NO];
}

//办公
-(void)BanGongItemClick:(UIImageButton *)button {
    /*
    UnFinishViewController *view=[[UnFinishViewController alloc]init];
    view.str_title=@"办公审批";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:view animated:NO];
     */
    MyShenPiViewController *viewController=[[MyShenPiViewController alloc] init];
    viewController.userInfo=_userInfo;
    viewController.delegate=self;
    viewController.i_Class=1;
    viewController.str_title=@"办公审批";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:viewController animated:NO];
}

//售前
-(void)ShouQianItemClick:(UIImageButton *)button {
    UnFinishViewController *view=[[UnFinishViewController alloc]init];
    view.str_title=@"售前审批";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:view animated:NO];
}

//生产
-(void)ShengChanItemClick:(UIImageButton *)button {
    UnFinishViewController *view=[[UnFinishViewController alloc]init];
   // view.str_title=@"生产审批";
    view.str_title=@"更多审批";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:view animated:NO];
}

//合同
-(void)HeTongItemClick:(UIImageButton *)button {
    UnFinishViewController *view=[[UnFinishViewController alloc]init];
    view.str_title=@"合同审批";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:view animated:NO];
}

//事务
-(void)ShiWuItemClick:(UIImageButton *)button {
    /*
    UnFinishViewController *view=[[UnFinishViewController alloc]init];
    view.str_title=@"事务审批";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:view animated:NO];
     */
    MyShenPiViewController *viewController=[[MyShenPiViewController alloc] init];
    viewController.userInfo=_userInfo;
    viewController.delegate=self;
    viewController.i_Class=5;
    viewController.str_title=@"事务审批";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:viewController animated:NO];
}


//审批
-(void)ShenPiItemClick:(UIImageButton *)button {
    /*
    NSString *msg = [NSString stringWithFormat:@"第%i行 第%i列",button.row + 1, button.column + 1];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"好的，知道了"
                                          otherButtonTitles:nil, nil];
    [alert show];
     */
    /*
    ShenPiManagementController *viewController=[[ShenPiManagementController alloc] init];
    viewController.userInfo=_userInfo;
    [self.navigationController pushViewController:viewController animated:YES];
    */
    MyShenPiViewController *viewController=[[MyShenPiViewController alloc] init];
    viewController.userInfo=_userInfo;
    viewController.delegate=self;
    viewController.i_Class=0;
    viewController.str_title=@"我的审批";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:viewController animated:NO];

}

-(void)IVotingItemClick:(UIImageButton *)button {
    IVotingManamentController *viewController=[[IVotingManamentController alloc]init];
    viewController.user_Info=_userInfo;
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:viewController animated:NO];

}


-(void)NotesItemClick:(UIImageButton *)button {
    NotesViewController *notesView=[[NotesViewController alloc]init];
    notesView.user_Info=_userInfo;
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:notesView animated:NO];
}

-(void)WeatherItemClick:(UIImageButton *)button {
    WeatherViewController *vc=[[WeatherViewController alloc]init];
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:vc animated:NO];

}

/*
-(void)ClearNewsRedDot {
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableGridViewCell *news_cell=(UITableGridViewCell*)cell;
    for (UIView *view in news_cell.subviews) {
        if ([view isMemberOfClass:[UIImageButton class]]) {
            UIImageButton *news_btn=(UIImageButton*)view;
            if ([news_btn.titleLabel.text isEqualToString:@"公告"]) {
                [news_btn clearBadge];
            }
            
        }
    }
    [self.tableView reloadData];
}
*/
//点击审批后返回时刷新badgeValue
-(void)RefreshBadge:(NSMutableDictionary*)param {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
         NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        NSString *str_urldata=[db fetchInterface:@"TaskCountUnfinish"];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                NSString *str_total=[JSON objectForKey:@"c0"];
                NSString *str_bangong=[JSON objectForKey:@"c1"];
                NSString *str_shiwu=[JSON objectForKey:@"c5"];
                i_total=[str_total integerValue];
                i_bangong=[str_bangong integerValue];
                i_shiwu=[str_shiwu integerValue];
                _btn_ShenPi.badgeBgColor=[UIColor redColor];
                [_btn_ShenPi showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone x:0 y:0];
                [_btn_BanGong showBadgeWithStyle:WBadgeStyleNumber value:i_bangong animationType:WBadgeAnimTypeNone x:0 y:0];
                [_btn_ShiWu showBadgeWithStyle:WBadgeStyleNumber value:i_shiwu animationType:WBadgeAnimTypeNone x:0 y:0];
                [self.view setNeedsDisplay];
               /*
               NSString *str_totalPage=[JSON objectForKey:@"totalPage"];
                NSMutableDictionary *dic_param1=[NSMutableDictionary dictionary];
                dic_param1[@"pageIndex"]=str_totalPage;
                NSString *str_ip_1=@"";
                NSString *str_port_1=@"";
                NSMutableArray *t_array=[db fetchIPAddress];
                if (t_array.count==1) {
                    NSArray *arr_ip=[t_array objectAtIndex:0];
                    str_ip_1=[arr_ip objectAtIndex:0];
                    str_port_1=[arr_ip objectAtIndex:1];
                }
                NSString *str_urldata_1=[db fetchInterface:@"UnFinishTaskShenPiList"];
                NSString *str_url2=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip_1,str_port_1,str_urldata_1];
                [_session POST:str_url2 parameters:dic_param1 progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSDictionary *JSON1=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSArray *arr_TaskList=[JSON1 objectForKey:@"taskList"];
                    NSInteger i_integer=[str_totalPage integerValue];
                    i_total=[arr_TaskList count]+(i_integer-1)*10;
                    _btn_ShenPi.badgeBgColor=[UIColor redColor];
                    // _btn_ShenPi.badgeCenterOffset=CGPointMake(0, _btn_ShenPi.size.height*0.08);
                    [_btn_ShenPi showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone];
                    [self.view setNeedsDisplay];

                  //  [self.tableView reloadData];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                */
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
}

//整理数据
-(void)PrePareData:(NSMutableDictionary*)param interface:(NSString*)str_interface{
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        NSString *str_urldata=[db fetchInterface:str_interface];
        NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
        str_urldata= [str_urldata stringByTrimmingCharactersInSet:whitespace];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            [self.view setUserInteractionEnabled:NO];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.view setUserInteractionEnabled:YES];
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                [indicator stopAnimating];
                NSLog(@"获取审批列表成功");
                NSString *str_total= [JSON objectForKey:@"c0"];
                NSString *str_bangong=[JSON objectForKey:@"c1"];
                NSString *str_shiwu=[JSON objectForKey:@"c5"];
                i_total=[str_total integerValue];
                i_bangong=[str_bangong integerValue];
                i_shiwu=[str_shiwu integerValue];
                /*
                NSArray *arr_TaskList=[JSON objectForKey:@"taskList"];
                NSInteger i_integer=[_str_page integerValue];
                i_total=[arr_TaskList count]+(i_integer-1)*10;
                 */
                
               // [_btn_ShenPi setNeedsDisplay];
                _btn_ShenPi.badgeBgColor=[UIColor redColor];
                // _btn_ShenPi.badgeCenterOffset=CGPointMake(0, _btn_ShenPi.size.height*0.08);
                [_btn_ShenPi showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone x:0 y:0];
                [_btn_BanGong showBadgeWithStyle:WBadgeStyleNumber value:i_bangong animationType:WBadgeAnimTypeNone x:0 y:0];
                [_btn_ShiWu showBadgeWithStyle:WBadgeStyleNumber value:i_shiwu animationType:WBadgeAnimTypeNone x:0 y:0];
                [self.view setNeedsDisplay];
                
                
                
               //  [self.tableView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
            //停止刷新
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"无法连接到服务器" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
        }];
        
    }
    else {
        [indicator stopAnimating];
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
        
    }
    
    
}


-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}


//添加菊花等待图标
-(UIActivityIndicatorView*)AddLoop {
    //初始化:
    UIActivityIndicatorView *l_indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    
    l_indicator.tag = 103;
    
    //设置显示样式,见UIActivityIndicatorViewStyle的定义
    l_indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    
    //设置背景色
    l_indicator.backgroundColor = [UIColor blackColor];
    
    //设置背景透明
    l_indicator.alpha = 0.5;
    
    //设置背景为圆角矩形
    l_indicator.layer.cornerRadius = 6;
    l_indicator.layer.masksToBounds = YES;
    //设置显示位置
    [l_indicator setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    return l_indicator;
}


-(void)RefreshBadgeNumber {
    [self RefreshNum];
    
    UINavigationController *nav1=[self.parentViewController.parentViewController.childViewControllers objectAtIndex:0];
    MessageViewController *message_vc=(MessageViewController*)[nav1.childViewControllers objectAtIndex:0];
    [message_vc RefreshFlowNum];

}

-(void)RefreshNum {
    NSMutableDictionary *dic_param1=[NSMutableDictionary dictionary];
    dic_param1[@"pageIndex"]=@"1";
    [self RefreshBadge:dic_param1];
}

-(void)Badge_Minus {
    if (i_total>0) {
        i_total=i_total-1;
        _btn_ShenPi.badgeBgColor=[UIColor redColor];
        [_btn_ShenPi showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone x:0 y:0];
        [self.view setNeedsDisplay];
    }
}

-(void)XSpotLightClicked:(NSInteger)index {
    
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

