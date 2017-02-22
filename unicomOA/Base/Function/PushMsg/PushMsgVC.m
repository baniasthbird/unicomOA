//
//  PushMsgVC.m
//  unicomOA
//
//  Created by hnsi-03 on 2017/2/13.
//  Copyright © 2017年 zr-mac. All rights reserved.
//

#import "PushMsgVC.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "PushMsgCell.h"

@interface PushMsgVC ()

@end

@implementation PushMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=_str_title;
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)MovePreviousVc:(UIButton*)sender {
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [_delegate RefreshBtnBadge];
    [self.navigationController popViewControllerAnimated:NO];
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
    return _i_rownum;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str_text =[_arr_PushMsg objectAtIndex:indexPath.row];
    NSArray *arr_text= [str_text componentsSeparatedByString:@"||"];
    if (arr_text.count==2) {
        NSString *str_text_title=[arr_text objectAtIndex:0];
        NSString *str_text_time=[arr_text objectAtIndex:1];
        CGFloat h_Title=[UILabel getHeightByWidth:0.92*Width title:str_text_title font:[UIFont systemFontOfSize:15]];
        CGFloat h_depart=[UILabel getHeightByWidth:0.92*Width title:str_text_time font:[UIFont systemFontOfSize:15]];
        CGFloat cellHeight;
        if (h_Title>45) {
            cellHeight= 71+h_depart;
        }
        else {
            cellHeight = h_depart+h_Title+30;
        }
        return cellHeight;
    }
    else {
        CGFloat height=  [UILabel getHeightByWidth:Width title:str_text font:[UIFont systemFontOfSize:15]];
        return  height*2;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    NSString *str_text =[_arr_PushMsg objectAtIndex:indexPath.row];
    NSArray *arr_text= [str_text componentsSeparatedByString:@"||"];
    if ([arr_text count]==2) {
      
        NSString *str_text_title=[arr_text objectAtIndex:0];
        NSString *str_text_time=[arr_text objectAtIndex:1];
        CGFloat h_Title=[UILabel getHeightByWidth:0.92*Width title:str_text_title font:[UIFont systemFontOfSize:17]];
        CGFloat h_depart=[UILabel getHeightByWidth:0.92*Width title:str_text_time font:[UIFont systemFontOfSize:11]];
        CGFloat cellHeight;
        if (h_Title>45) {
            cellHeight= 71+h_depart;
        }
        else {
            cellHeight = h_depart+h_Title+30;
        }

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str_text_title];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str_text_title length])];
        PushMsgCell *cell=[PushMsgCell cellWithTable:tableView withCellHeight:cellHeight withTitleHeight:h_Title withButtonHeight:h_depart withTitle:attributedString withDate:str_text_time titleFont:17 otherFont:11 atIndexPath:indexPath];
        
        return cell;
      //  cell.textLabel.text=str_text_title;
       // cell.detailTextLabel.text=str_text_time;
    }
    else {
        cell.textLabel.text=[_arr_PushMsg objectAtIndex:indexPath.row];
        cell.textLabel.numberOfLines=0;
    }
    
    // Configure the cell...
    
    return cell;
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
