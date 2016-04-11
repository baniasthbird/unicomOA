//
//  MyApplication.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MyApplication.h"
#import "NewApplication.h"
#import "UIView+SDAutoLayout.h"
#import "MCMenuButton.h"
#import "MCPopMenuViewController.h"
#import "MyShenPi.h"

@interface MyApplication()<UITableViewDelegate,UITableViewDataSource,NewApplicationDelegate>

/**
 *  头部筛选模块
 */
@property (nonatomic,strong,nonnull)UIView *topView;
@property (nonatomic,strong,nonnull)MCMenuButton *levelButton;
@property (nonatomic,strong,nonnull)MCMenuButton *groupButton;

@property (nonatomic,strong,nonnull)NSArray *leftArray;
@property (nonatomic,strong,nonnull)NSArray *rightArray;

@property (nonatomic,strong) UITableView *tableView;

//我的审批事项
@property (nonatomic,strong) NSMutableArray *arr_MyShenPi;

@end


@implementation MyApplication

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的审批";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStyleDone target:self action:@selector(NewVc:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barButtonItem2;
    
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.leftArray=@[@"全部",@"审批中",@"同意",@"不同意"];
    self.rightArray=@[@"全部",@"复印",@"预约用车"];

    [self setupTopView];
    
    _arr_MyShenPi=[[NSMutableArray alloc]initWithCapacity:0];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)NewVc:(UIButton*)sender {
    NewApplication *viewController=[[NewApplication alloc]init];
    viewController.delegate=self;
    [self.navigationController pushViewController:viewController animated:YES];
}

/**
 *  设置头部
 */
- (void)setupTopView
{
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    self.topView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(44)
    .topSpaceToView(self.view,64);
    
    self.levelButton = [[MCMenuButton alloc] initWithTitle:@"状态"];
    [self.topView addSubview:self.levelButton];
    self.levelButton.sd_layout
    .leftSpaceToView(self.topView,0)
    .topSpaceToView(self.topView,0)
    .bottomSpaceToView(self.topView,0)
    .widthRatioToView(self.topView,0.5);
    
    self.groupButton = [[MCMenuButton alloc] initWithTitle:@"类型"];
    [self.topView addSubview:self.groupButton];
    self.groupButton.sd_layout
    .leftSpaceToView(self.levelButton,0)
    .topSpaceToView(self.topView,0)
    .bottomSpaceToView(self.topView,0)
    .widthRatioToView(self.topView,0.5);
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self.topView addSubview:lineView];
    lineView.sd_layout.leftSpaceToView(self.topView,0).rightSpaceToView(self.topView,0).bottomEqualToView(self.topView).heightIs(0.5);
    
    
    
    __weak typeof(self) weakSelf = self;
    //点击等级
    self.levelButton.clickedBlock = ^(id data){
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        
        for (int i = 0 ; i < self.leftArray.count ; i++ ) {
            
            MCPopMenuItem *item = [[MCPopMenuItem alloc] init];
            item.itemid = @"0";
            item.itemtitle = weakSelf.leftArray[i];
            [arrayM addObject:item];
        }
        
        MCPopMenuViewController *popVc = [[MCPopMenuViewController alloc] initWithDataSource:arrayM fromView:weakSelf.topView];
        [popVc show];
        popVc.didSelectedItemBlock = ^(MCPopMenuItem *item){
            
            [weakSelf.levelButton refreshWithTitle:item.itemtitle];
            weakSelf.levelButton.extend = item;
            
        };
    };
    
    //点击等级
    self.groupButton.clickedBlock = ^(id data){
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        for (int i = 0 ; i < self.rightArray.count ; i++ ) {
            
            MCPopMenuItem *item = [[MCPopMenuItem alloc] init];
            item.itemid = @"0";
            item.itemtitle = weakSelf.rightArray[i];
            [arrayM addObject:item];
        }
        
        MCPopMenuViewController *popVc = [[MCPopMenuViewController alloc] initWithDataSource:arrayM fromView:weakSelf.topView];
        [popVc show];
        popVc.didSelectedItemBlock = ^(MCPopMenuItem *item){
            
            [weakSelf.groupButton refreshWithTitle:item.itemtitle];
            weakSelf.groupButton.extend = item;
            
        };
    };
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_arr_MyShenPi count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (iPhone4_4s || iPhone5_5s)
        return 20;
    else if (iPhone6)
        return 30;
    else
        return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (iPhone4_4s || iPhone5_5s)
        return 20;
    else if (iPhone6)
        return 30;
    else
        return 40;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID=[NSString stringWithFormat:@"Cell%ld%ld",(long)[indexPath section],(long)[indexPath row]];
    MyShenPi *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        NSString *str_tmp=[_arr_MyShenPi objectAtIndex:indexPath.section];
        NSArray *arr_tmp=[str_tmp componentsSeparatedByString:@","];
        if ([[arr_tmp objectAtIndex:0] isEqualToString:@"YES"]) {
            cell=[MyShenPi cellWithTable:tableView withTitle:[arr_tmp objectAtIndex:1] withStatus:@"审批中" isUsingCar:YES withTime:@"04-16 16:06"];
        }
        else if ([[arr_tmp objectAtIndex:0] isEqualToString:@"NO"]) {
            cell=[MyShenPi cellWithTable:tableView withTitle:[arr_tmp objectAtIndex:1] withStatus:@"审批中" isUsingCar:NO withTime:@"04-16 16:06"];
        }
    }
    
    cell.backgroundColor=[UIColor whiteColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)PassValueFromCarApplication:(NSString *)str_title {
    NSString *str_cell=[NSString stringWithFormat:@"%@,%@",@"YES",str_title];
    [_arr_MyShenPi addObject:str_cell];
    [self.tableView reloadData];
}

-(void)PassValueFromPrintApplication:(NSString *)str_title {
    NSString *str_cell=[NSString stringWithFormat:@"%@,%@%@",@"NO",str_title,@"项目打印清单"];
    [_arr_MyShenPi addObject:str_cell];
    [self.tableView reloadData];
}


@end
