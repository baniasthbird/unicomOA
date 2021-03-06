//
//  CarUser.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "CarUser.h"
#import "CLTree.h"
#import "DataSource.h"

@interface CarUser()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>

@property (nonatomic,strong) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *dataArray;  //保存全部数据的数组
@property (strong,nonatomic) NSArray *displayArray;      //保存要显示在界面上的数据的数组

@property (strong,nonatomic) UISearchController *searchController;   //搜索栏

@end

@implementation CarUser

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择使用人";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    DataSource *dt_tmp=[[DataSource alloc]init];
    
    //添加演示数据
    //[self addTestData];
    _dataArray=[dt_tmp addTestData];
    
    
    
    //初始化将要显示的数据
    [self reloadDataForDisplayArray];
    
    //搜索栏
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.placeholder=@"搜索姓名/拼音/电话";
    
    _tableView.tableHeaderView=self.searchController.searchBar;
    
    [self.view addSubview:_tableView];
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

//添加演示数据 (先根据demo在代码中添加，再组成plist文件以方便调整)
/*
-(void) addTestData {
    
#pragma mark 组织架构
    CLTreeViewNode *node1=[self CreateLevel0Node:@"第一设计分公司" staff_num:@"2"];
    CLTreeViewNode *node2=[self CreateLevel0Node:@"软信科技子公司" staff_num:@"10"];
    CLTreeViewNode *node3=[self CreateLevel0Node:@"综合管理部" staff_num:@"0"];
    
#pragma mark 第一设计分公司
    CLTreeViewNode *node1_2_0=[self CreateLevel2Node:@"崔红涛" signture:@"分公司总经理" headImgPath:@"head1.jpg" headImgUrl:nil gender:@"男" department:@"第一设计分公司" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node1_2_1=[self CreateLevel2Node:@"孙晓巍" signture:@"员工" headImgPath:@"head2.jpg" headImgUrl:nil gender:@"女" department:@"第一设计分公司" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    
#pragma mark 软信第二级组织架构
    CLTreeViewNode *node2_0=[self CreateLevel1Node:@"综合部" sonCnt:@"3"];
    CLTreeViewNode *node2_1=[self CreateLevel1Node:@"市场部" sonCnt:@"2"];
    CLTreeViewNode *node2_2=[self CreateLevel1Node:@"产品部" sonCnt:@"5"];
    CLTreeViewNode *node2_3=[self CreateLevel1Node:@"开发部" sonCnt:@"8"];
    
#pragma mark 软信员工
    CLTreeViewNode *node2_0_0=[self CreateLevel2Node:@"刘佳" signture:@"综合部部长" headImgPath:@"head1.jpg" headImgUrl:nil gender:@"女" department:@"综合部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_0_1=[self CreateLevel2Node:@"张三" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"综合部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_1_0=[self CreateLevel2Node:@"李四" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"女" department:@"市场部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_1_1=[self CreateLevel2Node:@"王五" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"市场部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_1_2=[self CreateLevel2Node:@"冀明哲" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"市场部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_2_0=[self CreateLevel2Node:@"刘攀攀" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"产品部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_2_1=[self CreateLevel2Node:@"朱培配" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"产品部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_2_2=[self CreateLevel2Node:@"李忻雨" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"产品部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_2_3=[self CreateLevel2Node:@"张曙光" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"产品部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_2_4=[self CreateLevel2Node:@"赵睿" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"产品部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_3_0=[self CreateLevel2Node:@"乔帮主" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"开发部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_3_1=[self CreateLevel2Node:@"周大" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"开发部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    
    node1.sonNodes=[NSMutableArray arrayWithObjects:node1_2_0,node1_2_1, nil];
    node2.sonNodes=[NSMutableArray arrayWithObjects:node2_0,node2_1,node2_2,node2_3, nil];
    node2_0.sonNodes=[NSMutableArray arrayWithObjects:node2_0_0,node2_0_1, nil];
    node2_1.sonNodes=[NSMutableArray arrayWithObjects:node2_1_0,node2_1_1,node2_1_2, nil];
    node2_2.sonNodes=[NSMutableArray arrayWithObjects:node2_2_0,node2_2_1,node2_2_2,node2_2_3,node2_2_4, nil];
    node2_3.sonNodes=[NSMutableArray arrayWithObjects:node2_3_0,node2_3_1, nil];
    
    
    _dataArray=[NSMutableArray arrayWithObjects:node1,node2,node3, nil];
    
    
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
*/

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

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
        CLTreeView_LEVEL0_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level0_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        return cell;
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
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
    }
}

/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iPhone4_4s || iPhone5_5s) {
        return  40;
    }
    else if (iPhone6) {
        return 50;
    }
    else {
        return 60;
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
-(void)reloadDataForDisplayArray {
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


/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
    if(node.type == 2){
        CLTreeView_LEVEL2_Model *nodeData = node.nodeData;
        [self.delegate CarUserName:nodeData.name];
        [self.navigationController popViewControllerAnimated:NO];
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

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

@end
