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
#import "ShenPiManagementController.h"

#define kImageWidth 100      //UITAbleViewCell里面图片的宽度
#define kImageHeight 100     //UITableViewCell里面图片的高度

@interface FunctionViewController ()<ClearRedDotDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIImage *image;

@end

@implementation FunctionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDictionary * dict=@{
                              NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
        self.navigationController.navigationBar.titleTextAttributes=dict;
        self.title = @"应用";
       
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor=[UIColor yellowColor];
    self.title=@"应用";
    self.view.backgroundColor=[UIColor whiteColor];
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    
    CGSize mSize=[[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth=mSize.width;
    CGFloat screenHeiht=mSize.height;
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeiht) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    self.tableView.dataSource=self;
    self.tableView.separatorColor=[UIColor blackColor];
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITable datasource and delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


-(UIImageButton *)createImageButton:(CGFloat)x CenterY:(CGFloat)y title:(NSString*)str_title image:(NSString *)str_image {
    UIImageButton *tmp_btn=[UIImageButton buttonWithType:UIButtonTypeCustom];
    tmp_btn.bounds=CGRectMake(0, 0, kImageWidth, kImageHeight);
    
    tmp_btn.center=CGPointMake(x,y);
    [tmp_btn setValue:[NSNumber numberWithInt:0] forKey:@"column"];
    [tmp_btn setTitle:str_title forState:UIControlStateNormal];
    [tmp_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tmp_btn setTitleEdgeInsets:UIEdgeInsetsMake(50, 0, -50, 0)];
    
    [tmp_btn setBackgroundImage:[UIImage imageNamed:str_image] forState:UIControlStateNormal];
    
    return tmp_btn;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"Cell";
    //自定义UITableGridViewCell
    UITableGridViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableGridViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectedBackgroundView=[[UIView alloc]init];
        NSMutableArray *array=[NSMutableArray array];
        
#pragma mark 添加通知公告图标
        UIImageButton *btn_News;
        UIImageButton *btn_ShenPi;
        UIImageButton *btn_IVoting;
        UIImageButton *btn_Notes;
        if (iPhone6) {
            btn_News=[self createImageButton:30+kImageWidth*0.5 CenterY:5+kImageHeight*0.5 title:@"公告" image:@"News.png"];
            
            [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_ShenPi=[self createImageButton:35+kImageWidth*1.5 CenterY:5+kImageHeight*0.5 title:@"审批" image:@"ShenPi.png"];
            [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_IVoting=[self createImageButton:40+kImageWidth*2.5 CenterY:5+kImageWidth*0.5 title:@"电子投票" image:@"IVoting.png"];
            [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_Notes=[self createImageButton:30+kImageWidth*0.5 CenterY:5+kImageHeight*0.5 title:@"备忘录" image:@"Notes.png"];
            [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (iPhone5_5s || iPhone4_4s) {
            btn_News=[self createImageButton:5+kImageWidth*0.5 CenterY:5+kImageHeight*0.5 title:@"公告" image:@"News.png"];
            [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_ShenPi=[self createImageButton:10+kImageWidth*1.5 CenterY:5+kImageHeight*0.5 title:@"审批" image:@"ShenPi.png"];
            [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_IVoting=[self createImageButton:15+kImageWidth*2.5 CenterY:5+kImageWidth*0.5 title:@"电子投票" image:@"IVoting.png"];
            [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_Notes=[self createImageButton:5+kImageWidth*0.5 CenterY:5+kImageHeight*0.5 title:@"备忘录" image:@"Notes.png"];
            [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (iPhone6_plus)
        {
                btn_News=[self createImageButton:30+kImageWidth*0.5 CenterY:5+kImageHeight*0.5 title:@"公告" image:@"News.png"];
                [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_ShenPi=[self createImageButton:50+kImageWidth*1.5 CenterY:5+kImageHeight*0.5 title:@"审批" image:@"ShenPi.png"];
               [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_IVoting=[self createImageButton:70+kImageWidth*2.5 CenterY:5+kImageWidth*0.5 title:@"电子投票" image:@"IVoting.png"];
               [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_Notes=[self createImageButton:30+kImageWidth*0.5 CenterY:5+kImageHeight*0.5 title:@"备忘录" image:@"Notes.png"];
               [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        btn_News.badgeBgColor=[UIColor redColor];
        btn_News.badgeCenterOffset=CGPointMake(0, btn_News.size.height*0.08);
        [btn_News showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeNone];
        
        
        btn_ShenPi.badgeBgColor=[UIColor redColor];
        btn_ShenPi.badgeCenterOffset=CGPointMake(0, btn_ShenPi.size.height*0.08);
        [btn_ShenPi showBadgeWithStyle:WBadgeStyleNumber value:1 animationType:WBadgeAnimTypeNone];
        
        if (indexPath.row==0) {
            [cell addSubview:btn_News];
            [cell addSubview:btn_ShenPi];
            [cell addSubview:btn_IVoting];
            [array addObject:btn_News];
            [array addObject:btn_ShenPi];
            [array addObject:btn_IVoting];
        }
        else if (indexPath.row==1) {
            [cell addSubview:btn_Notes];
            [array addObject:btn_Notes];
        }

        
        [cell setValue:array forKey:@"buttons"];
    }
        NSArray *imageButtons=cell.buttons;
        
        [imageButtons setValue:[NSNumber numberWithInt:(int)indexPath.row] forKey:@"row"];
        
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kImageHeight+30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //不让tableViewcellY有选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)NewsItemClick:(UIImageButton *)button {
#pragma mark 控制红点通知
    
    NewsManagementViewController *newsView=[[NewsManagementViewController alloc]init];
    newsView.b_hasnews= button.badge.isHidden;
    newsView.delegate=self;
    [self.navigationController pushViewController:newsView animated:YES];
}

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
    ShenPiManagementController *viewController=[[ShenPiManagementController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];

}

-(void)IVotingItemClick:(UIImageButton *)button {
    IVotingManamentController *viewController=[[IVotingManamentController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];

}


-(void)NotesItemClick:(UIImageButton *)button {
    NotesViewController *notesView=[[NotesViewController alloc]init];
    [self.navigationController pushViewController:notesView animated:YES];
}

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

