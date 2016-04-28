//
//  CarApplication.m
//  unicomOA
//
//  Created by zr-mac on 16/4/8.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "CarApplication.h"
#import "PrintApplicationTitleCell.h"
#import "PrintApplicationDetailCell.h"
#import "TableViewCell.h"
#import "DYCAddress.h"
#import "DYCAddressPickerView.h"
#import "Address.h"
#import "CarUser.h"


@interface CarApplication ()<UITableViewDelegate,UITableViewDataSource,DYCAddressDelegate,DYCAddressPickerViewDelegate,CarUserDelgate>

@property (strong,nonatomic) UITableView *tableview;

@property (strong,nonatomic) NSIndexPath *selectedRowIndexPath;

@end

@implementation CarApplication

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"新建申请";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    

    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(SubmitToPrint:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barButtonItem2;
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];

    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=[UIColor clearColor];
    
     [self.view addSubview:_tableview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SubmitToPrint:(UIButton*)sender {
    PrintApplicationTitleCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
    
    CarService *service=[self getCarService:self.tableview];
    
    if ([cell.textLabel.text isEqualToString:@"用车事由"]) {
        [_delegate PassCarValue:cell.txt_title.text CarObject:service];
    }
    else {
        cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
        if ([cell.textLabel.text isEqualToString:@"用车事由"]) {
            [_delegate PassCarValue:cell.txt_title.text CarObject:service];
        }
    }
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedRowIndexPath) {
        return 13;
    }
    else {
        return 12;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor=[UIColor clearColor];
    CGRect view_title;
    if (iPhone5_5s || iPhone4_4s) {
        view_title=CGRectMake(0, 0, self.view.frame.size.width*0.28, 30);
    }
    else {
        view_title=CGRectMake(0, 0, self.view.frame.size.width*0.2, 30);
    }
    UILabel *lbl_sectionTitle=[[UILabel alloc]initWithFrame:view_title];
    lbl_sectionTitle.textAlignment=NSTextAlignmentLeft;
    lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
    lbl_sectionTitle.text=@"基本信息";
    
    [view addSubview:lbl_sectionTitle];
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isExtendedCellIndexPath:indexPath] ) {
        return 180;
    }
    else if (indexPath.row!=11) {
        return 40;
    }
    else if (indexPath.row==11 && [self isExtendedCellIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]]) {
        return  40;
    }
    else if (indexPath.row==11 && [self isExtendedCellIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]]) {
        return  40;
    }
    else if (indexPath.row==11 && [self isExtendedCellIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]]) {
        return  40;
    }
    else {
        return 180;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID=[NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }

    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.detailTextLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
    
    if ([self isExtendedCellIndexPath:indexPath])
    {
        NSString *identifier = [TableViewCell reusableIdentifier];
        TableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]objectAtIndex:0];
        if (indexPath.row==8 || indexPath.row==9) {
            [cell addcontentView:[self viewForContainerAtIndexPath:indexPath isDate:YES]];
        }
        else {
            [cell addcontentView:[self viewForContainerAtIndexPath:indexPath isDate:NO]];
        }
        
        return cell;
    }

#pragma mark 以上行不因添加而改变
    if (indexPath.row==0) {
        cell.textLabel.text=@"申请流程";
        cell.detailTextLabel.text=@"用车申请";
        cell.detailTextLabel.textColor=[UIColor blackColor];
    }
    else if (indexPath.row==1) {
        cell.textLabel.text=@"申请人";
        cell.detailTextLabel.text=_userInfo.str_name;
    }
    else if (indexPath.row==2) {
        cell.textLabel.text=@"所在部门";
        cell.detailTextLabel.text=_userInfo.str_department;
    }
    else if (indexPath.row==3) {
        cell.textLabel.text=@"联系电话";
        cell.detailTextLabel.text=_userInfo.str_cellphone;
    }
    else if (indexPath.row==4) {
        cell.textLabel.text=@"用车类别";
        cell.detailTextLabel.text=@"临时用车";
    }
    else if (indexPath.row==5) {
        // textfield
        PrintApplicationTitleCell *cell=[PrintApplicationTitleCell cellWithTable:tableView withName:@"用车人数" withPlaceHolder:@"填写用车人数" atIndexPath:indexPath keyboardType:UIKeyboardTypeNumberPad];
        return cell;
        
    }
    else if (indexPath.row==6) {
        cell.textLabel.text=@"使用人";
        cell.detailTextLabel.text=@"选择使用人";
    }
    else if (indexPath.row==7) {
        cell.textLabel.text=@"用车时间";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        cell.detailTextLabel.text=strDate;
    }

