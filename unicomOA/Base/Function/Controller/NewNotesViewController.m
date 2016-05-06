//
//  NewNotesViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewNotesViewController.h"
#import "NotesViewController.h"
#import "MenuItemModel.h"
#import "CellModel.h"
#import "MenuTableViewCell.h"
#import "UserEntity.h"
#import "TableViewCell.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "LZActionSheet.h"
#import "MapViewController.h"


#define TABLEVIEW_CELL_RESUSE_ID @"TABLEVIEW_CELL_REUSE_ID"

typedef enum
{
    DateArrangeMent=0,
    WorkingNotes,
    TourismPlan,
    MeetingArrangement,
    DiningService
}OperationType;

@interface NewNotesViewController()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,MenuTableViewCellDelegate,MenutableViewCellDataSource,LZActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MapViewControllerDelegate>
    
//列表
@property (strong,nonatomic) UITableView *tableView;

//已经打开下拉菜单的单元格
@property (strong,nonatomic) MenuTableViewCell *openedMenuCell;

//已经打开下拉菜单的单元格的位置
@property (strong,nonatomic) NSIndexPath *openedMenuCellIndex;

//列表数据源
@property (strong,nonatomic) NSMutableArray *dataSourceArray;

//下拉菜单数据源
@property (strong,nonatomic) NSMutableArray *menuItemDataSourceArray;

@property (strong,nonatomic) NSIndexPath *selectedRowIndexPath;

//是否开启下拉菜单
@property BOOL b_isOpenMenu;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSDate *date_select;

@property (nonatomic,strong) NSString *str_date;

@property (nonatomic,strong) NSString *str_notesFenLei;

@property (nonatomic,strong) NSString *str_location_content;

@property (nonatomic,strong) UIImageView *image;

//位置坐标
@property  CLLocationCoordinate2D coord_placemark;

//位置地址
@property (nonatomic,strong) CLPlacemark *addr_placemark;

@end

@implementation NewNotesViewController {
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}

@synthesize delegate;


-(void)viewDidLoad {
    self.title=@"新建备忘录";
    
    UIButton *btn_Finish=[[UIButton alloc]initWithFrame:CGRectMake(0,0, 40, 40)];
    [btn_Finish setTitle:@"完成" forState:UIControlStateNormal];
    [btn_Finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_Finish addTarget:self action:@selector(FinishNotes:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_Finish];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    //[barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    [self buildDataSource];
    [self buildView];
    
    returnKeyHandler=[[IQKeyboardReturnKeyHandler alloc]initWithViewController:self];
    [returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
    
    _b_isOpenMenu=NO;
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(ChangeCountDownLabels:) userInfo:nil repeats:YES];
    
    [_timer fire];
}




-(void)FinishNotes:(UIButton*)sender {
    
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormatter stringFromDate:date];
    
    [delegate passValue:_str_notesFenLei Content:_str_noteContent Time:_str_date TimeNow:dateString];
    
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)buildDataSource {
    //构建单元格下拉列表数据源
    self.menuItemDataSourceArray=[NSMutableArray arrayWithCapacity:0];
    MenuItemModel *favItemModel=[[MenuItemModel alloc] initWithNormalImageName:@"calendar" withHighLightedImageName:@"calendar" withItemText:@"日程安排"];
    [self.menuItemDataSourceArray addObject:favItemModel];
    
    MenuItemModel *albItemModel=[[MenuItemModel alloc]initWithNormalImageName:@"notes" withHighLightedImageName:@"notes" withItemText:@"工作笔记"];
    [self.menuItemDataSourceArray addObject:albItemModel];
    
    MenuItemModel *dldItemModel=[[MenuItemModel alloc] initWithNormalImageName:@"travel" withHighLightedImageName:@"travel" withItemText:@"差旅安排"];
    [self.menuItemDataSourceArray addObject:dldItemModel];
    
    MenuItemModel *artistItemModel=[[MenuItemModel alloc]initWithNormalImageName:@"meeting" withHighLightedImageName:@"meeting" withItemText:@"会议记录"];
    [self.menuItemDataSourceArray addObject:artistItemModel];
    
    MenuItemModel *dltItemModel=[[MenuItemModel alloc]initWithNormalImageName:@"dinner" withHighLightedImageName:@"dinner" withItemText:@"宴会安排"];
    [self.menuItemDataSourceArray addObject:dltItemModel];
    
    //构建列表数据源
    self.dataSourceArray=[NSMutableArray arrayWithCapacity:0];
    for (int index=0; index<10; index++) {
        CellModel *cellModel=[[CellModel alloc]initWithImageName:@"foxgirl.jpg" labelText:@""];
        [self.dataSourceArray addObject:cellModel];
    }
    
}

