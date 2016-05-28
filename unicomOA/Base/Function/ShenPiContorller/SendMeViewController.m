//
//  SendMeViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/4/17.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SendMeViewController.h"
#import "UIView+SDAutoLayout.h"
#import "MCMenuButton.h"
#import "MCPopMenuViewController.h"
#import "MyShenPiCell.h"
#import "CarService.h"
#import "PrintService.h"
#import "CarApplicationDetail.h"
#import "PrintApplicationDetailCell.h"

@interface SendMeViewController()<UITableViewDelegate,UITableViewDataSource>

/**
 *  头部筛选模块
 */
@property (nonatomic,strong,nonnull)UIView *topView;
@property (nonatomic,strong,nonnull)MCMenuButton *levelButton;
@property (nonatomic,strong,nonnull)MCMenuButton *groupButton;

@property (nonatomic,strong,nonnull)NSArray *leftArray;
@property (nonatomic,strong,nonnull)NSArray *rightArray;

@property (nonatomic,strong) UITableView *tableView;

@property NSInteger i_sectionClicked;

//抄送给我搜索关键字
@property (nonatomic,strong) NSString *str_searchKeyword1;

//抄送给我搜索关键字
@property (nonatomic,strong) NSString *str_searchKeyword2;

@end

@implementation SendMeViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"抄送给我";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _arr_SearchResult=[[NSMutableArray alloc]init];
    
    self.leftArray=@[@"全部",@"审批中",@"同意",@"不同意"];
    self.rightArray=@[@"全部",@"复印",@"预约用车"];
    
    _str_searchKeyword1=@"全部";
    _str_searchKeyword2=@"全部";

    [self setupTopView];
    
    _i_sectionClicked=-1;
    
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
            weakSelf.str_searchKeyword1=item.itemtitle;
            weakSelf.arr_SearchResult= [weakSelf CreateSearchResult:weakSelf.str_searchKeyword1 con2:weakSelf.str_searchKeyword2];
            [weakSelf.tableView reloadData];
            
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
            weakSelf.str_searchKeyword2=item.itemtitle;
            weakSelf.arr_SearchResult= [weakSelf CreateSearchResult:weakSelf.str_searchKeyword1 con2:weakSelf.str_searchKeyword2];
            [weakSelf.tableView reloadData];
            
        };
    };
}


//根据条件筛选
-(NSMutableArray*)CreateSearchResult:(NSString*)str_condition1 con2:(NSString*)str_condition2 {
    NSMutableArray *arr_result=[[NSMutableArray alloc]init];
    if (_arr_SendMe.count>0) {
        if ([str_condition1 isEqualToString:@"全部"]) {
            arr_result= [self CreateSearchResultAdvanced:_arr_SendMe con2:str_condition2];
        }
        else {
            arr_result=[self CreateSearchResultFirst:_arr_SendMe con1:str_condition1];
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
        if ([str_condition isEqualToString:@"审批中"]) {
            if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2==nil) {
                if ([tmp_Print.shenpi_1.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2==nil) {
                if ([tmp_Car.shenpi_1.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Car];
                }
            }
        }
        else if ([str_condition isEqualToString:@"同意"]) {
            if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2!=nil) {
                if ([tmp_Print.shenpi_1.str_status isEqualToString:@"同意"] && [tmp_Print.shenpi_2.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2!=nil) {
                if ([tmp_Car.shenpi_1.str_status isEqualToString:@"同意"] && [tmp_Car.shenpi_2.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Car];
                }
            }
            
        }
        else if ([str_condition isEqualToString:@"不同意"]) {
            if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2==nil) {
                if ([tmp_Print.shenpi_1.str_status isEqualToString:@"不同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            else if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2!=nil) {
                if ([tmp_Print.shenpi_2.str_status isEqualToString:@"不同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2==nil) {
                if ([tmp_Car.shenpi_1.str_status isEqualToString:@"不同意"]) {
                    [arr_tmp addObject:tmp_Car];
                }
            }
            else if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2!=nil) {
                if ([tmp_Car.shenpi_2.str_status isEqualToString:@"不同意"]) {
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


-(MyShenPiCell*)CreateCarCell:(CarService*)service tableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    MyShenPiCell *cell;
    if (service.shenpi_1==nil && service.shenpi_2==nil) {
        cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"预约用车" withStatus:@"未处理" withTitle:service.str_reason withTime:service.str_applicationTime atIndex:indexPath];
    }
    else if (service.shenpi_1!=nil && service.shenpi_2==nil) {
        if ([service.shenpi_1.str_status isEqualToString:@"同意"]) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"预约用车" withStatus:@"审批中" withTitle:service.str_reason withTime:service.shenpi_1.str_time atIndex:indexPath];
        }
        else if ([service.shenpi_1.str_status isEqualToString:@"不同意"]) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"预约用车" withStatus:@"不同意" withTitle:service.str_reason withTime:service.shenpi_1.str_time atIndex:indexPath];
        }
    }
    else if (service.shenpi_2!=nil) {
        if ([service.shenpi_2.str_status isEqualToString:@"同意"]) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"预约用车" withStatus:@"同意" withTitle:service.str_reason withTime:service.shenpi_2.str_time atIndex:indexPath];
        }
        else if ([service.shenpi_2.str_status isEqualToString:@"不同意"]) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"预约用车" withStatus:@"不同意" withTitle:service.str_reason withTime:service.shenpi_2.str_time atIndex:indexPath];
        }
    }
    cell.car_service=service;
    cell.str_category=@"预约用车";
    return cell;
}

