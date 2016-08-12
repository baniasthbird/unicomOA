//
//  ContactViewControllerNew.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/5.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ContactViewControllerNew.h"
#import "CLTree.h"
#import "MemberInfoViewController.h"
#import "DataSource.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "LXAlertView.h"
#import "CDFInitialsAvatar.h"
#import "XSpotLight.h"


@interface ContactViewControllerNew()<XSpotLightDelegate>

@property (strong,nonatomic) NSMutableArray *dataArray;  //保存全部数据的数组
@property (strong,nonatomic) NSArray *displayArray;      //保存要显示在界面上的数据的数组
@property (strong,nonatomic) NSString *str_department;   //联系人所在部门

@property (strong,nonatomic) NSMutableArray *searchArray;  //搜索数据

@property (strong,nonatomic) UITableView *tableView;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

@property BOOL b_hasData;

@end

@implementation ContactViewControllerNew {
    DataBase *db;
    UIActivityIndicatorView *indicator;
    
    NSUInteger i_stat;
}

CGFloat i_Height=-1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDictionary * dict=@{
                              NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
        self.navigationController.navigationBar.titleTextAttributes=dict;
        self.title = @"通讯录";
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"通讯录";
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    self.view.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    

    XSpotLight *SpotLight=[[XSpotLight alloc]init];
    SpotLight.messageArray=@[@"通讯录可查看用户头像"];
    SpotLight.rectArray=@[[NSValue valueWithCGRect:CGRectMake(0,0,0,0)]];
    SpotLight.delegate=self;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [self presentViewController:SpotLight animated:NO completion:^{
            
        }];
    }
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refresh:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];

   // self.navigationItem.rightBarButtonItem=barButtonItem;
    
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
        i_Height=116;
    }
    UIView *bg_base=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, i_Height)];
    UIImageView *bg_View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, i_Height)];
    bg_View.image=[UIImage imageNamed:@"bg_Nav.png"];
    [bg_base addSubview:bg_View];
    [bg_base sendSubviewToBack:bg_View];
    
    indicator=[self AddLoop];
   // [indicator startAnimating];
    [self.view addSubview:indicator];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];



    
    //[self AddressList];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    
    
    _refreshControl=[[UIRefreshControl alloc] init];
    
    //设置refreshControl的属性
    _refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:_refreshControl];

    
    [self.view addSubview:self.tableView];
    
    
   // self.tableView.sectionHeaderHeight=40;
    
    
    self.resultViewController=[[SearchResultViewController alloc]initWithStyle:UITableViewStylePlain];
    
   // [self.navigationController addChildViewController:self.resultViewController];
    
    self.searchcontroller=[[UISearchController alloc] initWithSearchResultsController:self.resultViewController];
    
   
    self.searchcontroller.searchResultsUpdater=self;
    
    self.searchcontroller.searchBar.delegate=self;
    
    //[self.searchcontroller.searchBar sizeToFit];
    
    self.searchcontroller.searchBar.placeholder=@"搜索姓名";
    
    [[[[self.searchcontroller.searchBar.subviews objectAtIndex:0] subviews]objectAtIndex:0]removeFromSuperview];
    
    [self.searchcontroller.searchBar setFrame:CGRectMake(0, 20, self.view.frame.size.width,40)];
    
    
  //  self.searchcontroller.dimsBackgroundDuringPresentation=NO;
    
    self.definesPresentationContext=YES;
    

    [bg_base addSubview:self.searchcontroller.searchBar];
    
 //   [self.view addSubview:bg_base];
    
    UILabel *lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(0, i_Height, self.view.frame.size.width, 40)];
    lbl_title.text=@"      组织结构";
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.textAlignment=NSTextAlignmentLeft;
    lbl_title.font=[UIFont systemFontOfSize:15];
    
    self.tableView.tableHeaderView=self.searchcontroller.searchBar;

    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    DataSource *dt_tmp=[[DataSource alloc]init];
   // _dataArray=[dt_tmp addTestData];
    NSMutableArray *arr_staff=[db fetchAllStaff];
   // NSInteger i_staff_count=[arr_staff count];
    i_stat=[arr_staff count];
    NSMutableArray *arr_depart=[db fetchAllDepart];
    NSMutableArray  *dataArray=[dt_tmp addRealData:arr_staff departArray:arr_depart];
    
    _dataArray=dataArray;
    /*
    //添加演示数据
    [self addTestData];
     */
    //初始化将要显示的数据
    [self reloadDataForDisplayArray:dataArray];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}

