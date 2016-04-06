//
//  MemberInfoViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/3/24.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MemberInfoViewController.h"
#import "LogoView.h"
#import "PhoneLabelView.h"

@interface MemberInfoViewController ()

@end

@implementation MemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"员工资料";
    
    self.view.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
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
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.detailTextLabel.textColor=[UIColor colorWithRed:153.0/255.0f green:153.0/255.0f  blue:153.0/255.0f  alpha:1];
    [cell.detailTextLabel setFrame:CGRectMake(cell.frame.size.width/2, cell.frame.origin.y, cell.frame.size.width*0.4, cell.frame.size.height)];
    
    
    if (indexPath.row==0) {
        LogoView *cell=[LogoView cellWithTable:tableView withName:_str_Name withImage:_str_img];
        return cell;
    }
    else if (indexPath.row==1) {
        cell.textLabel.text=@"性别";
        cell.detailTextLabel.text=_str_Gender;
    }
    else if (indexPath.row==2) {
        cell.textLabel.text=@"部门";
        cell.detailTextLabel.text=_str_department;
    }
    else if (indexPath.row==3) {
        cell.textLabel.text=@"职务";
        cell.detailTextLabel.text=_str_carrer;
    }
    else if (indexPath.row==4) {
        PhoneLabelView *cell=[PhoneLabelView cellWithTable:tableView withTtile:@"手机" withName:_str_cellphone withCallImage:@"call" withMessageImage:@"message_contact"];
        return cell;
        /*
        cell.textLabel.text=@"手机";
        cell.detailTextLabel.text=_str_cellphone;
        cell.detailTextLabel.textColor=[UIColor colorWithRed:23/255.0f green:159/255.0f blue:213/255.0f alpha:1];
         */
    }
    else if (indexPath.row==5) {
        PhoneLabelView *cell=[PhoneLabelView cellWithTable:tableView withTtile:@"固定电话" withName:_str_phonenum withCallImage:@"call" withMessageImage:@"message_contact"];
        return cell;
        /*
        cell.textLabel.text=@"固定电话";
        cell.detailTextLabel.text=_str_phonenum;
        cell.detailTextLabel.textColor=[UIColor colorWithRed:23/255.0f green:159/255.0f blue:213/255.0f alpha:1];
         */
    }
    else if (indexPath.row==6) {
        cell.textLabel.text=@"EMail";
        cell.detailTextLabel.text=_str_email;
    }
    else if (indexPath.row==7) {
        cell.textLabel.textColor=[UIColor colorWithRed:22/255.0f green:155/255.0f blue:213/255.0f alpha:1];
        cell.textLabel.text=@"发送信息";
    }
    // Configure the cell...
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return  100;
    }
    else {
        return  60;
    }
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