//搭建界面
-(void)buildView {
    //列表
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -110, self.view.frame.size.width, self.view.frame.size.height+110) style:UITableViewStylePlain];
   // [self.tableView setSeparatorColor:[UIColor blueColor]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:TABLEVIEW_CELL_RESUSE_ID];
    
    [self.view addSubview:self.tableView];
    
    UIView *tableFootView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView=tableFootView;
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else if (range.location>=500) {
        return NO;
    }
    //_str_noteContent=text;
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedRowIndexPath) {
        return 10;
    }
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        MenuTableViewCell *menuCell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TABLEVIEW_CELL_RESUSE_ID forIndexPath:indexPath];
       // MenuTableViewCell *menuCell = [MenuTableViewCell cellWithTable:tableView atIndexPath:indexPath];
       
       
        menuCell.delegate = self;
        menuCell.dataSource = self;
        menuCell.moreBtn.tag = indexPath.row;
        //需要手动绘制下拉菜单视图，通过xib创建视图的时候cell的delegate和dataSource尚未确定
        [menuCell buildMenuView];
        if (indexPath.row < [self.dataSourceArray count] && self.str_FenLei!=nil) {
            CellModel *cellModel = [self.dataSourceArray objectAtIndex:indexPath.row];
            menuCell.headImageView.image = [UIImage imageNamed:cellModel.imageName];
            menuCell.indexPathLabel.text=self.str_FenLei;
        }
        if (indexPath.row < [self.dataSourceArray count] && self.str_FenLei==nil)
        {
            CellModel *cellModel = [self.dataSourceArray objectAtIndex:indexPath.row];
            menuCell.headImageView.image = [UIImage imageNamed:cellModel.imageName];
            menuCell.indexPathLabel.text = cellModel.labelText;
        }
        
        return menuCell;
    }
    else if (indexPath.row==1) {
        
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UITextView *textView=nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.textLabel.text=@"备忘录记录";
            textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, cell.frame.size.height)];
            [textView setTextColor:[UIColor blackColor]];
            [textView setFont:[UIFont systemFontOfSize:12.0f]];
            [textView setBackgroundColor:[UIColor clearColor]];
            textView.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            textView.hidden=NO;
           // textView.layer.borderColor=[[UIColor colorWithRed:230.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]CGColor];
           // textView.layer.borderWidth=3.0;
           // textView.layer.cornerRadius=8.0f;
           // [textView.layer setMasksToBounds:YES];
            textView.delegate=self;
            [textView setTag:1];
            if (self.str_noteContent==nil) {
                [textView setText:@"  请输入内容"];
            }
            else {
                textView.text=self.str_noteContent;
            }
            
            [textView setEditable:YES];
            [[cell contentView]addSubview:textView];
            
        }
        
         return cell;
       
    }
    else if (indexPath.row==2) {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        CGRect imageFrame=CGRectMake(10, 10, 80, 80);
        _image=[[UIImageView alloc]initWithFrame:imageFrame];
        _image.layer.borderWidth=1;
        _image.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        //[image setImage:[UIImage imageNamed:@"me.png"]];
        //[image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(@"chooseImage:")];
        //cell.textLabel.text=@"今后更新用于地图开发";
        _image.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressed:)];
        [_image addGestureRecognizer:singleTap1];
        [[cell contentView] addSubview:_image];
        
         return cell;
        
    }
    else if (indexPath.row==3) {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
        UIImageView *img_positon=[[UIImageView alloc]initWithFrame:CGRectMake(cell.contentView.frame.origin.x+10, cell.contentView.frame.origin.y+50, 44, 44)];
        img_positon.image=[UIImage imageNamed:@"position.png"];
        UILabel *lbl_text=[[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.origin.x+80,cell.contentView.frame.origin.y-3 , self.view.frame.size.width-80, 140)];
        lbl_text.text=@"位置信息";
        lbl_text.font=[UIFont systemFontOfSize:18];
        
        [[cell contentView] addSubview:img_positon];
        [[cell contentView] addSubview:lbl_text];
         return cell;

    }
    else if (indexPath.row==4) {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIImageView *img_alarm=[[UIImageView alloc]initWithFrame:CGRectMake(cell.contentView.frame.origin.x+10, cell.contentView.frame.origin.y+5, 44, 44)];
        img_alarm.image=[UIImage imageNamed:@"alarm.png"];
        UILabel *lbl_text=[[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.origin.x+80,cell.contentView.frame.origin.y-3 , 100, 60)];
        lbl_text.text=@"设置提醒";
        lbl_text.font=[UIFont systemFontOfSize:18];
       // cell.textLabel.text=@"设置提醒";
        UISwitch *sw_alarm=[[UISwitch alloc]initWithFrame:CGRectMake(120, 15, 50, 50)];
        
        
        [sw_alarm setOn:NO animated:NO];
        [sw_alarm addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        //[cell addSubview:sw_alarm];
        cell.accessoryView=sw_alarm;
        [[cell contentView] addSubview:img_alarm];
        [[cell contentView] addSubview:lbl_text];
        
         return cell;
       
    }
    else if (indexPath.row==5) {

        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text=@"重复";
            cell.detailTextLabel.textColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
            cell.detailTextLabel.text=@"只响一次";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;

    }
    else if (indexPath.row==6) {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text=@"铃声";
            cell.detailTextLabel.textColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
            cell.detailTextLabel.text=@"默认铃声";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
    else if (indexPath.row==7) {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text=@"振动";
            cell.detailTextLabel.textColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
            cell.detailTextLabel.text=@"响铃时振动";
            UISwitch *sw_alarm=[[UISwitch alloc]initWithFrame:CGRectMake(120, 15, 50, 50)];
            
            
            [sw_alarm setOn:NO animated:NO];
            [sw_alarm addTarget:self action:@selector(vibration) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView=sw_alarm;
        

        }
        
        return cell;
    }
    else if (indexPath.row==8) {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *lbl_count_down=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
            lbl_count_down.textAlignment=NSTextAlignmentCenter;
            lbl_count_down.font=[UIFont systemFontOfSize:20];
            if (_str_date==nil) {
                _str_date=@"0分后响铃";
            }
            lbl_count_down.text=_str_date;
            [[cell contentView] addSubview:lbl_count_down];
        }
        
        
        return cell;
    }
    else if (indexPath.row==9) {
        /*
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *lbl_count_down=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
            lbl_count_down.textAlignment=NSTextAlignmentCenter;
            lbl_count_down.font=[UIFont systemFontOfSize:20];
            lbl_count_down.text=@"2小时32分后响铃";
            [[cell contentView] addSubview:lbl_count_down];
        }

        return cell;
         */
        NSString *identifier = [TableViewCell reusableIdentifier];
        TableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]objectAtIndex:0];
        [cell addcontentView:[self viewForContainerAtIndexPath:indexPath]];
        return cell;
    }
    else {
       
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
      return cell;
    }
    
}