-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}


//首次连接获取通讯录
-(void)AddressList {
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
        NSString *str_addresslist=[db fetchInterface:@"AddressList"];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_addresslist];
        [_session POST:str_url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL i_success=[str_success boolValue];
            if (i_success==YES) {
                 NSLog(@"获取通讯录列表成功:%@",responseObject);
                 [indicator stopAnimating];
                
                NSMutableArray *staffArray=[JSON objectForKey:@"empList"];
                NSMutableArray *departArray=[JSON objectForKey:@"orgList"];
                i_stat=[staffArray count];
                //更新数据库
                db=[DataBase sharedinstanceDB];
                [db UpdateStaffTable:staffArray];
                [db UpdateDepartmentTable:departArray];
                DataSource *dt_tmp=[[DataSource alloc]init];
                NSMutableArray *dataArray=[dt_tmp addRealData:staffArray departArray:departArray];
                [self reloadDataForDisplayArray:dataArray];
                [_refreshControl endRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
        }];

    }
    else {
        [indicator stopAnimating];
       // [_refreshControl endRefreshing];
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
    }
    
}





-(CLTreeViewNode*)CreateLevel0Node:(NSString*)str_name staff_num:(NSString*)staff_num {
    CLTreeViewNode *node0=[[CLTreeViewNode alloc]init];
    node0.nodeLevel=0;
    node0.type=0;
    node0.sonNodes=nil;
    node0.isExpanded=FALSE;
    CLTreeView_LEVEL0_Model *tmp0=[[CLTreeView_LEVEL0_Model alloc]init];
    tmp0.name=str_name;
    tmp0.num=staff_num;
   // tmp0.headImgPath=@"contacts_major.png";
    //tmp0.headImgPath=nil;
   // tmp0.headImgUrl=nil;
    node0.nodeData=tmp0;
    
    return node0;

}

-(CLTreeViewNode*)CreateLevel1Node:(NSString*)str_name sonCnt:(NSString*)str_soncnt {
    CLTreeViewNode *node0 = [[CLTreeViewNode alloc]init];
    node0.nodeLevel = 1;
    node0.type = 1;
    node0.sonNodes = nil;
    node0.isExpanded = FALSE;
    CLTreeView_LEVEL1_Model *tmp0 =[[CLTreeView_LEVEL1_Model alloc]init];
    tmp0.name = str_name;
    tmp0.sonCnt = str_soncnt;
    node0.nodeData = tmp0;
    
    return node0;
}

-(CLTreeViewNode*)CreateLevel2Node:(NSString*)str_name signture:(NSString*)str_signture headImgPath:(NSString*)str_headImgPath headImgUrl:(NSString*)str_headImgUrl gender:(NSString*)str_gender department:(NSString*)str_department cell:(NSString*)str_cellphone phone:(NSString*)str_phonenum email:(NSString*)str_email{
    CLTreeViewNode *node0 = [[CLTreeViewNode alloc]init];
    node0.nodeLevel = 2;
    node0.type = 2;
    node0.sonNodes = nil;
    node0.isExpanded = FALSE;
    CLTreeView_LEVEL2_Model *tmp0 =[[CLTreeView_LEVEL2_Model alloc]init];
    tmp0.name = str_name;
    tmp0.signture = str_signture;
    tmp0.headImgPath = str_headImgPath;
    tmp0.headImgUrl = nil;
    tmp0.gender=str_gender;
    tmp0.department=str_department;
    tmp0.cellphonenum=str_cellphone;
    tmp0.phonenum=str_phonenum;
    tmp0.email=str_email;
    node0.nodeData = tmp0;
    
    return node0;
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayArray.count;
}