-(MyShenPiCell*)CreatePrintCell:(PrintService*)service tableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    MyShenPiCell *cell;
    if (service.shenpi_1==nil && service.shenpi_2==nil) {
        cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"复印" withStatus:@"未处理" withTitle:service.str_title withTime:service.str_applicationTime atIndex:indexPath];
    }
    else if (service.shenpi_1!=nil && service.shenpi_2==nil) {
        if ([service.shenpi_1.str_status isEqualToString:@"同意"]) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"复印" withStatus:@"审批中" withTitle:service.str_title withTime:service.shenpi_1.str_time atIndex:indexPath];
        }
        else if ([service.shenpi_1.str_status isEqualToString:@"不同意"]) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"复印" withStatus:@"不同意" withTitle:service.str_title withTime:service.shenpi_1.str_time atIndex:indexPath];
        }
    }
    else if (service.shenpi_2!=nil) {
        if ([service.shenpi_2.str_status isEqualToString:@"同意"]) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"复印" withStatus:@"同意" withTitle:service.str_title withTime:service.shenpi_1.str_time atIndex:indexPath];
        }
        else if ([service.shenpi_2.str_status isEqualToString:@"不同意"]) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"复印" withStatus:@"不同意" withTitle:service.str_title withTime:service.shenpi_1.str_time atIndex:indexPath];
        }
    }
    cell.print_service=service;
    cell.str_category=@"复印";
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_str_searchKeyword2 isEqualToString:@"全部"] && [_str_searchKeyword1 isEqualToString:@"全部"]) {
        return [_arr_SendMe count];
    }
    else {
        return   [_arr_SearchResult count];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSString *ID=@"cell";
    NSString *ID=[NSString stringWithFormat:@"Cell%ld%ld",(long)[indexPath section],(long)[indexPath row]];
    MyShenPiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        if ([_str_searchKeyword1 isEqualToString:@"全部"] && [_str_searchKeyword2 isEqualToString:@"全部"])
        {
            NSObject *obj=[_arr_SendMe objectAtIndex:indexPath.section];
            
            if ([obj isMemberOfClass:[CarService class]]) {
                CarService *service=(CarService*)obj;
                cell=[self CreateCarCell:service tableView:tableView atIndexPath:indexPath];
            }
            else if ([obj isMemberOfClass:[PrintService class]]) {
                PrintService *service=(PrintService*)obj;
                cell=[self CreatePrintCell:service tableView:tableView atIndexPath:indexPath];
            }
        }
        else {
            NSObject *obj=[_arr_SearchResult objectAtIndex:indexPath.section];
            
            if ([obj isMemberOfClass:[CarService class]]) {
                CarService *service=(CarService*)obj;
                cell=[self CreateCarCell:service tableView:tableView atIndexPath:indexPath];
            }
            else if ([obj isMemberOfClass:[PrintService class]]) {
                PrintService *service=(PrintService*)obj;
                cell=[self CreatePrintCell:service tableView:tableView atIndexPath:indexPath];
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyShenPiCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _i_sectionClicked=indexPath.section;
    if ([cell.str_category isEqualToString:@"预约用车"]) {
        CarApplicationDetail *viewController=[[CarApplicationDetail alloc]init];
        viewController.service=cell.car_service;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([cell.str_category isEqualToString:@"复印"]) {
       // PrintApplicationDetailCell *viewController=[[PrintApplicationDetailCell alloc]init];
       // viewController.service=cell.print_service;
       // [self.navigationController pushViewController:viewController animated:YES];
    }
}


@end
