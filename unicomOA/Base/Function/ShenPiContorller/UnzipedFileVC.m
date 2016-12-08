//
//  UnzipedFileVC.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/11/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "UnzipedFileVC.h"
#import "FileViewerCell.h"
#import "DirectoryViewCell.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "LZActionSheet.h"

//解压后的文件显示
@interface UnzipedFileVC ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate,FileViewDelegate,UIGestureRecognizerDelegate,LZActionSheetDelegate> {
    UIDocumentInteractionController *_documentController;   //文档交互控制器
}

@property (nonatomic,strong) UITableView *tableview;

@end

@implementation UnzipedFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=_str_title;
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, -35, Width, Height) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_tableview];
    
    //侧滑返回
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    
    // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    
    // 一定要禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableview方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arr_files count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str_name=[_arr_files objectAtIndex:indexPath.row];
    CGFloat i_height=[UILabel getHeightByWidth:0.4*Width title:str_name font:[UIFont systemFontOfSize:16]];
    if (i_height<0.093*Height) {
        return 0.093*Height;
    }
    else {
        return i_height;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str_name=[_arr_files objectAtIndex:indexPath.row];
    NSString *str_path=[NSString stringWithFormat:@"%@/%@",_str_dir,str_name];
    CGFloat i_height=[UILabel getHeightByWidth:0.4*Width title:str_name font:[UIFont systemFontOfSize:16]];
    if (i_height<0.093*Height) {
        i_height = 0.093*Height;
    }
    NSFileManager *manager=[[NSFileManager alloc]init];
    BOOL isDir = YES;
    BOOL isExist = [manager fileExistsAtPath:str_path isDirectory:&isDir];
    if (isExist==YES) {
        if (isDir==YES) {
            DirectoryViewCell *cell=[DirectoryViewCell cellWithTable:tableView withName:str_name index:indexPath withPath:str_path withHeight:i_height];
            return cell;
        }
        else {
            FileViewerCell *cell=[FileViewerCell cellWithTable:tableView withName:str_name index:indexPath withPath:str_path withHeight:i_height];
            cell.str_Path=str_path;
            cell.delegate=self;
            return cell;
        }
    }
    else {
        NSString *ID=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        return cell;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[DirectoryViewCell class]]) {
        //点击进行下一步
        NSLog(@"下一步目录");
        NSString *str_name=[_arr_files objectAtIndex:indexPath.row];
        NSString *str_path=[NSString stringWithFormat:@"%@/%@",_str_dir,str_name];
        NSFileManager *fileManager=[[NSFileManager alloc]init];
        NSArray *tempArray=[fileManager contentsOfDirectoryAtPath:str_path error:nil];
        NSMutableArray *arr_files=[[NSMutableArray alloc]init];
        for (NSString *fileName in tempArray) {
            NSString *fullPath= [str_path stringByAppendingPathComponent:fileName];
            if ([fileManager fileExistsAtPath:fullPath]) {
                //先不考虑压缩包套压缩包的问题
                if ([fileName rangeOfString:@"zip"].location==NSNotFound && [fileName rangeOfString:@"rar"].location==NSNotFound) {
                    [arr_files addObject:fileName];
                }
            }
        }

        UnzipedFileVC *vc = [[UnzipedFileVC alloc]init];
        vc.str_title=str_name;
        vc.arr_files=arr_files;
        vc.str_dir=str_path;
        
        NSLog(@"解压缩成功!");
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([cell isKindOfClass:[FileViewerCell class]]) {
        FileViewerCell *cell_file=(FileViewerCell*)cell;
        NSString *str_path=cell_file.str_Path;
        _documentController=[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:str_path]];
        if ([_documentController.UTI isEqualToString:@"public.data"]) {
            [_documentController setDelegate:self];
            [_documentController presentOpenInMenuFromRect:CGRectMake(0, 50, Width, 40) inView:self.view animated:YES];
        }
        else {
        //    LZActionSheet *sheet=[LZActionSheet showActionSheetWithDelegate:self cancelButtonTitle:@"其他方式打开" otherButtonTitles:@[@"直接查看"] cancelButtonColor:[UIColor whiteColor] otherButtonColor:[UIColor blackColor]];
            UIColor *color_other_bg=[UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:1];
            UIColor *color_cancel_bg=[UIColor colorWithRed:96/255.0f green:96/255.0f blue:96/255.0f alpha:1];
            LZActionSheet *sheet=[LZActionSheet showActionSheetWithDelegate:self cancelButtonTitle:@"取消" otherButtonTitles:@[@"直接查看",@"其他方式打开"] cancelButtonColor:[UIColor whiteColor] otherButtonColor:[UIColor blackColor] cancelBgColor:color_other_bg otherBgColor:color_cancel_bg];
            sheet.LZActionSheetBaseHeight=0.07*Height;
            sheet.accessibilityHint=str_path;
             [sheet show];
        }
    }
}


-(void)PassFilePathAndCategory:(NSString *)str_path category:(NSInteger)i_category {
    //预览
    if (i_category==0) {
        NSURL *url=[NSURL fileURLWithPath:str_path];
        _documentController=[UIDocumentInteractionController interactionControllerWithURL:url];
        [_documentController setDelegate:self];
        [_documentController presentPreviewAnimated:YES];
    }
    //第三方打开
    else if (i_category==1) {
        NSURL *url=[NSURL fileURLWithPath:str_path];
        _documentController=[UIDocumentInteractionController interactionControllerWithURL:url];
        [_documentController setDelegate:self];
        [_documentController presentOpenInMenuFromRect:CGRectMake(0, 50, Width, 40) inView:self.view animated:YES];
    }
}


- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    
    //注意：此处要求的控制器，必须是它的页面view，已经显示在window之上了
    return self.navigationController;
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer*)sender {
    
}

-(void)LZActionSheet:(LZActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)index {
    NSString *str_path=actionSheet.accessibilityHint;
    if (index==0) {
        NSURL *url=[NSURL fileURLWithPath:str_path];
        _documentController=[UIDocumentInteractionController interactionControllerWithURL:url];
        [_documentController setDelegate:self];
        [_documentController presentPreviewAnimated:YES];
    }
    else if (index==1) {
        NSURL *url=[NSURL fileURLWithPath:str_path];
        _documentController=[UIDocumentInteractionController interactionControllerWithURL:url];
        [_documentController setDelegate:self];
        [_documentController presentOpenInMenuFromRect:CGRectMake(0, 50, Width, 40) inView:self.view animated:YES];
    }
    
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
