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

//菜单内容
@property (nonatomic,strong,nonnull)NSArray *leftArray;
@property (nonatomic,strong,nonnull)NSArray *rightArray;

//菜单图片
@property (nonatomic,strong,nonnull) NSArray *leftImgArray;
@property (nonatomic,strong,nonnull) NSArray *rightImgArray;

//菜单颜色
@property (nonatomic,strong,nonnull) NSArray *leftArrayColor;
@property (nonatomic,strong,nonnull) NSArray *rightArrayColor;

@property (nonatomic,strong) UITableView *tableView;

//审批状态搜索关键字
@property (nonatomic,strong) NSString *str_searchKeyword1;

//审批类型搜索关键字
@property (nonatomic,strong) NSString *str_searchKeyword2;


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
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.leftArray=@[@"全部",@"已办",@"待办"];
    self.rightArray=@[@"全部",@"复印",@"预约用车"];
    
    self.leftImgArray=@[@" ",@"mission_done.png",@"mission_unfinished.png"];
    self.rightImgArray=@[@" ",@"printmission.png",@"carmission.png"];
    
    self.leftArrayColor=@[[UIColor blackColor],[UIColor colorWithRed:25/255.0f green:189/255.0f blue:144/255.0f alpha:1],[UIColor colorWithRed:246/255.0f green:88/255.0f blue:87/255.0f alpha:1]];
    self.rightArrayColor=@[[UIColor blackColor],[UIColor colorWithRed:246/255.0f green:88/255.0f blue:87/255.0f alpha:1],[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1]];

    _str_searchKeyword1=@"全部";
    _str_searchKeyword2=@"全部";
    _arr_MySearchResult=[[NSMutableArray alloc]init];
    [self setupTopView];

    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-150) style:UITableViewStylePlain];
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
    .topSpaceToView(self.view,0);
    
    self.levelButton = [[MCMenuButton alloc] initWithTitle:@"状态"];
    [self.topView addSubview:self.levelButton];
    self.levelButton.sd_layout
    .leftSpaceToView(self.topView,60)
    .topSpaceToView(self.topView,5)
    .bottomSpaceToView(self.topView,5)
    .widthRatioToView(self.topView,0.4);
    self.levelButton.layer.cornerRadius=20.0f;
    self.levelButton.layer.borderWidth=1;
    [self.levelButton.layer setMasksToBounds:YES];
    self.levelButton.layer.borderColor=[[UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1] CGColor];
    
    self.groupButton = [[MCMenuButton alloc] initWithTitle:@"类型"];
    [self.topView addSubview:self.groupButton];
    self.groupButton.sd_layout
    .leftSpaceToView(self.levelButton,-30)
    .topSpaceToView(self.topView,5)
    .bottomSpaceToView(self.topView,5)
    .widthRatioToView(self.topView,0.4);
    self.groupButton.layer.cornerRadius=20.0f;
    self.groupButton.layer.borderWidth=1;
    [self.groupButton.layer setMasksToBounds:YES];
    self.groupButton.layer.borderColor=[[UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1] CGColor];
    
    self.levelButton.backgroundColor=[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1];
    [self.levelButton setTitleColor:[UIColor whiteColor]];
    
    self.groupButton.backgroundColor=[UIColor whiteColor];
    [self.groupButton setTitleColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1]];

    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self.topView addSubview:lineView];
    lineView.sd_layout.leftSpaceToView(self.topView,0).rightSpaceToView(self.topView,0).bottomEqualToView(self.topView).heightIs(0.5);
    
    
    
    __weak typeof(self) weakSelf = self;
    //点击等级
    self.levelButton.clickedBlock = ^(id data){
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        weakSelf.levelButton.backgroundColor=[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1];
        [weakSelf.levelButton setTitleColor:[UIColor whiteColor]];
        
        weakSelf.groupButton.backgroundColor=[UIColor whiteColor];
        [weakSelf.groupButton setTitleColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1]];
        
        for (int i = 0 ; i < self.leftArray.count ; i++ ) {
            
            MCPopMenuItem *item = [[MCPopMenuItem alloc] init];
            item.itemid = @"0";
            item.itemtitle = weakSelf.leftArray[i];
            item.itmeImageName=weakSelf.leftImgArray[i];
            item.itemtitleColor=weakSelf.leftArrayColor[i];
            [arrayM addObject:item];
        }
        
        MCPopMenuViewController *popVc = [[MCPopMenuViewController alloc] initWithDataSource:arrayM fromView:weakSelf.topView];
        [popVc show];
        popVc.didSelectedItemBlock = ^(MCPopMenuItem *item){
            [weakSelf.levelButton refreshWithTitle:item.itemtitle];
            weakSelf.levelButton.extend = item;
            weakSelf.str_searchKeyword1=item.itemtitle;
            weakSelf.arr_MySearchResult= [weakSelf CreateSearchResult:weakSelf.str_searchKeyword1 con2:weakSelf.str_searchKeyword2];
            [weakSelf.tableView reloadData];
            
        };
    };
    
    //点击等级
    self.groupButton.clickedBlock = ^(id data){
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        weakSelf.groupButton.backgroundColor=[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1];
        [weakSelf.groupButton setTitleColor:[UIColor whiteColor]];
        
        weakSelf.levelButton.backgroundColor=[UIColor whiteColor];
        [weakSelf.levelButton setTitleColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1]];
        
        for (int i = 0 ; i < self.rightArray.count ; i++ ) {
            
            MCPopMenuItem *item = [[MCPopMenuItem alloc] init];
            item.itemid = @"0";
            item.itemtitle = weakSelf.rightArray[i];
            item.itmeImageName=weakSelf.rightImgArray[i];
            item.itemtitleColor=weakSelf.rightArrayColor[i];
            [arrayM addObject:item];
        }
        
        MCPopMenuViewController *popVc = [[MCPopMenuViewController alloc] initWithDataSource:arrayM fromView:weakSelf.topView];
        [popVc show];
        popVc.didSelectedItemBlock = ^(MCPopMenuItem *item){
            //点击事件 0416
            [weakSelf.groupButton refreshWithTitle:item.itemtitle];
            weakSelf.groupButton.extend = item;
            weakSelf.str_searchKeyword2=item.itemtitle;
            weakSelf.arr_MySearchResult= [weakSelf CreateSearchResult:weakSelf.str_searchKeyword1 con2:weakSelf.str_searchKeyword2];
            [weakSelf.tableView reloadData];
           
        };
    };
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_str_searchKeyword2 isEqualToString:@"全部"] && [_str_searchKeyword1 isEqualToString:@"全部"]) {
        return [_arr_MyApplication count];
    }
    else {
        return   [_arr_MySearchResult count];
    }
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
        if ([_str_searchKeyword1 isEqualToString:@"全部"] && [_str_searchKeyword2 isEqualToString:@"全部"]) {
            if ([[_arr_MyApplication objectAtIndex:indexPath.section] isMemberOfClass:[CarService class]]) {
                CarService *tmp_service=[_arr_MyApplication objectAtIndex:indexPath.section];
                cell = [self CreateCarCell:tmp_service tableview:tableView];
            }
            else if ([[_arr_MyApplication objectAtIndex:indexPath.section] isMemberOfClass:[PrintService class]]) {
                PrintService *tmp_service=[_arr_MyApplication objectAtIndex:indexPath.section];
                cell=[self CreatePrintCell:tmp_service tableview:tableView];
            }
        }
        else {
            if ([[_arr_MySearchResult objectAtIndex:indexPath.section] isMemberOfClass:[CarService class]]) {
                CarService *tmp_service=[_arr_MySearchResult objectAtIndex:indexPath.section];
                cell = [self CreateCarCell:tmp_service tableview:tableView];
            }
            else if ([[_arr_MySearchResult objectAtIndex:indexPath.section] isMemberOfClass:[PrintService class]]) {
                PrintService *tmp_service=[_arr_MySearchResult objectAtIndex:indexPath.section];
                cell=[self CreatePrintCell:tmp_service tableview:tableView];

            }
            
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

//根据条件筛选
-(NSMutableArray*)CreateSearchResult:(NSString*)str_condition1 con2:(NSString*)str_condition2 {
    NSMutableArray *arr_result=[[NSMutableArray alloc]init];
    if (_arr_MyApplication.count>0) {
        if ([str_condition1 isEqualToString:@"全部"]) {
           arr_result= [self CreateSearchResultAdvanced:_arr_MyApplication con2:str_condition2];
        }
        else {
            arr_result=[self CreateSearchResultFirst:_arr_MyApplication con1:str_condition1];
            arr_result=[self CreateSearchResultAdvanced:arr_result con2:str_condition2];
        }
        
    }
    return arr_result;
}


//根据第一个条件筛选原数组
-(NSMutableArray *)CreateSearchResultFirst:(NSMutableArray*)arr_origin con1:(NSString*)str_condition {
    NSMutableArray *arr_tmp=[[NSMutableArray alloc]init];
    for (int i=0;i<arr_origin.count;i++) {
        NSObject *tmp=[arr_origin objectAtIndex:i];
        PrintService *tmp_Print;
        CarService *tmp_Car;
        if ([tmp isMemberOfClass:[PrintService class]]) {
             tmp_Print=(PrintService*)tmp;
        }
        else if ([tmp isMemberOfClass:[CarService class]]) {
            tmp_Car=(CarService*)tmp;
        }
        if ([str_condition isEqualToString:@"待办"]) {
            if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2==nil) {
                if ([tmp_Print.shenpi_1.str_status isEqualToString:@"不同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2==nil) {
                if ([tmp_Car.shenpi_1.str_status isEqualToString:@"不同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2!=nil) {
                if ([tmp_Print.shenpi_2.str_status isEqualToString:@"不同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2!=nil) {
                if ([tmp_Car.shenpi_2.str_status isEqualToString:@"不同意"]) {
                    [arr_tmp addObject:tmp_Car];
                }
            }
        }
        else if ([str_condition isEqualToString:@"已办"]) {
            if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2!=nil) {
                if ([tmp_Print.shenpi_1.str_status isEqualToString:@"同意"] && [tmp_Print.shenpi_2.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Print.shenpi_1==nil && tmp_Print.shenpi_2==nil) {
                if (tmp_Print!=nil) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2==nil) {
                if ([tmp_Print.shenpi_1.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2!=nil) {
                if ([tmp_Car.shenpi_1.str_status isEqualToString:@"同意"] && [tmp_Car.shenpi_2.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Car];
                }
            }
            if (tmp_Car.shenpi_1==nil && tmp_Car.shenpi_2==nil) {
                if (tmp_Car!=nil) {
                    [arr_tmp addObject:tmp_Car];
                }
            }
            if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2==nil) {
                if ([tmp_Car.shenpi_1.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Car];
                }
            }
        }
    }
    
    return arr_tmp;
    
}


//确定第一个条件后再次筛选
-(NSMutableArray*)CreateSearchResultAdvanced:(NSMutableArray*)arr_firstsearch con2:(NSString*)str_condition {
    NSMutableArray *arr_tmp=[[NSMutableArray alloc]init];
    if ([str_condition isEqualToString:@"全部"]) {
        return arr_firstsearch;
    }
    else if ([str_condition isEqualToString:@"复印"]) {
        for (int i=0;i<arr_firstsearch.count;i++) {
            NSObject *tmp=[arr_firstsearch objectAtIndex:i];
            if ([tmp isMemberOfClass:[PrintService class]]) {
                PrintService *tmp_Print=(PrintService*)tmp;
                [arr_tmp addObject:tmp_Print];
            }
        }
    }
    else if ([str_condition isEqualToString:@"预约用车"]) {
        for (int i=0;i<arr_firstsearch.count;i++) {
            NSObject *tmp=[arr_firstsearch objectAtIndex:i];
            if ([tmp isMemberOfClass:[CarService class]]) {
                CarService *tmp_Car=(CarService*)tmp;
                [arr_tmp addObject:tmp_Car];
            }
        }
    }
    
    return arr_tmp;
}

//分解，创建预约用车cell
-(MyApplicationCell*)CreateCarCell:(CarService*)tmp_service tableview:(UITableView*)tableView {
    MyApplicationCell *cell;
    if (tmp_service!=nil) {
        if (tmp_service.shenpi_1==nil && tmp_service.shenpi_2==nil) {
            cell=[MyApplicationCell cellWithTable:tableView withTitle:tmp_service.str_reason withStatus:@"已办" isUsingCar:YES withTime:tmp_service.str_applicationTime];
        }
        else if (tmp_service.shenpi_1!=nil && tmp_service.shenpi_2==nil) {
            if ([tmp_service.shenpi_1.str_status isEqualToString:@"同意"]) {
                cell=[MyApplicationCell cellWithTable:tableView withTitle:tmp_service.str_reason withStatus:@"已办" isUsingCar:YES withTime:tmp_service.shenpi_1.str_time];
            }
            else if ([tmp_service.shenpi_1.str_status isEqualToString:@"不同意"]) {
                cell=[MyApplicationCell cellWithTable:tableView withTitle:tmp_service.str_reason withStatus:@"待办" isUsingCar:YES withTime:tmp_service.shenpi_1.str_time];
            }
        }
        else if (tmp_service.shenpi_2!=nil ) {
            if ([tmp_service.shenpi_2.str_status isEqualToString:@"同意"]) {
                cell=[MyApplicationCell cellWithTable:tableView withTitle:tmp_service.str_reason withStatus:@"已办" isUsingCar:YES withTime:tmp_service.shenpi_2.str_time];
            }
            else if ([tmp_service.shenpi_1.str_status isEqualToString:@"不同意"]) {
                cell=[MyApplicationCell cellWithTable:tableView withTitle:tmp_service.str_reason withStatus:@"待办" isUsingCar:YES withTime:tmp_service.shenpi_2.str_time];
            }
        }
        cell.car_service=tmp_service;
        return cell;
    }
    else {
        return nil;
    }
    
}

//分解，创建复印cell
-(MyApplicationCell*)CreatePrintCell:(PrintService*)tmp_service tableview:(UITableView *)tableView {
    MyApplicationCell *cell;
    if (tmp_service!=nil) {
        if (tmp_service.shenpi_1==nil && tmp_service.shenpi_2==nil) {
            cell=[MyApplicationCell cellWithTable:tableView withTitle:[NSString stringWithFormat:@"%@%@",tmp_service.str_title,@"项目打印清单"] withStatus:@"已办" isUsingCar:NO withTime:tmp_service.str_applicationTime];
        }
        else if (tmp_service.shenpi_1!=nil && tmp_service.shenpi_2==nil) {
            if ([tmp_service.shenpi_1.str_status isEqualToString:@"同意"]) {
                cell=[MyApplicationCell cellWithTable:tableView withTitle:[NSString stringWithFormat:@"%@%@",tmp_service.str_title,@"项目打印清单"] withStatus:@"已办" isUsingCar:NO withTime:tmp_service.shenpi_1.str_time];
            }
            else if ([tmp_service.shenpi_1.str_status isEqualToString:@"不同意"]) {
                cell=[MyApplicationCell cellWithTable:tableView withTitle:[NSString stringWithFormat:@"%@%@",tmp_service.str_title,@"项目打印清单"] withStatus:@"待办" isUsingCar:NO withTime:tmp_service.shenpi_1.str_time];
            }
        }
        else if (tmp_service.shenpi_2!=nil) {
            if ([tmp_service.shenpi_2.str_status isEqualToString:@"同意"]) {
                cell=[MyApplicationCell cellWithTable:tableView withTitle:[NSString stringWithFormat:@"%@%@",tmp_service.str_title,@"项目打印清单"] withStatus:@"已办" isUsingCar:NO withTime:tmp_service.shenpi_2.str_time];
            }
            else if ([tmp_service.shenpi_2.str_status isEqualToString:@"不同意"]) {
                cell=[MyApplicationCell cellWithTable:tableView withTitle:[NSString stringWithFormat:@"%@%@",tmp_service.str_title,@"项目打印清单"] withStatus:@"待办" isUsingCar:NO withTime:tmp_service.shenpi_2.str_time];
            }
        }
        cell.print_service=tmp_service;
        return cell;
    }
    else {
        return nil;
    }
    
}


@end