/*
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(0, i_Height, self.view.frame.size.width, 40)];
    lbl_title.text=@"      组织结构";
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.textAlignment=NSTextAlignmentLeft;
    lbl_title.font=[UIFont systemFontOfSize:15];
    lbl_title.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    return lbl_title;
}
*/

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"level0cell";
    static NSString *indentifier1 = @"level1cell";
    static NSString *indentifier2 = @"level2cell";
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    
    if(node.type == 0){//类型为0的cell
        if (node.isStat==NO) {
            CLTreeView_LEVEL0_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"Level0_Cell" owner:self options:nil] lastObject];
            }
            cell.node = node;
            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            return cell;
        }
        else {
            NSString *ID=[NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
            if (cell==nil) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                
            }
            cell.backgroundColor=[UIColor whiteColor];
            UILabel *lbl_label=[[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, cell.contentView.frame.size.height)];
            lbl_label.textColor=[UIColor colorWithRed:154/255.0f green:154/255.0f blue:154/255.0f alpha:1];
            lbl_label.font=[UIFont boldSystemFontOfSize:18];
            lbl_label.textAlignment=NSTextAlignmentCenter;
            lbl_label.text=[NSString stringWithFormat:@"%ld%@",(long)i_stat,@"位联系人"];
            [cell.contentView addSubview:lbl_label];
            return cell;
        }
    }
    else if(node.type == 1){//类型为1的cell
        CLTreeView_LEVEL1_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level1_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
    else{//类型为2的cell
        CLTreeView_LEVEL2_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level2_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }

}

/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void)loadDataForTreeViewCell:(UITableViewCell*)cell with:(CLTreeViewNode*)node {
    if(node.type == 0){
        CLTreeView_LEVEL0_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL0_Cell*)cell).name.text = nodeData.name;
        ((CLTreeView_LEVEL0_Cell*)cell).staffnum.text = nodeData.num;
        /*
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
         */
    }
    
    else if(node.type == 1){
        CLTreeView_LEVEL1_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL1_Cell*)cell).name.text = nodeData.name;
        ((CLTreeView_LEVEL1_Cell*)cell).sonCount.text = nodeData.sonCnt;
    }
    
    else{
        CLTreeView_LEVEL2_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL2_Cell*)cell).name.text = nodeData.name;
        ((CLTreeView_LEVEL2_Cell*)cell).signture.text = nodeData.signture;
        CGFloat w_depart=[UILabel_LabelHeightAndWidth getWidthWithTitle:nodeData.signture font:[UIFont systemFontOfSize:13]];
        ((CLTreeView_LEVEL2_Cell*)cell).signture.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-w_depart-10, 10, w_depart, 30);
        [((CLTreeView_LEVEL2_Cell*)cell).signture sizeToFit];
        if ([nodeData.name isEqualToString:_userInfo.str_name]) {
            UIImage *saveImage = [self loadLocalImage:nodeData.name];
            UIImageView *imgView=((CLTreeView_LEVEL2_Cell*)cell).headImg;
            imgView.layer.cornerRadius=imgView.frame.size.width/2;
            imgView.layer.masksToBounds=YES;
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:saveImage];
        }
        else {
            if (nodeData.headImgUrl != nil){
                //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
                NSURL *url=nodeData.headImgUrl;
                NSString *str_url=url.absoluteString;
                if (![str_url isEqualToString:@""]) {
                    UIImage *saveImage = [self loadLocalImage:nodeData.name];
                    if (saveImage!=nil) {
                        UIImageView *imgView=((CLTreeView_LEVEL2_Cell*)cell).headImg;
                        imgView.layer.cornerRadius=imgView.frame.size.width/2;
                        imgView.layer.masksToBounds=YES;
                        [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:saveImage];
                    }
                    else {
                        UIImageView *imgView=((CLTreeView_LEVEL2_Cell*)cell).headImg;
                        UIImage *img= [self setTxcolorAndTitle:nodeData.name fid:nodeData.signture imgView:imgView];
                        [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:img];
                    }
                }
                else {
                    if(nodeData.headImgPath != nil){
                        //本地图片
                        [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageNamed:nodeData.headImgPath]];
                    }
                    else {
                        UIImageView *imgView=((CLTreeView_LEVEL2_Cell*)cell).headImg;
                        UIImage *img= [self setTxcolorAndTitle:nodeData.name fid:nodeData.signture imgView:imgView];
                        [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:img];
                    }
                }
            }

        }
        
        
    }
}

