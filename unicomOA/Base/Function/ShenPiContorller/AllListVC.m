//
//  AllListVC.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/10/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "AllListVC.h"
#import "CLTree.h"
#import "DataSource.h"
#import "DataBase.h"
#import "CDFInitialsAvatar.h"
#import "LXAlertView.h"
#import "UILabel+LabelHeightAndWidth.h"

@interface AllListVC ()

@property (strong,nonatomic) NSMutableArray *dataArray;  //保存全部数据的数组
@property (strong,nonatomic) NSArray *displayArray;      //保存要显示在界面上的数据的数组
@property (strong,nonatomic) NSString *str_department;   //联系人所在部门

@property (strong,nonatomic) NSMutableArray *searchArray;  //搜索数据

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation AllListVC {
    DataBase *db;
    
    NSUInteger i_stat;
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    self.title=_str_title;
    // Do any additional setup after loading the view.
    db=[DataBase sharedinstanceDB];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-100)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    
    
    self.resultViewController=[[AllListSearchResultVC alloc]initWithStyle:UITableViewStylePlain];
   
    
    self.searchcontroller=[[UISearchController alloc] initWithSearchResultsController:self.resultViewController];
    
    self.searchcontroller.searchResultsUpdater=self;
    
    self.searchcontroller.searchBar.delegate=self;
    
    self.searchcontroller.searchBar.placeholder=@"搜索";
    
    [[[[self.searchcontroller.searchBar.subviews objectAtIndex:0] subviews]objectAtIndex:0]removeFromSuperview];
    
    [self.searchcontroller.searchBar setFrame:CGRectMake(0, 20, self.view.frame.size.width,40)];
    
    self.definesPresentationContext=YES;
    
    
    self.tableView.tableHeaderView=self.searchcontroller.searchBar;
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    DataSource *dt_tmp=[[DataSource alloc]init];
    
    NSMutableArray *arr_staff=[db fetchAllStaff];
    
    i_stat=[arr_staff count];
    
    NSMutableArray *arr_depart=[db fetchAllDepart];
    
    NSMutableArray *dataArray=[dt_tmp addRealData:arr_staff departArray:arr_depart];
    
    _dataArray=[[NSMutableArray alloc]init];
    _dataArray=dataArray;
    
     [self reloadDataForDisplayArray:dataArray];
    
     [self.view addSubview:self.tableView];
     [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
#pragma tableview相关
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayArray.count;
}

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
        CLTreeView_LEVEL2_Model *nodeData = node.nodeData;
        if ([nodeData.parentlevel isEqualToString:@"1"]) {
            cell.backgroundColor=[UIColor whiteColor];
        }
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
        CGFloat w_depart=[UILabel getWidthWithTitle:nodeData.signture font:[UIFont systemFontOfSize:13]];
        ((CLTreeView_LEVEL2_Cell*)cell).signture.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-w_depart-10, 10, w_depart, 30);
        [((CLTreeView_LEVEL2_Cell*)cell).signture sizeToFit];
        
        if ([nodeData.name isEqualToString:_userInfo.str_name]) {
            UIImage *saveImage = [self loadLocalImage:nodeData.name];
            if (saveImage!=nil) {
                UIImageView *imgView=((CLTreeView_LEVEL2_Cell*)cell).headImg;
                imgView.layer.cornerRadius=imgView.frame.size.width/2;
                imgView.layer.masksToBounds=YES;
                [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:saveImage];
            }
            else {
                UIImageView *imgView=((CLTreeView_LEVEL2_Cell*)cell).headImg;
                UIImage *img= [self setTxcolorAndTitle:nodeData.name fid:nodeData.gender imgView:imgView];
                [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:img];
            }
        }
        else {
            if (nodeData.headImgUrl != nil){
                //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
                NSURL *url=nodeData.headImgUrl;
                NSString *str_url=url.absoluteString;
                if (![str_url isEqualToString:@""]) {
                    NSString *str_ip=@"";
                    NSString *str_port=@"";
                    NSMutableArray *t_array=[db fetchIPAddress];
                    if (t_array.count==1) {
                        NSArray *arr_ip=[t_array objectAtIndex:0];
                        str_ip=[arr_ip objectAtIndex:0];
                        str_port=[arr_ip objectAtIndex:1];
                    }
                    //  str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_url];
                    //  NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str_url]];
                    //  UIImage *saveImage = [UIImage imageWithData:data];
                    NSString *str_picname=[NSString stringWithFormat:@"%@.%@",nodeData.name,@"jpg"];
                    NSString *fullPath=  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:str_picname];
                    UIImage *saveImage=[UIImage imageWithContentsOfFile:fullPath];
                    if (saveImage!=nil) {
                        UIImageView *imgView=((CLTreeView_LEVEL2_Cell*)cell).headImg;
                        imgView.layer.cornerRadius=imgView.frame.size.width/2;
                        imgView.layer.masksToBounds=YES;
                        [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:saveImage];
                    }
                    else {
                        UIImageView *imgView=((CLTreeView_LEVEL2_Cell*)cell).headImg;
                        UIImage *img= [self setTxcolorAndTitle:nodeData.name fid:nodeData.gender imgView:imgView];
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
                        UIImage *img= [self setTxcolorAndTitle:nodeData.name fid:nodeData.gender imgView:imgView];
                        [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:img];
                    }
                }
            }
            else {
                UIImageView *imgView=((CLTreeView_LEVEL2_Cell*)cell).headImg;
                UIImage *img= [self setTxcolorAndTitle:nodeData.name fid:nodeData.gender imgView:imgView];
                [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:img];
                
            }
            
        }
        
        
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    if (node.type!=2) {
        [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
    }
    if(node.type == 2){
        CLTreeView_LEVEL2_Model *nodeData = node.nodeData;
        if (nodeData!=nil) {
            NSDictionary *dic_return=[NSDictionary dictionaryWithObjectsAndKeys:nodeData.name,@"label",nodeData.empid,@"value", nil];
            [_delegate sendMemberValue:dic_return indexPath:_indexPath];
            [self.navigationController popViewControllerAnimated:NO];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void)reloadDataForDisplayArray:(NSMutableArray*)dataArray {
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    _dataArray=dataArray;
    for (CLTreeViewNode *node in dataArray) {
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

-(UIImage*)setTxcolorAndTitle:(NSString*)title fid:(NSString*)sex imgView:(UIImageView*)imgView
{
    NSArray *tximgLis=@[@"tx_one",@"tx_two",@"tx_three",@"tx_four",@"tx_five",@"tx_six",@"tx_seven"];
    NSString *strImg;
    
    //zr 0823 根据性别配置颜色
    if ([sex isEqualToString:@"男"]) {
        strImg=tximgLis[0];
    }
    else if ([sex isEqualToString:@"女"]) {
        strImg=tximgLis[6];
    }
    
      
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
    
    topAvatar.initialsFont=[UIFont fontWithName:@"STHeitiTC-Light" size:18];
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

/*---------------------------------------
 旋转箭头图标
 --------------------------------------- */
-(void)rotateArrow:(CLTreeView_LEVEL0_Cell*) cell with:(double)degree {
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
    } completion:NULL];
}


/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
//zr 0823 加载数据多时卡，得优化
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
  //  [indicator startAnimating];
    if (self.searchArray!=nil) {
        [self.searchArray removeAllObjects];
    }
    //筛选条件
    NSString *searchtext=searchController.searchBar.text;
    if (![searchtext isEqualToString:@""]) {
    
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        param[STAFF_USERNAME]=searchtext;
        [self FindContactLocal:param];
        
    }
    
}

-(void)FindContactLocal:(NSMutableDictionary*)param {
    NSString *str_con1=STAFF_USERNAME;
    NSString *str_key=param[STAFF_USERNAME];
    NSMutableArray *arr_result=[db GetPeopleByName:str_con1 keyword:str_key];
    if ([arr_result count]>0) {
        _resultViewController.dataArray=arr_result;
        _resultViewController.nav=self.navigationController;
        _resultViewController.str_key=str_key;
        _resultViewController.vc_parent=self;
        _resultViewController.indexPath_parent=_indexPath;
    }
    else {
        _resultViewController.dataArray=nil;
        _resultViewController.nav=nil;
        _resultViewController.str_key=nil;
    }
    [_resultViewController.tableView reloadData];
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
