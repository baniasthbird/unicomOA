//
//  StaffInfoViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "StaffInfoViewController.h"
#import "ChangePhoneNumViewController.h"
#import "SettingViewController.h"
#import "LZActionSheet.h"

@interface StaffInfoViewController ()<LZActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImageView *img_Head;

@end

@implementation StaffInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的资料";
    
    

    
    self.view.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 4;
    }
    else {
        return 5;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.detailTextLabel.textColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f  blue:236.0/255.0f  alpha:1];
    
    
    if (indexPath.section==0 && indexPath.row==0) {
       // cell=[[HeadViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
       // HeadViewCell *cell=[[HeadViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
       // return cell;
        //UITableViewCell *cell_photo=[tableView cellForRowAtIndexPath:indexPath];
        
        UILabel *lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width/3, 60)];
        lbl_title.text=@" 头像";
        lbl_title.textAlignment=NSTextAlignmentLeft;
        lbl_title.font=[UIFont systemFontOfSize:24];
        lbl_title.textColor=[UIColor blackColor];
        
        UIImage *imageHead=[UIImage imageNamed:_userInfo.str_Logo];
        _img_Head=[[UIImageView alloc]initWithImage:imageHead];
        [_img_Head.layer setMasksToBounds:YES];
        _img_Head.layer.cornerRadius=37.0f;
        [_img_Head setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.68, 13, 74, 74)];
        _img_Head.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *singleTap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressed:)];
        
        [_img_Head addGestureRecognizer:singleTap1];
        
        [cell.contentView addSubview:lbl_title];
        [cell.contentView addSubview:_img_Head];
        
        //return cell_photo;
        
        
    }
    else if (indexPath.section==0 && indexPath.row==1) {
        cell.textLabel.text=@"姓名";
        cell.detailTextLabel.text=_userInfo.str_name;
    }
    else if (indexPath.section==0 && indexPath.row==2) {
        cell.textLabel.text=@"帐号";
        cell.detailTextLabel.text=_userInfo.str_username;
    }
    else if (indexPath.section==0 && indexPath.row==3) {
        cell.textLabel.text=@"性别";
        cell.detailTextLabel.text=_userInfo.str_gender;
    }
    else if (indexPath.section==1 && indexPath.row==0) {
        cell.textLabel.text=@"部门";
        cell.detailTextLabel.text=_userInfo.str_department;
    }
    else if (indexPath.section==1 && indexPath.row==1) {
        cell.textLabel.text=@"职务";
        cell.detailTextLabel.text=_userInfo.str_position;
    }
    else if (indexPath.section==1 && indexPath.row==2) {
        cell.textLabel.text=@"手机";
        if (_str_cellphone==nil) {
            cell.detailTextLabel.text=_userInfo.str_cellphone;
        } else {
            cell.detailTextLabel.text=_str_cellphone;
            _userInfo.str_cellphone=_str_cellphone;
        }
        
    }
    else if (indexPath.section==1 && indexPath.row==3) {
        cell.textLabel.text=@"Email";
        cell.detailTextLabel.text=_userInfo.str_email;
    }
    else if (indexPath.section==1 && indexPath.row==4) {
        cell.textLabel.text=@"固定电话";
        cell.detailTextLabel.text=_userInfo.str_phonenum;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0) {
        return 100;
    }
    else {
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0)
    {
        return 0;
    }
    else {
        return 20;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236/255.0f blue:236/255.0f alpha:1];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        view.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236/255.0f blue:236/255.0f alpha:1];
        return view;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1 && indexPath.row==2) {
        
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        ChangePhoneNumViewController *viewController=[[ChangePhoneNumViewController alloc]init];
        viewController.str_phonenum=cell.detailTextLabel.text;
        viewController.user_Info=_userInfo;
     //   [self.navigationController pushViewController:viewController animated:YES];
    }
}


-(void)MovePreviousVc:(UIButton *)sender {
    
    SettingViewController *viewController=[[SettingViewController alloc]init];
    viewController.userInfo=_userInfo;
    [self.navigationController pushViewController:viewController animated:YES];
     
     //[self.navigationController popViewControllerAnimated:YES];
}




-(void)buttonPressed:(UITapGestureRecognizer *)gestrueRecognizer {
    UIColor *other_color=[UIColor colorWithRed:81/255.0f green:127/255.0f blue:238/255.0f alpha:1];
    UIColor *cancel_color=[UIColor colorWithRed:246/255.0f green:88/255.0f blue:87/255.0f alpha:1];
    LZActionSheet *sheet=[LZActionSheet showActionSheetWithDelegate:self cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍照",@"从相册中选择"] cancelButtonColor:cancel_color otherButtonColor:other_color];
    [sheet show];
    NSLog(@"已点击图片");
}



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


//拍照完成或选择头像完成后的事件
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    //保存图片至本地
    [self saveImage:image withName:@"demo.png"];
    
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"demo.png"];
    
    UIImage *saveImage=[[UIImage alloc]initWithContentsOfFile:fullPath];
    
    [_img_Head setImage:saveImage];
    
    _userInfo.str_Logo=fullPath;
}


-(void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    NSData *imageData=UIImageJPEGRepresentation(currentImage, 1);  //1为不缩放保存
    //获取沙盒目录
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
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
