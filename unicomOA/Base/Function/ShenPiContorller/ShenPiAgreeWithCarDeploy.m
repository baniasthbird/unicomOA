//
//  ShenPiAgreeWithCarDeploy.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ShenPiAgreeWithCarDeploy.h"
#import "CarDeployCell.h"


@interface ShenPiAgreeWithCarDeploy()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel *lbl_tip;

@property (nonatomic,strong) CarModel *tmp_model;

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) NSArray *filterData;

@property (nonatomic,strong) UISearchController *serachController;

@property (nonatomic,strong) UISearchBar *searchBar;

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
    
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.18-44,self.view.frame.size.width , 44)];
    _searchBar.placeholder=@"请按照车牌号/车型/颜色/司机搜索";
    
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.18, self.view.frame.size.width, self.view.frame.size.height*0.3) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor whiteColor];
    
    tableView.tableHeaderView=_searchBar;


    [self.view addSubview:txt_View];
    [self.view addSubview:_lbl_tip];
    [self.view addSubview:tableView];
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
    if (_tmp_model.str_driver!=nil) {
        [_delegate SendAgreeStatus:tmp_Status CarModel:_tmp_model];
    }
    
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
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID=@"CellID";
    CarDeployCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        NSString *str_ID_part;
        if (indexPath.row<10) {
            str_ID_part=[NSString stringWithFormat:@"%@%ld",@"0",(long)indexPath.row];
        }
        else
            str_ID_part=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSString *strID=[NSString stringWithFormat:@"%@%@",@"豫A YYA",str_ID_part];
        
        if (indexPath.row%7==0)
        {
            cell=[CarDeployCell cellWithTable:UITableViewCellStyleDefault withID:strID withBrand:@"宝来" withColor:@"蓝色" withDriver:@"李师傅"];
        }
        else if (indexPath.row%7==1) {
              cell=[CarDeployCell cellWithTable:UITableViewCellStyleDefault withID:strID withBrand:@"别克" withColor:@"红色" withDriver:@"王师傅"];
        }
        else if (indexPath.row%7==2) {
              cell=[CarDeployCell cellWithTable:UITableViewCellStyleDefault withID:strID withBrand:@"凯美瑞" withColor:@"灰色" withDriver:@"梁师傅"];
        }
        else if (indexPath.row%7==3) {
              cell=[CarDeployCell cellWithTable:UITableViewCellStyleDefault withID:strID withBrand:@"途观" withColor:@"白色" withDriver:@"张师傅"];
        }
        else if (indexPath.row%7==4) {
              cell=[CarDeployCell cellWithTable:UITableViewCellStyleDefault withID:strID withBrand:@"雷克萨斯" withColor:@"米色" withDriver:@"郭师傅"];
        }
        else if (indexPath.row%7==5) {
              cell=[CarDeployCell cellWithTable:UITableViewCellStyleDefault withID:strID withBrand:@"尚酷" withColor:@"绿色" withDriver:@"刁师傅"];
        }
        else if (indexPath.row%7==6) {
              cell=[CarDeployCell cellWithTable:UITableViewCellStyleDefault withID:strID withBrand:@"奥迪" withColor:@"黑色" withDriver:@"宋师傅"];
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
    
    _searchBar.text=[NSString stringWithFormat:@"%@  %@  %@  %@",cell.lbl_ID.text,cell.lbl_Brand.text,cell.lbl_Color.text,cell.lbl_driver.text];
    
}

@end
