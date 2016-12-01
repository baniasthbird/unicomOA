//
//  TableFilesDetail.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/11/28.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "TableFilesDetail.h"
#import "DataBase.h"
#import "AttachmentVC.h"
#import "AFNetworking.h"
#import "CustomSlider.h"
#import "UnzipedFileVC.h"
#import "SARUnArchiveANY.h"
#import "LZMAExtractor.h"



@interface TableFilesDetail ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate,UIGestureRecognizerDelegate> {
    UIDocumentInteractionController *_documentController;   //文档交互控制器
}

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) UIButton *btn_download;

//@property (nonatomic,strong) CustomSlider *slider;

@property (nonatomic,strong) UIProgressView *progress_view;

@property (nonatomic, assign) BOOL isDownLoad;

@property (nonatomic,strong) UILabel *lbl_percentage;

@property (nonatomic,strong) UIButton *btn_share;

@end

@implementation TableFilesDetail {
    //文件类型
    NSString *str_file_category;
    //文件名
    NSString *str_file_name;
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
    
    int i_value;
    
    NSURLSessionDownloadTask *downloadTask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DataBase *db=[DataBase sharedinstanceDB];
    
    self.title=_str_title;
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, -35, Width, Height*0.35) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_tableview];
    
    //NSUInteger i_count=[_arr_title count];
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    
    NSInteger l1=0;
    NSInteger l2=0;
    NSInteger l3=0;
    for (int i=0; i<_arr_title.count; i++) {
        NSString *str_title=[_arr_title objectAtIndex:i];
        if ([str_title isEqualToString:@"附件大小"]) {
            l1=i;
        }
        else if ([str_title isEqualToString:@"附件路径"]) {
            l2=i;
        }
        else if ([str_title isEqualToString:@"附件名称"]) {
            l3=i;
        }
    }
    
    NSString *str_size=[_arr_data objectAtIndex:l1];
    NSInteger i_size=[str_size integerValue];
    
    NSString *str_url_link=[_arr_data objectAtIndex:l2];
    NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
    NSString *str_urldata= [str_url_link stringByTrimmingCharactersInSet:whitespace];
    NSString *str_substring=[str_urldata substringWithRange:NSMakeRange(0, 1)];
    if (![str_substring isEqualToString:@"/"]) {
        str_urldata=[NSString stringWithFormat:@"%@%@",@"/",str_urldata];
    }
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@%@",@"http://",str_ip,str_port,@"/default",str_urldata];
    
    
    NSString *str_tmp_name=[_arr_data objectAtIndex:l3];
    NSArray *arr_tmp=[str_tmp_name componentsSeparatedByString:@"."];
    if (arr_tmp!=nil && [arr_tmp count]>0) {
        str_file_category=[arr_tmp objectAtIndex:1];
    }

    NSArray *arr_link_name=[str_url_link componentsSeparatedByString:@"/"];
    str_file_name=[arr_link_name lastObject];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [pathDocuments  stringByAppendingPathComponent:str_file_name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"已有文件");
        _isDownLoad=YES;
    }
    else {
        NSLog(@"待下载");
        _isDownLoad=NO;
    }
    
    _btn_download=[[UIButton alloc]initWithFrame:CGRectMake(25, Height*0.5,Width-50,40)];
    _btn_download.layer.cornerRadius=20;
    _btn_download.backgroundColor=[UIColor colorWithRed:90/255.0f green:134/255.0f blue:243/255.0f alpha:1];
    [_btn_download setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn_download.titleLabel.font=[UIFont systemFontOfSize:21];
    
    _btn_share=[[UIButton alloc]initWithFrame:CGRectMake(25, Height*0.6,Width-50,40)];
    _btn_share.layer.cornerRadius=20;
    _btn_share.backgroundColor=[UIColor colorWithRed:90/255.0f green:134/255.0f blue:243/255.0f alpha:1];
    [_btn_share setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn_share.titleLabel.font=[UIFont systemFontOfSize:21];
    
    if (_isDownLoad==NO) {
        _btn_download.accessibilityHint=str_url;
        if ([str_file_category isEqualToString:@"zip"] || [str_file_category isEqualToString:@"rar"]) {
            [_btn_download setTitle:@"下   载" forState:UIControlStateNormal];
            _btn_download.tag=1001;
            [_btn_download addTarget:self action:@selector(DownLoad:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            if (i_size>2000) {
                [_btn_download setTitle:@"下   载" forState:UIControlStateNormal];
                _btn_download.tag=1001;
                [_btn_download addTarget:self action:@selector(DownLoad:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                [_btn_download setTitle:@"查   看" forState:UIControlStateNormal];
                _btn_download.tag=1002;
                [_btn_download addTarget:self action:@selector(LookUp:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    else {
        _btn_download.accessibilityHint=filePath;
        if ([str_file_category isEqualToString:@"zip"] || [str_file_category isEqualToString:@"rar"]) {
            [_btn_download setTitle:@"解    压" forState:UIControlStateNormal];
            _btn_download.tag=1003;
            [_btn_download addTarget:self action:@selector(Unzip:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [_btn_download setTitle:@"预    览" forState:UIControlStateNormal];
            _btn_download.tag=1004;
            [_btn_download addTarget:self action:@selector(FilePreview:) forControlEvents:UIControlEventTouchUpInside];
            [_btn_share setTitle:@"其他应用打开" forState:UIControlStateNormal];
            _btn_share.accessibilityHint=filePath;
            [_btn_share addTarget:self action:@selector(FileShare:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
   
    
    
    
    [self.view addSubview:_btn_download];
    if (_btn_download.tag==1004) {
        [self.view addSubview:_btn_share];
    }
    
    
    _lbl_percentage=[[UILabel alloc]initWithFrame:CGRectMake(Width/2-100, Height*0.45, 200, 30)];
    _lbl_percentage.textColor=[UIColor blackColor];
    _lbl_percentage.font=[UIFont systemFontOfSize:15];
    _lbl_percentage.text=@"0.0%";
    _lbl_percentage.textAlignment=NSTextAlignmentCenter;
    if (_btn_download.tag==1001) {
         [self.view addSubview:_lbl_percentage];
    }
   
    
    _progress_view =[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    _progress_view.frame=CGRectMake(25, 0.4*Height, Width-50, 30);
    _progress_view.backgroundColor=[UIColor redColor];
    _progress_view.progressTintColor=[UIColor yellowColor];
    _progress_view.trackTintColor=[UIColor orangeColor];
 //   [_progress_view setProgress:0 animated:YES];
    if (i_size>2000) {
        if (_btn_download.tag==1001) {
            [self.view addSubview:_progress_view];
        }
    }
    
    
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
    return [_arr_title count]-2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.textColor=[UIColor blackColor];
    cell.detailTextLabel.textColor=[UIColor colorWithRed:110/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    
    NSObject *obj_title= [_arr_title objectAtIndex:indexPath.row];
    
    NSString *str_title=@"";
    if (obj_title!=[NSNull null]) {
        str_title=(NSString*)obj_title;
    }
    if (![str_title isEqualToString:@"附件路径"] && ![str_title isEqualToString:@"附件大小"]) {
        cell.textLabel.text=str_title;
        cell.textLabel.numberOfLines=0;
        
        NSObject *obj_data= [_arr_data objectAtIndex:indexPath.row];
        NSString *str_data=@"";
        if (obj_data!=[NSNull null]) {
            str_data=(NSString*)obj_data;
        }
        cell.detailTextLabel.text=str_data;
        cell.detailTextLabel.numberOfLines=0;
    }
    
    return cell;
    
}

//下载
-(void)DownLoad:(UIButton*)btn {
    NSString *str_url=btn.accessibilityHint;
    [btn setTitle:@"暂   停" forState:UIControlStateNormal];
    [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [btn addTarget:self action:@selector(DownLoadPause:) forControlEvents:UIControlEventTouchUpInside];
    if (str_url!=nil) {
         [self DownLoadFile:str_url btn:btn];
    }
   
}

//文件查看
-(void)LookUp:(UIButton*)btn {
    if (_isDownLoad==NO) {
        if (str_file_category!=nil) {
            if (![str_file_category isEqualToString:@"rar"] && ![str_file_category isEqualToString:@"zip"] ) {
                NSString *str_url=btn.accessibilityHint;
                //   NSLog(@"查看url");
                AttachmentVC *vc=[[AttachmentVC alloc]init];
                vc.str_url=str_url;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    else {
        
    }
    
}


//解压
-(void)Unzip:(UIButton*)btn {
    NSString *str_path=btn.accessibilityHint;
  //  NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
   // if ([str_file_category isEqualToString:@"zip"]) {
        NSFileManager *fileManager=[[NSFileManager alloc]init];
        NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
       
        NSMutableArray *arr_files=[[NSMutableArray alloc]init];
        NSString *str_zip_filename=@"";
        for (int i=0; i<_arr_title.count; i++) {
            NSString *str_title=[_arr_title objectAtIndex:i];
            if ([str_title isEqualToString:@"附件名称"]) {
                NSString *str_tmp_name=[_arr_data objectAtIndex:i];
                NSArray *arr_tmp=[str_tmp_name componentsSeparatedByString:@"."];
                str_zip_filename=[arr_tmp objectAtIndex:0];
                break;
            }
        }

        NSString *createPath=[NSString stringWithFormat:@"%@/%@",pathDocuments,str_zip_filename];
        if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
            [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    
    
        [self unArchive:str_path andPassword:nil destinationPath:createPath];
    
        NSArray *tempArray=[fileManager contentsOfDirectoryAtPath:createPath error:nil];
    
        for (NSString *fileName in tempArray) {
            NSString *fullPath= [createPath stringByAppendingPathComponent:fileName];
            if ([fileManager fileExistsAtPath:fullPath]) {
                //先不考虑压缩包套压缩包的问题
                if ([fileName rangeOfString:@"zip"].location==NSNotFound && [fileName rangeOfString:@"rar"].location==NSNotFound) {
                     [arr_files addObject:fileName];
                }
                
            }
        }
        UnzipedFileVC *vc = [[UnzipedFileVC alloc]init];
        vc.str_title=str_zip_filename;
        vc.arr_files=arr_files;
        vc.str_dir=createPath;
        
        NSLog(@"解压缩成功!");
        
        [self.navigationController pushViewController:vc animated:YES];
   // }
   
}


-(void)DownLoadFile:(NSString*)str_url btn:(UIButton*)btn{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL=[NSURL URLWithString:str_url];

    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat f_progress=1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        NSLog(@"%lf",f_progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progress_view setProgress:f_progress animated:YES];
            NSString *str_percent=[NSString stringWithFormat:@"%.2f%@",f_progress*100.0,@"%"];
            _lbl_percentage.text=str_percent;
        });
    }
   destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *str_filePath = [pathDocuments  stringByAppendingPathComponent:str_file_name];
        NSFileManager *manager=[[NSFileManager alloc]init];
        if ([manager fileExistsAtPath:str_filePath]) {
            NSLog(@"可以找到");
            btn.accessibilityHint=str_filePath;
        }
       
        if ([str_file_category isEqualToString:@"zip"] || [str_file_category isEqualToString:@"rar"]) {
            [btn setTitle:@"解    压" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(Unzip:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [btn setTitle:@"预    览" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(FilePreview:) forControlEvents:UIControlEventTouchUpInside];
            [_btn_share setTitle:@"其他应用打开" forState:UIControlStateNormal];
            _btn_share.accessibilityHint=filePath.absoluteString;
            [_btn_share addTarget:self action:@selector(FileShare:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_btn_share];
            [self.view setNeedsDisplay];
        }
       
        
        NSLog(@"File downloaded to: %@", filePath);
    }];
     
  
    [downloadTask resume];
    
  //  [self.progress_view setProgressWithDownloadProgressOfTask:downloadTask animated:YES];
}


-(void)DownLoadPause:(UIButton*)btn {
    [btn setTitle:@"继    续" forState:UIControlStateNormal];
    [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [btn addTarget:self action:@selector(DownLoadResume:) forControlEvents:UIControlEventTouchUpInside];
    if (downloadTask!=nil) {
        [downloadTask suspend];
    }
}


-(void)DownLoadResume:(UIButton*)btn {
    [btn setTitle:@"暂   停" forState:UIControlStateNormal];
    [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [btn addTarget:self action:@selector(DownLoadPause:) forControlEvents:UIControlEventTouchUpInside];
    if (downloadTask!=nil) {
        [downloadTask resume];
    }
}

-(void)FilePreview:(UIButton*)btn {
    NSLog(@"查看文件");
    //如果是pdf，jpg,png等文件，则用程序打开，其他则用第三方打开
    NSString *str_url=btn.accessibilityHint;
    NSURL *url=[NSURL fileURLWithPath:str_url];
    _documentController=[UIDocumentInteractionController interactionControllerWithURL:url];
    [_documentController setDelegate:self];
    [_documentController presentPreviewAnimated:YES];
  
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    
    //注意：此处要求的控制器，必须是它的页面view，已经显示在window之上了
    return self.navigationController;
}


-(void)FileShare:(UIButton*)btn {
    NSString *str_url=btn.accessibilityHint;
    NSURL *url=[NSURL fileURLWithPath:str_url];
    _documentController=[UIDocumentInteractionController interactionControllerWithURL:url];
    [_documentController setDelegate:self];
    [_documentController presentOpenInMenuFromRect:btn.frame inView:self.view animated:YES];
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer*)sender {
    
}

//解压zip和rar文件
- (void)unArchive: (NSString *)filePath andPassword:(NSString*)password destinationPath:(NSString *)destPath{
    NSAssert(filePath, @"can't find filePath");
    SARUnArchiveANY *unarchive = [[SARUnArchiveANY alloc]initWithPath:filePath];
    if (password != nil && password.length > 0) {
        unarchive.password = password;
    }
    
    if (destPath != nil)
        unarchive.destinationPath = destPath;//(Optional). If it is not given, then the file is unarchived in the same location of its archive/file.
    unarchive.completionBlock = ^(NSArray *filePaths){
        NSLog(@"For Archive : %@",filePath);
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"US Presidents://"]]) {
            NSLog(@"US Presidents app is installed.");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"US Presidents://"]];
        }
        
        for (NSString *filename in filePaths) {
            NSLog(@"File: %@", filename);
        }
    };
    unarchive.failureBlock = ^(){
        //        NSLog(@"Cannot be unarchived");
    };
    [unarchive decompress];
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