/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
    if(node.type == 2){
        CLTreeView_LEVEL2_Model *nodeData = node.nodeData;
        //处理叶子节点选中，此处需要自定义
        MemberInfoViewController *viewController=[[MemberInfoViewController alloc] init];
        viewController.str_Name= nodeData.name;
        viewController.str_Gender=nodeData.gender;
        if ([nodeData.name isEqualToString:_userInfo.str_name]) {
            NSString *str_picname=[NSString stringWithFormat:@"%@.%@",nodeData.name,@"jpg"];
            NSString *fullPath=  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:str_picname];
            viewController.str_img=fullPath;
        }
        else {
            //本地图片
            if ([nodeData.headImgUrl.absoluteString isEqualToString:@""]) {
                if (nodeData.headImgPath==nil)
                {
                    viewController.str_img=@"headLogo.png";
                }
                else {
                    viewController.str_img=nodeData.headImgPath;
                }
            }
            else {
                NSString *str_picname=[NSString stringWithFormat:@"%@.%@",nodeData.name,@"jpg"];
                NSString *fullPath=  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:str_picname];
                UIImage *img=[UIImage imageWithContentsOfFile:fullPath];
                if (img!=nil) {
                    viewController.str_img=fullPath;
                }
                else {
                    viewController.str_img=@"headLogo.png";
                }
                
            }

        }
                       // FriendGroup *tmp_friend=[_friendsData objectAtIndex:indexPath.section];
        viewController.str_department=nodeData.department;
        
        viewController.str_carrer=nodeData.signture;
        viewController.str_cellphone=nodeData.cellphonenum;
        viewController.str_phonenum=nodeData.phonenum;
        viewController.str_email=nodeData.email;
        /*
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
         */
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else {
        CLTreeView_LEVEL0_Cell *cell = (CLTreeView_LEVEL0_Cell*)[tableView cellForRowAtIndexPath:indexPath];
        if(cell.node.isExpanded ){
            [self rotateArrow:cell with:M_PI_2];
        }
        else{
            [self rotateArrow:cell with:0];
        }
    }


}

/*---------------------------------------
 旋转箭头图标
 --------------------------------------- */
-(void)rotateArrow:(CLTreeView_LEVEL0_Cell*) cell with:(double)degree {
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
    } completion:NULL];
}

/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void)reloadDataForDisplayArray:(NSMutableArray*)dataArray {
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.tableView reloadData];
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row {
    NSMutableArray *tmp=[[NSMutableArray alloc]init];
    NSInteger cnt=0;
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if (cnt ==row) {
            node.isExpanded=!node.isExpanded;
        }
        ++cnt;
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(cnt == row){
                    node2.isExpanded = !node2.isExpanded;
                }
                ++cnt;
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                        ++cnt;
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.tableView reloadData];
}

#pragma mark -search bar delegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark- UISearchResultUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [indicator startAnimating];
    if (self.searchArray!=nil) {
        [self.searchArray removeAllObjects];
    }
    //筛选条件
    NSString *searchtext=searchController.searchBar.text;
    if (![searchtext isEqualToString:@""]) {
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        param[@"name"]=searchtext;
        [self FindContact:param];
    }
    
}



