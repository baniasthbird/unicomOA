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
#import "MyApplicationCell.h"
#import "CarApplicationDetail.h"
#import "PrintApplicationDetail.h"
#import "ShenPiStatus.h"

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


@end


@implementation MyApplication

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的申请";
    
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

    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-150) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.scrollEnabled=YES;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)NewVc:(UIButton*)sender {
    NewApplication *viewController=[[NewApplication alloc]init];
    viewController.delegate=self;
    viewController.userInfo=_userInfo;
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
    return [_arr_MyApplication count];
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
    MyApplicationCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        if ([[_arr_MyApplication objectAtIndex:indexPath.section] isMemberOfClass:[CarService class]]) {
            CarService *tmp_service=[_arr_MyApplication objectAtIndex:indexPath.section];
            if (tmp_service.shenpi_1==nil && tmp_service.shenpi_2==nil) {
                cell=[MyApplicationCell cellWithTable:tableView withTitle:tmp_service.str_reason withStatus:@"未处理" isUsingCar:YES withTime:tmp_service.str_applicationTime];
            }
            else if (tmp_service.shenpi_1!=nil && tmp_service.shenpi_2==nil) {
                if ([tmp_service.shenpi_1.str_status isEqualToString:@"同意"]) {
                    cell=[MyApplicationCell cellWithTable:tableView withTitle:tmp_service.str_reason withStatus:@"审批中" isUsingCar:YES withTime:tmp_service.shenpi_1.str_time];
                }
                else if ([tmp_service.shenpi_1.str_status isEqualToString:@"不同意"]) {
                    cell=[MyApplicationCell cellWithTable:tableView withTitle:tmp_service.str_reason withStatus:@"不同意" isUsingCar:YES withTime:tmp_service.shenpi_1.str_time];
                }
            }
            else if (tmp_service.shenpi_2!=nil ) {
                if ([tmp_service.shenpi_2.str_status isEqualToString:@"同意"]) {
                    cell=[MyApplicationCell cellWithTable:tableView withTitle:tmp_service.str_reason withStatus:@"同意" isUsingCar:YES withTime:tmp_service.shenpi_2.str_time];
                }
                else if ([tmp_service.shenpi_1.str_status isEqualToString:@"不同意"]) {
                    cell=[MyApplicationCell cellWithTable:tableView withTitle:tmp_service.str_reason withStatus:@"不同意" isUsingCar:YES withTime:tmp_service.shenpi_2.str_time];
                }
            }
            cell.car_service=tmp_service;
            cell.str_status=@"审批中";
            cell.str_time=@"04-04 16:06";
        }
        else if ([[_arr_MyApplication objectAtIndex:indexPath.section] isMemberOfClass:[PrintService class]]) {
            PrintService *tmp_service=[_arr_MyApplication objectAtIndex:indexPath.section];
            if (tmp_service.shenpi_1==nil && tmp_service.shenpi_2==nil) {
                cell=[MyApplicationCell cellWithTable:tableView withTitle:[NSString stringWithFormat:@"%@%@",tmp_service.str_title,@"项目打印清单"] withStatus:@"未处理" isUsingCar:NO withTime:tmp_service.str_applicationTime];
            }
            else if (tmp_service.shenpi_1!=nil && tmp_service.shenpi_2==nil) {
                if ([tmp_service.shenpi_1.str_status isEqualToString:@"同意"]) {
                    cell=[MyApplicationCell cellWithTable:tableView withTitle:[NSString stringWithFormat:@"%@%@",tmp_service.str_title,@"项目打印清单"] withStatus:@"审批中" isUsingCar:NO withTime:tmp_service.shenpi_1.str_time];
                }
                else if ([tmp_service.shenpi_1.str_status isEqualToString:@"不同意"]) {
                    cell=[MyApplicationCell cellWithTable:tableView withTitle:[NSString stringWithFormat:@"%@%@",tmp_service.str_title,@"项目打印清单"] withStatus:@"不同意" isUsingCar:NO withTime:tmp_service.shenpi_1.str_time];
                }
            }
            else if (tmp_service.shenpi_2!=nil) {
                if ([tmp_service.shenpi_2.str_status isEqualToString:@"同意"]) {
                    cell=[MyApplicationCell cellWithTable:tableView withTitle:[NSString stringWithFormat:@"%@%@",tmp_service.str_title,@"项目打印清单"] withStatus:@"同意" isUsingCar:NO withTime:tmp_service.shenpi_2.str_time];
                }
                else if ([tmp_service.shenpi_1.str_status isEqualToString:@"不同意"]) {
                    cell=[MyApplicationCell cellWithTable:tableView withTitle:[NSString stringWithFormat:@"%@%@",tmp_service.str_title,@"项目打印清单"] withStatus:@"不同意" isUsingCar:NO withTime:tmp_service.shenpi_2.str_time];
                }
            }
            cell.print_service=tmp_service;
            cell.str_status=@"审批中";
            cell.str_time=@"04-04 16:06";
        }
    }
    cell.backgroundColor=[UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyApplicationCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.car_service!=nil) {
        CarApplicationDetail *viewController=[[CarApplicationDetail alloc]init];
        viewController.service=cell.car_service;
        viewController.userInfo=_userInfo;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (cell.print_service!=nil) {
        PrintApplicationDetail *viewController=[[PrintApplicationDetail alloc]init];
        viewController.service=cell.print_service;
        viewController.userInfo=_userInfo;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)PassValueFromCarApplication:(NSString *)str_title CarObject:(CarService *)service {
    [_arr_MyApplication addObject:service];
    [_delegate PassArray:_arr_MyApplication];
    [self.tableView reloadData];
}

-(void)PassValueFromPrintApplication:(NSString *)str_title PrintObject:(PrintService *)service{
    [_arr_MyApplication addObject:service];
    [_delegate PassArray:_arr_MyApplication];
    [self.tableView reloadData];
   
}


//临时创建领导审批
-(ShenPiStatus*)CreateShenPiStatus {
    ShenPiStatus *tmp_status=[[ShenPiStatus alloc]init];
    tmp_status.str_name=@"李四";
    tmp_status.str_Logo=@"headLogo.png";
    tmp_status.str_status=@"申请中";
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    tmp_status.str_time=locationString;
    return tmp_status;
}


@end