#pragma  mark 以下行随添加而改变
    
    else if (indexPath.row ==8) {
            cell.textLabel.text=@"返程时间";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
            cell.detailTextLabel.text=strDate;
    }
    else if (indexPath.row==9) {
        if ([self isExtendedCellIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]]) {
            cell.textLabel.text=@"返程时间";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
            cell.detailTextLabel.text=strDate;
        }
        else {
            cell.textLabel.text=@"目的地";
            cell.detailTextLabel.text=@"郑州";
        }
    }
    else if (indexPath.row==10) {
        if ([self isExtendedCellIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]] || [self isExtendedCellIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]]) {
            cell.textLabel.text=@"目的地";
            cell.detailTextLabel.text=@"郑州";
        }
        else {
            // textfield
            PrintApplicationTitleCell *cell=[PrintApplicationTitleCell cellWithTable:tableView withName:@"用车事由" withPlaceHolder:@"填写用车事由" atIndexPath:indexPath keyboardType:UIKeyboardTypeDefault];
            return cell;
        }
        
    }
    else if (indexPath.row==11) {
        if ([self isExtendedCellIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]] || [self isExtendedCellIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]] || [self isExtendedCellIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]]) {
            PrintApplicationTitleCell *cell=[PrintApplicationTitleCell cellWithTable:tableView withName:@"用车事由" withPlaceHolder:@"填写用车事由" atIndexPath:indexPath keyboardType:UIKeyboardTypeDefault];
            return cell;
        }
        else {
            //textView
            PrintApplicationDetailCell *cell=[PrintApplicationDetailCell cellWithTable:tableView withName:@"备注信息" withPlaceHolder:@"请输入备注信息" atIndexPath:indexPath];
            return cell;
            
        }
    }
       else {
        PrintApplicationDetailCell *cell=[PrintApplicationDetailCell cellWithTable:tableView withName:@"备注信息" withPlaceHolder:@"请输入备注信息" atIndexPath:indexPath];
        return cell;
    }
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self isExtendedCellIndexPath:indexPath]) {
        if (indexPath.row==7 || indexPath.row==8 || indexPath.row==9 || indexPath.row==10) {
            [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
            [self extendCellAtIndexPath:indexPath];
        }
    }
    
    if (indexPath.row==6) {
        CarUser *viewController=[[CarUser alloc]init];
        viewController.delegate=self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

#pragma mark  点击时间后下拉扩展cell事件

-(void)extendCellAtIndexPath:(NSIndexPath *)indexPath
{
        [self.tableview beginUpdates];
        
        if (self.selectedRowIndexPath) {
            if ([self isSelectedRowIndexPath:indexPath]) {
                NSIndexPath *tempIndexPath=self.selectedRowIndexPath;
                self.selectedRowIndexPath=nil;
                [self removeCellBelowIndexPath:tempIndexPath];
            }
            else if ([self isExtendedCellIndexPath:indexPath]);
            else {
                NSIndexPath *tempIndexPath=self.selectedRowIndexPath;
                if (indexPath.row>self.selectedRowIndexPath.row && indexPath.section==self.selectedRowIndexPath.section) {
                    indexPath=[NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
                }
                self.selectedRowIndexPath=indexPath;
                [self removeCellBelowIndexPath:tempIndexPath];
                [self insertCellBelowIndexPath:indexPath];
                
            }
            
        }
        else {
            self.selectedRowIndexPath=indexPath;
            [self insertCellBelowIndexPath:indexPath];
        }
        
        [self.tableview endUpdates];
        [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
}

-(void)insertCellBelowIndexPath:(NSIndexPath *)indexPath
{
    indexPath=[NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSArray *pathsArray=@[indexPath];
    [self.tableview insertRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}

-(void)removeCellBelowIndexPath:(NSIndexPath *)indexPath
{
    indexPath =[NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSArray *pathsArray=@[indexPath];
    [self.tableview deleteRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}

-(void)setSelectedRowIndexPath:(NSIndexPath *)selectedRowIndexPath {
    _selectedRowIndexPath=selectedRowIndexPath;
}

-(BOOL)isExtendedCellIndexPath:(NSIndexPath *)indexPath {
    if (indexPath && self.selectedRowIndexPath) {
        if (indexPath.row==self.selectedRowIndexPath.row+1 && indexPath.section==self.selectedRowIndexPath.section) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isSelectedRowIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath && self.selectedRowIndexPath) {
        if (indexPath.row==self.selectedRowIndexPath.row && indexPath.section ==self.selectedRowIndexPath.section) {
            return YES;
        }
    }
    return NO;
}

//判断是添加日期PickerView还是地市PickerView
-(UIView*)viewForContainerAtIndexPath:(NSIndexPath *)indexPath isDate:(BOOL)b_IsDate{
    if ([self isExtendedCellIndexPath:indexPath]) {
        if (b_IsDate==YES) {
            UIDatePicker *datePicker=[[UIDatePicker alloc]init];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            // [datePicker setLocale:[NSLocale alloc]:@"zh_Hans_CN"];
            [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            [datePicker setTag:indexPath.row];
            UIView *dropDownView=datePicker;
            
            return dropDownView;
        }
        else {
            DYCAddress *address = [[DYCAddress alloc] init];
            address.dataDelegate = self;
            [address handlerAddress];
            DYCAddressPickerView *pickerView = [[DYCAddressPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180) withAddressArray:address.array];
            pickerView.DYCDelegate = self;
            pickerView.backgroundColor = [UIColor clearColor];
            UIView *dropDownView=pickerView;
            return dropDownView;
        }
       
    }
    else {
        return nil;
    }
}

#pragma 日期
-(void)dateChanged:(UIDatePicker*)sender  {
    NSDate *date=sender.date;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString=[dateFormatter stringFromDate:date];
    UITableViewCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    UILabel *lbl_date=cell.detailTextLabel;
    lbl_date.text=dateString;
    lbl_date.textColor=[UIColor blackColor];
}


-(void)addressList:(NSArray *)array {
    /*
    DYCAddressPickerView *pickerView = [[DYCAddressPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180) withAddressArray:array];
    pickerView.DYCDelegate = self;
    pickerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:pickerView];
     */
}

-(void)selectAddressProvince:(Address *)province andCity:(Address *)city andCounty:(Address *)county {
    UITableViewCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@ %@",province.name,city.name,county.name];
    cell.detailTextLabel.textColor=[UIColor blackColor];
    /*
    [_province setText:province.name];
    [_city setText:city.name];
    [_county setText:county.name];
     */
    
}

-(void)CarUserName:(NSString *)str_name {
    UITableViewCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    cell.detailTextLabel.text=str_name;
    cell.detailTextLabel.textColor=[UIColor blackColor];
}

-(CarService*)getCarService:(UITableView*)tableView {
    CarService *tmp_carservice=[[CarService alloc]init];
    //申请人
    UITableViewCell *cell_name=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    tmp_carservice.str_name=cell_name.detailTextLabel.text;
    //所在部门
    UITableViewCell *cell_department=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    tmp_carservice.str_department=cell_department.detailTextLabel.text;
    //联系电话
    UITableViewCell *cell_phonenum=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    tmp_carservice.str_phonenum=cell_phonenum.detailTextLabel.text;
    //用车类别
    UITableViewCell *cell_categroy=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    tmp_carservice.str_categroy=cell_categroy.detailTextLabel.text;
    //用车人数
    PrintApplicationTitleCell *cell_usernum=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    tmp_carservice.i_usernum=[cell_usernum.txt_title.text intValue];
    //使用人
    UITableViewCell *cell_username=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    tmp_carservice.str_usrname=cell_username.detailTextLabel.text;
    //用车时间
    UITableViewCell *cell_usingtime=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    tmp_carservice.str_usingtime=cell_usingtime.detailTextLabel.text;
    //返回时间
    UITableViewCell *cell_returnTime=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    if ([cell_returnTime.textLabel.text isEqualToString:@"返程时间"]) {
        tmp_carservice.str_returntime=cell_returnTime.detailTextLabel.text;
    }
    UITableViewCell *cell_9=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    if ([cell_9.textLabel.text isEqualToString:@"目的地"]) {
            tmp_carservice.str_destination=cell_9.detailTextLabel.text;
    }
    else if ([cell_9.textLabel.text isEqualToString:@"返程时间"]) {
         tmp_carservice.str_returntime=cell_9.detailTextLabel.text;
    }
    UITableViewCell *cell_10=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
    if ([cell_10.textLabel.text isEqualToString:@"用车事由"]) {
        PrintApplicationTitleCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
        tmp_carservice.str_reason=cell.txt_title.text;
    }
    else if ([cell_10.textLabel.text isEqualToString:@"目的地"]) {
        tmp_carservice.str_destination=cell_10.detailTextLabel.text;
    }
    UITableViewCell *cell_11=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
    if ([cell_11.textLabel.text isEqualToString:@"备注信息"]) {
        PrintApplicationDetailCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
        tmp_carservice.str_remark=cell.txt_detail.text;
    }
    else if ([cell_11.textLabel.text isEqualToString:@"用车事由"]) {
        PrintApplicationTitleCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
        tmp_carservice.str_reason=cell.txt_title.text;
        PrintApplicationDetailCell *cell_2=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];
        tmp_carservice.str_remark=cell_2.txt_detail.text;
    }
    
    //申请时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    tmp_carservice.str_applicationTime=locationString;

    return tmp_carservice;
    
    
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
