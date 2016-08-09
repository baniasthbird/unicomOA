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
#import "ContactViewControllerNew.h"
#import "AppDelegate.h"

@import MessageUI;

@interface MemberInfoViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation MemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"员工资料";
    
    //self.view.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }
    
    self.navigationController.navigationBar.titleTextAttributes=dict;

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return 8;
    }
    else {
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    /*
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    [cell.textLabel setFrame:CGRectMake(self.view.frame.size.width*0.2, 0, self.view.frame.size.width*0.2, cell.frame.size.height)];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.detailTextLabel.textColor=[UIColor colorWithRed:153.0/255.0f green:153.0/255.0f  blue:153.0/255.0f  alpha:1];
    [cell.detailTextLabel setFrame:CGRectMake(cell.frame.size.width/2, cell.frame.origin.y, cell.frame.size.width*0.4, cell.frame.size.height)];
     */
    UILabel *lbl_title;
    if (iPhone5_5s || iPhone4_4s) {
       lbl_title =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.22, -5, self.view.frame.size.width*0.2, cell.frame.size.height)];
    }
    else if (iPhone6) {
        lbl_title =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.22, 0, self.view.frame.size.width*0.2, cell.frame.size.height)];
    }
    else if (iPhone6_plus) {
        lbl_title =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.22, 0, self.view.frame.size.width*0.2, cell.frame.size.height)];
    }
    else if (iPad) {
        lbl_title =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.22, 0, self.view.frame.size.width*0.2, 60)];
    }
    lbl_title.font=[UIFont systemFontOfSize:16];
    lbl_title.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
    
    
    UILabel *lbl_name;
    if (iPhone5_5s || iPhone4_4s) {
        lbl_name=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.46, -5, self.view.frame.size.width*0.8, cell.frame.size.height)];
    }
    else if (iPhone6_plus || iPhone6) {
        lbl_name=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.46, 0, self.view.frame.size.width*0.8, cell.frame.size.height)];
    }
    else if (iPad) {
        lbl_name=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.46, 0, self.view.frame.size.width*0.8, 60)];
    }
    lbl_name.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
    lbl_name.font=[UIFont systemFontOfSize:16];
    lbl_name.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:lbl_title];
    [cell.contentView addSubview:lbl_name];
    UIImageView *img_View=[[UIImageView alloc]init];
    img_View.image=[UIImage imageNamed:@"membertablecell.png"];
    
    
       
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            LogoView *cell=[LogoView cellWithTable:tableView withName:nil withImage:_str_img];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row==1) {
            UILabel *lbl_name=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
            lbl_name.text=_str_Name;
            lbl_name.textAlignment=NSTextAlignmentCenter;
            lbl_name.font=[UIFont systemFontOfSize:24];
            lbl_name.textColor=[UIColor colorWithRed:86/255.0f green:130/255.0f blue:240/255.0f alpha:1];
            [cell.contentView addSubview:lbl_name];
            
        }
        else if (indexPath.row==2) {
            lbl_title.text=@"性别";
            lbl_name.text=_str_Gender;
            cell.backgroundView=img_View;
        }
        else if (indexPath.row==3) {
            lbl_title.text=@"部门";
            lbl_name.text=_str_department;
            cell.backgroundView=img_View;
        }
        else if (indexPath.row==4) {
            lbl_title.text=@"职务";
            lbl_name.text=_str_carrer;
            cell.backgroundView=img_View;
        }
        else if (indexPath.row==5) {
            lbl_title.text=@"手机";
            lbl_name.text=_str_cellphone;
            lbl_name.textColor=[UIColor colorWithRed:85/255.0f green:129/255.0f blue:239/255.0f alpha:1];
            lbl_name.userInteractionEnabled=YES;
            UITapGestureRecognizer *labelTapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
            [lbl_name addGestureRecognizer:labelTapGestureRecognizer];
            cell.backgroundView=img_View;
            /*
             PhoneLabelView *cell=[PhoneLabelView cellWithTable:tableView withTtile:@"手机" withName:_str_cellphone withCallImage:@"call" withMessageImage:@"message_contact"];
             cell.backgroundView=img_View;
             return cell;
             cell.textLabel.text=@"手机";
             cell.detailTextLabel.text=_str_cellphone;
             cell.detailTextLabel.textColor=[UIColor colorWithRed:23/255.0f green:159/255.0f blue:213/255.0f alpha:1];
             */
        }
        else if (indexPath.row==6) {
            UILabel *lbl_num;
            if (iPhone4_4s || iPhone5_5s) {
                lbl_num=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.17, -5, self.view.frame.size.width*0.2, cell.frame.size.height)];
            }
            else if (iPhone6_plus || iPhone6){
               lbl_num=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.17, 0, self.view.frame.size.width*0.2, cell.frame.size.height)];
            }
            else if (iPad) {
                lbl_num=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.17, 0, self.view.frame.size.width*0.2, 60)];
            }
            lbl_num.text=@"固定电话";
            lbl_num.font=[UIFont systemFontOfSize:16];
            lbl_num.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
            lbl_name.text=_str_phonenum;
            lbl_name.textColor=[UIColor colorWithRed:85/255.0f green:129/255.0f blue:239/255.0f alpha:1];
            lbl_name.userInteractionEnabled=YES;
            UITapGestureRecognizer *labelTapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
            [lbl_name addGestureRecognizer:labelTapGestureRecognizer];
            cell.backgroundView=img_View;
            [cell.contentView addSubview:lbl_num];
            
            /*
             PhoneLabelView *cell=[PhoneLabelView cellWithTable:tableView withTtile:@"固定电话" withName:_str_phonenum withCallImage:@"call" withMessageImage:nil];
             cell.backgroundView=img_View;
             return cell;
             
             cell.textLabel.text=@"固定电话";
             cell.detailTextLabel.text=_str_phonenum;
             cell.detailTextLabel.textColor=[UIColor colorWithRed:23/255.0f green:159/255.0f blue:213/255.0f alpha:1];
             */
        }
        else if (indexPath.row==7) {
            lbl_title.text=@"EMail";
            UILabel *lbl_email;
            if (iPhone4_4s || iPhone5_5s) {
                lbl_email=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.46, -5, self.view.frame.size.width*0.7, cell.frame.size.height)];
                lbl_email.font=[UIFont systemFontOfSize:14];
            }
            else if (iPhone6 || iPhone6_plus){
                lbl_email=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.46, 0, self.view.frame.size.width*0.7, cell.frame.size.height)];
                lbl_email.font=[UIFont systemFontOfSize:16];
            }
            else if (iPad) {
                lbl_email=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.46, 0, self.view.frame.size.width*0.7, 60)];
                lbl_email.font=[UIFont systemFontOfSize:18];
            }
            lbl_email.text=_str_email;
            lbl_email.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
            cell.backgroundView=img_View;
            [cell addSubview:lbl_email];
        }
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            /*
             cell.textLabel.textColor=[UIColor colorWithRed:22/255.0f green:155/255.0f blue:213/255.0f alpha:1];
             cell.textLabel.text=@"发送信息";
             */
            CGFloat i_left=self.view.frame.size.width*0.05;
            CGFloat i_width=self.view.frame.size.width*0.9;
            if (!iPad) {
               i_left=self.view.frame.size.width*0.05;
               i_width=self.view.frame.size.width*0.9;
            }
            else {
                i_left=100;
                i_width=568;
            }
            UIButton  *btn=[[UIButton alloc]initWithFrame:CGRectMake(i_left, 0, i_width, cell.frame.size.height)];
            
            btn.backgroundColor=[UIColor colorWithRed:85/255.0f green:129/255.0f blue:239/255.0f alpha:1];
            btn.layer.cornerRadius=20.0f;
            [btn setTitle:@"发送信息" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(SendMessage:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }

    }
           // Configure the cell...
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 50;
    }
    else {
        return 1;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor=[UIColor whiteColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        if (iPhone5_5s || iPhone4_4s) {
            return 112;
        }
        else if (iPhone6) {
            return 133;
        }
        else if (iPhone6_plus){
            return 147;
        }
        else  {
            return 292;
        }
        
    }
    else if (indexPath.row==1) {
        return 60;
    }
    else {
        if (iPhone5_5s || iPhone4_4s) {
            return 35;
        }
        else if (iPhone6) {
            return 41;
        }
        else if (iPhone6_plus) {
            return 45;
        }
        else {
            return 60;
        }
    }
}

