//
//  ShenPiAgreeWithCarDeploy.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ShenPiAgreeWithCarDeploy.h"
#import "CarDeployCell.h"


@interface ShenPiAgreeWithCarDeploy()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>

@property (nonatomic,strong) UILabel *lbl_tip;

@property (nonatomic,strong) CarModel *tmp_model;

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) NSArray *filterData;

@property (nonatomic,strong) UISearchController *searchController;

@property (nonatomic,strong) NSMutableArray *arr_searchList;

@property (nonatomic,strong) NSMutableArray *arr_dataList;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ShenPiAgreeWithCarDeploy

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    self.title=@"审批意见—同意-派遣车辆";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(NewVc:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barButtonItem2;
    
    UITextView *txt_View=[[UITextView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.55, self.view.frame.size.width, self.view.frame.size.height*0.3)];
    txt_View.backgroundColor=[UIColor whiteColor];
    txt_View.delegate=self;
    
    _tmp_model=[[CarModel alloc]init];
    
    _lbl_tip=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.58, 200, 20)];
    _lbl_tip.text=@"填写意见说明（非必填）";
    _lbl_tip.textColor=[UIColor colorWithRed:116/255.0f green:116/255.0f blue:116/255.0f alpha:1];
    _lbl_tip.textAlignment=NSTextAlignmentLeft;
    _lbl_tip.font=[UIFont systemFontOfSize:13];
    _lbl_tip.backgroundColor=[UIColor clearColor];
    _lbl_tip.enabled=NO;
    
    UILabel *lbl_tabletitle_1=[self createTitleLabel:@"车牌号" x:0];
     UILabel *lbl_tabletitle_2=[self createTitleLabel:@"车型" x:self.view.frame.size.width/4];
     UILabel *lbl_tabletitle_3=[self createTitleLabel:@"颜色" x:self.view.frame.size.width/2];
     UILabel *lbl_tabletitle_4=[self createTitleLabel:@"司机" x:3*self.view.frame.size.width/4];
    self.arr_searchList=[[NSMutableArray alloc]init];
    self.arr_dataList=[[NSMutableArray alloc]init];
    
    self.arr_dataList=[self CreateDataList];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.placeholder=@"请按照车牌号/车型/颜色/司机搜索";
    //self.tableView.tableHeaderView = self.searchController.searchBar;
    
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.18, self.view.frame.size.width, self.view.frame.size.height*0.3) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    
    _tableView.tableHeaderView=self.searchController.searchBar;


    [self.view addSubview:txt_View];
    [self.view addSubview:_lbl_tip];
    [self.view addSubview:_tableView];
    [self.view addSubview:lbl_tabletitle_1];
     [self.view addSubview:lbl_tabletitle_2];
     [self.view addSubview:lbl_tabletitle_3];
     [self.view addSubview:lbl_tabletitle_4];
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)NewVc:(UIButton*)sender {
    ShenPiStatus *tmp_Status=[[ShenPiStatus alloc]init];
    tmp_Status.str_Logo=_user_info.str_Logo;
    tmp_Status.str_name=_user_info.str_name;
    tmp_Status.str_status=@"同意";
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    tmp_Status.str_time=locationString;
    //if (_tmp_model.str_driver!=nil) {
    [_delegate SendAgreeStatus:tmp_Status CarModel:_tmp_model];
    //}
    
    [self.navigationController popViewControllerAnimated:YES];

}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location<500) {
        return YES;
    } else {
        return NO;
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length==0) {
        [_lbl_tip setHidden:NO];
        _lbl_tip.text=@"填写意见说明（非必填）";
    }
    else {
        _lbl_tip.text=@"";
        [_lbl_tip setHidden:YES];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [self.arr_searchList count];
    }
    else {
        return 30;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID=@"CellID";
    CarDeployCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        if (self.searchController.active) {
            CarModel *model=[self.arr_searchList objectAtIndex:indexPath.row];
            cell=[CarDeployCell cellWithTable:UITableViewCellStyleDefault withID:model.str_ID  withBrand:model.str_brand withColor:model.str_color withDriver:model.str_driver];
        }
        else {
            //[self CreateDefaultCell:indexPath];
            CarModel *model=[self.arr_dataList objectAtIndex:indexPath.row];
            cell=[CarDeployCell cellWithTable:UITableViewCellStyleDefault withID:model.str_ID  withBrand:model.str_brand withColor:model.str_color withDriver:model.str_driver];
        }
    }
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(UILabel*)createTitleLabel:(NSString*)str_name x:(CGFloat)x {
    UILabel *tmp_tabletitle=[[UILabel alloc]initWithFrame:CGRectMake(x, self.view.frame.size.height*0.145, self.view.frame.size.width/4, 20)];
    tmp_tabletitle.textColor=[UIColor blackColor];
    tmp_tabletitle.font=[UIFont boldSystemFontOfSize:15];
    tmp_tabletitle.textAlignment=NSTextAlignmentCenter;
    tmp_tabletitle.text=str_name;
    return tmp_tabletitle;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CarDeployCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    _tmp_model.str_ID=cell.lbl_ID.text;
    _tmp_model.str_brand=cell.lbl_Brand.text;
    _tmp_model.str_color=cell.lbl_Color.text;
    _tmp_model.str_driver=cell.lbl_driver.text;
    
    self.searchController.searchBar.text=[NSString stringWithFormat:@"%@  %@  %@  %@",cell.lbl_ID.text,cell.lbl_Brand.text,cell.lbl_Color.text,cell.lbl_driver.text];
    
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (self.arr_searchList!=nil) {
        [self.arr_searchList removeAllObjects];
    }
    //筛选条件
    NSString *searchString=[self.searchController.searchBar text];
    for (int i=0;i<self.arr_dataList.count;i++) {
        CarModel *tmp_Model=[self.arr_dataList objectAtIndex:i];
        if (![tmp_Model.str_ID isEqualToString:searchString] && ![tmp_Model.str_brand isEqualToString:searchString] && ![tmp_Model.str_color isEqualToString:searchString] && ![tmp_Model.str_driver isEqualToString:searchString])
        {}
        else {
            [self.arr_searchList addObject:tmp_Model];
        }
    }
    [_tableView reloadData];
    
}




