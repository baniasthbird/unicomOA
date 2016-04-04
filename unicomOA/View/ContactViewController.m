//
//  ContactViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/19.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ContactViewController.h"
#import "Friend.h"
#import "FriendGroup.h"
#import "HeadView.h"
#import "MemberInfoViewController.h"

@interface ContactViewController() <HeadViewDelegate>
{
    NSArray *_friendsData;
    
}

@end

@implementation ContactViewController



-(instancetype)init {
    
    
    self.title = @"通讯录";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    
    //设置样式
    return [self initWithStyle:UITableViewStyleGrouped];
    
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"通讯录";
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    
    self.tableView.sectionHeaderHeight=40;
    
   
    self.resultViewController=[[SearchResultViewController alloc]init];
    
    self.searchcontroller=[[UISearchController alloc] initWithSearchResultsController:self.resultViewController];
    
    self.searchcontroller.searchBar.delegate=self;
    
    [self.searchcontroller.searchBar sizeToFit];
    
    self.searchcontroller.searchBar.placeholder=@"搜索姓名/拼音/电话";
    
    
    self.searchcontroller.searchResultsUpdater=self;
    
    self.searchcontroller.dimsBackgroundDuringPresentation=NO;
    
    self.definesPresentationContext=YES;
    
    self.tableView.tableHeaderView=self.searchcontroller.searchBar;
    
    
    [self loadData];
    
}

#pragma mark 加载数据
#pragma mark 加载数据
- (void)loadData
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"friends.plist" withExtension:nil];
    NSArray *tempArray = [NSArray arrayWithContentsOfURL:url];
    
    NSMutableArray *fgArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        FriendGroup *friendGroup = [FriendGroup friendGroupWithDict:dict];
        [fgArray addObject:friendGroup];
    }
    
    _friendsData = fgArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return _friendsData.count;
    return  4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FriendGroup *friendGroup = _friendsData[section];
    NSInteger count = friendGroup.isOpened ? friendGroup.friends.count : 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FriendGroup *friendGroup = _friendsData[indexPath.section];
    Friend *friend = friendGroup.friends[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:friend.icon];
    cell.textLabel.textColor = friend.isVip ? [UIColor redColor] : [UIColor blackColor];
    cell.textLabel.text = friend.name;
    cell.detailTextLabel.text = friend.intro;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadView *headView = [HeadView headViewWithTableView:tableView];
    
    headView.delegate = self;
    headView.friendGroup = _friendsData[section];
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberInfoViewController *viewController=[[MemberInfoViewController alloc] init];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    viewController.str_Name= cell.textLabel.text;
    viewController.str_Gender=@"男";
    viewController.str_img=@"me.png";
    FriendGroup *tmp_friend=[_friendsData objectAtIndex:indexPath.section];
    viewController.str_department=tmp_friend.name;
    viewController.str_carrer=cell.detailTextLabel.text;
    viewController.str_cellphone=@"18600697151";
    viewController.str_phonenum=@"0371-65160750";
    viewController.str_email=@"2002-sunshine@163.com";
    [self.navigationController pushViewController:viewController animated:YES];
    /*
    ChatViewController *viewController = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
     */
}

- (void)clickHeadView
{
    [self.tableView reloadData];
}

#pragma mark -search bar delegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark- UISearchResultUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchtext=searchController.searchBar.text;
   
    //主要查询搜索页面，查询还需要包括模糊查询等算法支持，本次仅实现界面效果，不予考虑
    //zr 20160219
    
   /*
    NSArray *searchResult=[_friendsData filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings) {
        BOOL result=NO;
        if ([evaluatedObject hasPrefix:searchtext]) {
            return YES;
        }
        return result;
    }
                                                                     ]];
    SearchResultViewController *tableController=(SearchResultViewController *)self.searchcontroller.searchResultsController;
    tableController.dataArray=searchResult;
    [tableController.tableView reloadData];
    */
    
}

@end