-(void)MovePreviousVc:(UIButton*)sender {
    
    if (f_v<9.0) {
        AppDelegate *app=[[UIApplication sharedApplication] delegate];
        UINavigationController *nav=[[app.window.rootViewController.childViewControllers objectAtIndex:1].childViewControllers objectAtIndex:1];
        [nav popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(void)SendMessage:(UIButton*)sender {
    if (_str_cellphone!=nil) {
        if (![MFMessageComposeViewController canSendText]) {
            NSLog(@"不能发短信");
            return;
        }
        else {
            MFMessageComposeViewController *vc=[[MFMessageComposeViewController alloc]init];
            vc.messageComposeDelegate=self;
            
            vc.recipients=@[_str_cellphone];
            vc.body=@"";
            
            [self presentViewController:vc animated:NO completion:nil];
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
     self.navigationController.delegate=nil;
    
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

//点击电话后，拨打电话功能
-(void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer {
    if (_str_cellphone!=nil) {
        //判断是否是正常的手机号码 zr 0516 继续完善
        if (_str_cellphone.length==11 && [self isPureInt:_str_cellphone]==YES) {
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",_str_cellphone];
            UIWebView *callWebView=[[UIWebView alloc]init];
            [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebView];

        }
    }
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) dealloc {
    self.tableView.delegate=nil;
    self.tableView.dataSource=nil;
}


@end