-(void)textViewDidChange:(UITextView *)textView {
    self.str_noteContent=textView.text;
}


- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    if (switchControl.on==YES) {
        _b_isOpenMenu=YES;
    }
    else {
        _b_isOpenMenu=NO;
    }
    [self extendCellAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.openedMenuCell != nil)&&
        (self.openedMenuCell.isOpenMenu = YES)&&
        (self.openedMenuCellIndex.row == indexPath.row))
    {
        return 114.0;
    }else if (indexPath.row==1)
    {
        return 160;
    }
    else if (indexPath.row==2 || indexPath.row==8)
    {
        return 100;
    }
    else if (indexPath.row==9) {
        return 240;
    }
    else if (indexPath.row==3)
    {
        return 162;
    }
    else {
        return 54.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 110;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==3 && indexPath.section==0) {
        MapViewController *viewController=[[MapViewController alloc]init];
        viewController.userInfo=_usrInfo;
        viewController.delegate=self;
        if (_addr_placemark!=nil && _coord_placemark.longitude!=0 && _coord_placemark.latitude!=0) {
            viewController.placemark=_addr_placemark;
            viewController.touchMapCoord=_coord_placemark;
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if (indexPath.row==4 && indexPath.section==0) {
        [self extendCellAtIndexPath:indexPath];
    }
    /*
    if (indexPath.row!=3) {
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[FullTimeView class]]) {
                [view removeFromSuperview];
            }
        }
    }
     */
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [_timer invalidate];
}

#pragma mark -MenutableViewCellDataSource
-(NSMutableArray *)dataSourceForMenuItem {
    return self.menuItemDataSourceArray;
}

#pragma mark -MenuTableVieCellDelegate 

-(void)didOpenMenuAtCell:(MenuTableViewCell *)menuTableViewCell withMoreButton:(UIButton *)moreButton {
    NSIndexPath *openedIndexPath=[NSIndexPath indexPathForRow:moreButton.tag inSection:0];
    
    if ((self.openedMenuCell!=nil) && (self.openedMenuCell.isOpenMenu==YES) && (self.openedMenuCellIndex.row==openedIndexPath.row)) {
        //如果点的是同一个cell关闭下拉菜单并且不刷新新的cell
        self.openedMenuCell = nil;
        [self.tableView reloadRowsAtIndexPaths:@[self.openedMenuCellIndex] withRowAnimation:UITableViewRowAnimationFade];
        MenuTableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.indexPathLabel.text=menuTableViewCell.indexPathLabel.text;
        self.openedMenuCellIndex=nil;
        return;
    }
    
    //刷新新的cell
    self.openedMenuCell=menuTableViewCell;
    self.openedMenuCellIndex=openedIndexPath;
    [self.tableView reloadRowsAtIndexPaths:@[self.openedMenuCellIndex] withRowAnimation:UITableViewRowAnimationFade];
    MenuTableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.indexPathLabel.text=menuTableViewCell.indexPathLabel.text;
    [self.tableView scrollToRowAtIndexPath:self.openedMenuCellIndex atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

-(void)menuTableViewCell:(MenuTableViewCell *)menuTableViewCell didSeletedMentItemAtIndex:(NSInteger)menuItemIndex
{
    //首先关闭打开的下拉菜单
    /*
    if ((self.openedMenuCell!=nil)&& (self.openedMenuCell.isOpenMenu==YES) && (self.openedMenuCellIndex.row == menuTableViewCell.moreBtn.tag)) {
        //如果点的是同一个CELL关闭下拉菜单并且不刷新新的cell
        self.openedMenuCell=nil;
        [self.tableView reloadRowsAtIndexPaths:@[self.openedMenuCellIndex] withRowAnimation:UITableViewRowAnimationFade];
        self.openedMenuCellIndex=nil;
    }
     */
    
    switch (menuItemIndex) {
        case DateArrangeMent:
            menuTableViewCell.indexPathLabel.text=@"日程安排";
            _str_notesFenLei=menuTableViewCell.indexPathLabel.text;
            break;
        case WorkingNotes:
            menuTableViewCell.indexPathLabel.text=@"工作笔记";
            _str_notesFenLei=menuTableViewCell.indexPathLabel.text;
            break;
        case TourismPlan:
            menuTableViewCell.indexPathLabel.text=@"差旅安排";
            _str_notesFenLei=menuTableViewCell.indexPathLabel.text;
            break;
        case MeetingArrangement:
            menuTableViewCell.indexPathLabel.text=@"会议记录";
            _str_notesFenLei=menuTableViewCell.indexPathLabel.text;
            break;
        case DiningService:
            menuTableViewCell.indexPathLabel.text=@"宴会安排";
            _str_notesFenLei=menuTableViewCell.indexPathLabel.text;
            break;
        default:
            break;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请输入内容"]) {
        textView.text=@"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text=@"请输入内容";
    }
}



-(UIView*)viewForContainerAtIndexPath:(NSIndexPath *)indexPath {
    //if ([self isExtendedCellIndexPath:indexPath]) {
    UIDatePicker *datePicker=[[UIDatePicker alloc]init];
    datePicker.minimumDate=[NSDate date];
    datePicker.maximumDate=[[NSDate alloc]initWithTimeIntervalSinceNow:1000000000];
    if (_date_select!=nil) {
        datePicker.date=_date_select;
    }
       // [datePicker setLocale:[NSLocale alloc]:@"zh_Hans_CN"];
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    UIView *dropDownView=datePicker;
        
    return dropDownView;
  //  }
   // else {
   //     return nil;
   // }
}

//点击时间后下拉扩展cell事件
-(void)extendCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==4 && indexPath.section==0) {
        [self.tableView beginUpdates];
        
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
        
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

-(void)insertCellBelowIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* indexPath1=[NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSIndexPath* indexPath2=[NSIndexPath indexPathForRow:(indexPath.row+2) inSection:indexPath.section];
    NSIndexPath* indexPath3=[NSIndexPath indexPathForRow:(indexPath.row+3) inSection:indexPath.section];
    NSIndexPath* indexPath4=[NSIndexPath indexPathForRow:(indexPath.row+4) inSection:indexPath.section];
    NSIndexPath* indexPath5=[NSIndexPath indexPathForRow:(indexPath.row+5) inSection:indexPath.section];
    NSArray *pathsArray=@[indexPath1,indexPath2,indexPath3,indexPath4,indexPath5];
    [self.tableView insertRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}

-(void)removeCellBelowIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *indexPath1 =[NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSIndexPath *indexPath2 =[NSIndexPath indexPathForRow:(indexPath.row+2) inSection:indexPath.section];
    NSIndexPath *indexPath3 =[NSIndexPath indexPathForRow:(indexPath.row+3) inSection:indexPath.section];
    NSIndexPath *indexPath4 =[NSIndexPath indexPathForRow:(indexPath.row+4) inSection:indexPath.section];
    NSIndexPath *indexPath5 =[NSIndexPath indexPathForRow:(indexPath.row+5) inSection:indexPath.section];
    NSArray *pathsArray=@[indexPath1,indexPath2,indexPath3,indexPath4,indexPath5];
    [self.tableView deleteRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
    
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

#pragma 日期
-(void)dateChanged:(UIDatePicker*)sender {
    _date_select=sender.date;
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:8 inSection:0]];
    UILabel *lbl_date=cell.subviews[0].subviews[0];
    _str_date=[self CalcuDateStr:_date_select];
    lbl_date.text=_str_date;
    lbl_date.textColor=[UIColor blackColor];
}


-(NSString*)CalcuDateStr:(NSDate*)date {
    NSDate *date_now=[NSDate date];
    NSTimeInterval secondsInterval=[date timeIntervalSinceDate:date_now];
    NSInteger minutesInterval=(NSInteger)secondsInterval/60;
    NSInteger hourInterval=0;
    NSInteger dayInterval=0;
    if (minutesInterval>60) {
        hourInterval=minutesInterval/60;
        minutesInterval=minutesInterval-60*hourInterval;
    }
    if (hourInterval>24) {
        dayInterval=hourInterval/24;
        hourInterval=hourInterval-dayInterval*24;
    }
    /*
     NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSString *dateString=[dateFormatter stringFromDate:date];
     */
    NSString *dateString=@"";
    if (hourInterval==0 && dayInterval==0) {
        dateString=[NSString stringWithFormat:@"%ld%@",(long)minutesInterval,@"分后响铃"];
    }
    else if (dayInterval==0) {
        dateString=[NSString stringWithFormat:@"%ld%@%ld%@",(long)hourInterval,@"小时",(long)minutesInterval,@"分后响铃"];
    }
    else {
        dateString=[NSString stringWithFormat:@"%ld%@%ld%@%ld%@",(long)dayInterval,@"天",(long)hourInterval,@"小时",(long)minutesInterval,@"分后响铃"];
    }

    return dateString;
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buttonPressed:(UITapGestureRecognizer *)gestrueRecognizer {
   // LZActionSheet *sheet=[LZActionSheet showActionSheetWithDelegate:self cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍照",@"从相册中选择"] ];
    UIColor *other_color=[UIColor colorWithRed:81/255.0f green:127/255.0f blue:238/255.0f alpha:1];
    UIColor *cancel_color=[UIColor colorWithRed:246/255.0f green:88/255.0f blue:87/255.0f alpha:1];
    LZActionSheet *sheet=[LZActionSheet showActionSheetWithDelegate:self cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍照",@"从相册中选择"] cancelButtonColor:cancel_color otherButtonColor:other_color];
    [sheet show];
    NSLog(@"已点击图片");
}

//照片选择
-(void)LZActionSheet:(LZActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)index {
    switch (index) {
        case 0: {
             UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
            imagePickerController.delegate=self;
            imagePickerController.allowsEditing=YES;
            imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }
           
            
            break;
        case 1: {
            UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
            imagePickerController.delegate=self;
            imagePickerController.allowsEditing=YES;
            imagePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];

            
        }
           

            break;
        default:
            break;
    }
}

//振动提醒
-(void)vibration {
    
}




-(void) ChangeCountDownLabels:(NSTimer*)timer {
    if (_date_select!=nil) {
         _str_date=[self CalcuDateStr:_date_select];
    }
    if ([self.tableView numberOfRowsInSection:0]==10) {
        TableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
        UIDatePicker *picker=cell.subviews[0].subviews[1];
        [picker setMinimumDate:[NSDate date]];
        [picker setMaximumDate:[[NSDate alloc]initWithTimeIntervalSinceNow:1000000000]];
        
        
        UITableViewCell *cell2=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
        UILabel *lbl_date=cell2.subviews[0].subviews[0];
        lbl_date.text=_str_date;
        
       // [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:9 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}


//拍照完成或选择头像完成后的事件
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    //保存图片至本地
    [self saveImage:image withName:@"demo.png"];
    
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"demo.png"];
    
    UIImage *saveImage=[[UIImage alloc]initWithContentsOfFile:fullPath];
    
    [_image setImage:saveImage];
}


-(void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    NSData *imageData=UIImageJPEGRepresentation(currentImage, 1);  //1为不缩放保存
    //获取沙盒目录
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
}


-(void)PassMapValue:(CLPlacemark *)placemark Coordinate:(CLLocationCoordinate2D)touchmapcoord {
    _coord_placemark=touchmapcoord;
    _addr_placemark=placemark;
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UIView *subview=[cell.subviews objectAtIndex:0];
    UIView *sub_subview= [subview.subviews objectAtIndex:1];
    UILabel *lbl_sub_subview=(UILabel*)sub_subview;
    NSString *str_state=placemark.administrativeArea;
    NSString *str_city=placemark.locality;
    NSString *str_county=placemark.subLocality;
    NSString *str_street=placemark.thoroughfare;
    NSString *str_substreet=placemark.subThoroughfare;
    [lbl_sub_subview setFrame:CGRectMake(160, 0, self.view.frame.size.width-160, 140)];
    if (str_street!=nil && str_substreet!=nil) {
        _str_location_content=[NSString stringWithFormat:@"%@%@\n%@%@\n%@",str_state,str_city,str_county,str_street,str_substreet];
    }
    else if (str_street!=nil && str_substreet==nil) {
         _str_location_content=[NSString stringWithFormat:@"%@%@\n%@%@",str_state,str_city,str_county,str_street];
    }
    else if (str_street==nil && str_substreet==nil) {
         _str_location_content=[NSString stringWithFormat:@"%@%@\n%@",str_state,str_city,str_county];
    }
    lbl_sub_subview.text=_str_location_content;
    lbl_sub_subview.numberOfLines=0;
   NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}
@end