-(NSMutableArray*)CreateDataList {
    NSMutableArray *arr_tmp=[[NSMutableArray alloc]init];
    for (int i=0;i<30;i++) {
        NSString *str_ID_part;
        if (i<10)
        {
            str_ID_part=[NSString stringWithFormat:@"%@%ld",@"0",(long)i];
        }
        else {
            str_ID_part=[NSString stringWithFormat:@"%ld",(long)i];
        }
        NSString *strID=[NSString stringWithFormat:@"%@%@",@"豫A YYA",str_ID_part];
        if (i%7==0) {
            CarModel *model1=[[CarModel alloc]init];
            model1.str_ID=strID;
            model1.str_brand=@"宝来";
            model1.str_color=@"蓝色";
            model1.str_driver=@"李师傅";
            [arr_tmp addObject:model1];
        }
        else if (i%7==1) {
            CarModel *model2=[[CarModel alloc]init];
            model2.str_ID=strID;
            model2.str_brand=@"别克";
            model2.str_color=@"红色";
            model2.str_driver=@"王师傅";
            [arr_tmp addObject:model2];
        }
        else if (i%7==2) {
            CarModel *model3=[[CarModel alloc]init];
            model3.str_ID=strID;
            model3.str_brand=@"凯美瑞";
            model3.str_color=@"灰色";
            model3.str_driver=@"梁师傅";
            [arr_tmp addObject:model3];
        }
        else if (i%7==3) {
            CarModel *model4=[[CarModel alloc]init];
            model4.str_ID=strID;
            model4.str_brand=@"途观";
            model4.str_color=@"白色";
            model4.str_driver=@"张师傅";
            [arr_tmp addObject:model4];
        }
        else if (i%7==3) {
            CarModel *model4=[[CarModel alloc]init];
            model4.str_ID=strID;
            model4.str_brand=@"途观";
            model4.str_color=@"白色";
            model4.str_driver=@"张师傅";
            [arr_tmp addObject:model4];
        }
        else if (i%7==4) {
            CarModel *model4=[[CarModel alloc]init];
            model4.str_ID=strID;
            model4.str_brand=@"雷克萨斯";
            model4.str_color=@"米色";
            model4.str_driver=@"郭师傅";
            [arr_tmp addObject:model4];
        }
        else if (i%7==5) {
            CarModel *model5=[[CarModel alloc]init];
            model5.str_ID=strID;
            model5.str_brand=@"尚酷";
            model5.str_color=@"绿色";
            model5.str_driver=@"刁师傅";
            [arr_tmp addObject:model5];
        }
        else if (i%7==6) {
            CarModel *model5=[[CarModel alloc]init];
            model5.str_ID=strID;
            model5.str_brand=@"尚酷";
            model5.str_color=@"绿色";
            model5.str_driver=@"刁师傅";
            [arr_tmp addObject:model5];
        }
    }
    return  arr_tmp;
    
}

@end
