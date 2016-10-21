//
//  AllListSearchResultVC.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/10/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "AllListSearchResultVC.h"
#import "BaseFunction.h"
#import "AllListVC.h"

@interface AllListSearchResultVC ()

@end

@implementation AllListSearchResultVC {
    BaseFunction *baseFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSDictionary *dic=self.dataArray[indexPath.row];
    NSString *str_name=[dic objectForKey:@"empname"];
    NSMutableAttributedString *str_lbl_name=[[NSMutableAttributedString alloc]initWithString:str_name];
 
    
    [self ColorKeyWord:str_name label:str_lbl_name];
    
    cell.textLabel.attributedText=str_lbl_name;
   
    return cell;

}

//强调关键字
-(void)ColorKeyWord:(NSString*)str_org label:(NSMutableAttributedString*)lbl_org{
    NSInteger i_count =[baseFunc countOccurencesOfString:_str_key length:str_org];
    NSString *str_tmp=str_org;
    for (int i=0;i<i_count;i++) {
        NSRange range=[str_tmp rangeOfString:_str_key];
        if (range.location!=NSNotFound) {
            [lbl_org addAttribute:NSForegroundColorAttributeName  value:[UIColor colorWithRed:81/255.0f green:192/255.0f blue:251/255.0f alpha:1] range:NSMakeRange(range.location, range.length)];
        }
        str_tmp=[str_org substringFromIndex:(range.location+range.length)];
    }
    
}


-(void)dealloc {
    self.tableView.delegate=nil;
    self.tableView.dataSource=nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic=self.dataArray[indexPath.row];
    NSString *str_name=[dic objectForKey:@"empname"];
    NSString *str_value=[dic objectForKey:@"empid"];
    NSDictionary *dic_return=[NSDictionary dictionaryWithObjectsAndKeys:str_name,@"label",str_value,@"value", nil];
  //  [_delegate SendSearchMemberValue:dic_return indexPath:indexPath];
    AllListVC *vc_parent=(AllListVC*)_vc_parent;
    [vc_parent.delegate sendMemberValue:dic_return indexPath:_indexPath_parent];
    [_nav popViewControllerAnimated:NO];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