//根据搜索栏查找
-(void)FindContact:(NSMutableDictionary*)param {
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
        NSString *str_listsearch=[db fetchInterface:@"ListSearch"];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_listsearch];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [indicator stopAnimating];
            NSLog(@"查询通讯录成功");
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                NSArray *arr_result=[JSON objectForKey:@"empList"];
                if ([arr_result count]>0) {
                    _resultViewController.dataArray=arr_result;
                    _resultViewController.nav=self.navigationController;
                    
                }
                else {
                    _resultViewController.dataArray=nil;
                    _resultViewController.nav=nil;
                }
                [_resultViewController.tableView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
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


-(void)handleRefresh:(id)paramSender {
    // 模拟2秒后刷新数据
    int64_t delayInSeconds = 2.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //停止刷新
        
        //tableview中插入一条数据
        [self AddressList];
        
    });
}

-(void)refresh:(UIButton*)sender {
    [indicator startAnimating];
    [self AddressList];
    
}


-(UIImage*)setTxcolorAndTitle:(NSString*)title fid:(NSString*)fid imgView:(UIImageView*)imgView
{
    NSArray *tximgLis=@[@"tx_one",@"tx_two",@"tx_three",@"tx_four",@"tx_five",@"tx_six",@"tx_seven"];
    NSString *strImg;
    
    //根据不同职务配置颜色
    NSRange range=[fid rangeOfString:@"经理"];
    if (range.location!=NSNotFound) {
        strImg=tximgLis[0];
    }
    else {
        NSRange range=[fid rangeOfString:@"主任"];
        if (range.location!=NSNotFound) {
            strImg=tximgLis[1];
        }
        else {
            NSRange range=[fid rangeOfString:@"总监"];
            if (range.location!=NSNotFound) {
                strImg=tximgLis[1];
            }
            else {
                strImg=tximgLis[4];
            }

        }
        

    }
       /*
    if(fid.length!=0)//利用号码不同来随机颜色
    {
        NSString *strCarc= fid.length<7? [fid substringToIndex:fid.length]:[fid substringToIndex:7];
        int allnum=[strCarc intValue];
        strImg=tximgLis[allnum%7];
    }else
    {
        strImg=tximgLis[0];
    }
    */
    if(title.length!=0)
    {
       // title= title.length<2? [title substringToIndex:title.length]:[title substringToIndex:2];
        title=[title substringFromIndex:title.length-1];
    }else
    {
        title=@"测试";
    }
    
    
    CDFInitialsAvatar *topAvatar = [[CDFInitialsAvatar alloc] initWithRect:imgView.bounds fullName:title];
    
    topAvatar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:strImg]];
   // topAvatar.backgroundColor=[UIColor lightGrayColor];
    
    topAvatar.initialsFont=[UIFont fontWithName:@"STHeitiTC-Light" size:14];
    CALayer *mask = [CALayer layer]; // this will become a mask for UIImageView
    UIImage *maskImage = [UIImage imageNamed:@"AvatarMask"]; // circle, in this case
    mask.contents = (id)[maskImage CGImage];
    mask.frame = imgView.bounds;
    imgView.layer.mask = mask;
    imgView.layer.cornerRadius = YES;
    imgView.image = topAvatar.imageRepresentation;
    return  topAvatar.imageRepresentation;
}

-(UIImage*)loadLocalImage:(NSString*)str_name {
    NSString *str_picname=[NSString stringWithFormat:@"%@.%@",str_name,@"jpg"];
    NSString *fullPath=  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:str_picname];
    UIImage *saveImage=[[UIImage alloc]initWithContentsOfFile:fullPath];
    return  saveImage;
}

-(void)XSpotLightClicked:(NSInteger)index{
    NSLog(@"%ld",(long)index);
}

@end
