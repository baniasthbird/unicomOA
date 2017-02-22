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
#import "OAViewController.h"
#import "WaveProgressView.h"




@interface TableFilesDetail ()<UIDocumentInteractionControllerDelegate,UIGestureRecognizerDelegate> {
    UIDocumentInteractionController *_documentController;   //文档交互控制器
}


@property (nonatomic,strong) UIButton *btn_download;

//@property (nonatomic,strong) CustomSlider *slider;

@property (nonatomic, assign) BOOL isDownLoad;

@property (nonatomic, assign) BOOL isResume;


@property (nonatomic,strong) UIButton *btn_share;

@property (nonatomic,strong) AFURLSessionManager *manager;

@property (nonatomic, strong) WaveProgressView *waveProgress;



@end

@implementation TableFilesDetail {
    //文件类型
    NSString *str_file_category;
    //文件名
    NSString *str_file_name;
    
    int i_value;
    
    DataBase *db;
    
    
    NSString *str_file_title;
    
    CGFloat f_percent;
    
    NSString *str_file_size;
    
    NSString *str_file_ID;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    db=[DataBase sharedinstanceDB];
    
    self.title=_str_title;
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
   
    
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
    NSInteger l4=0;
    NSInteger l5=0;
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
        else if ([str_title isEqualToString:@"上传时间"]) {
            l4=i;
        }
        else if ([str_title isEqualToString:@"附件id"]) {
            l5=i;
        }
    }
    
    NSString *str_size=[_arr_data objectAtIndex:l1];
    NSInteger i_size=[str_size integerValue];
    str_file_size=str_size;
    
    NSString *str_file_id=[_arr_data objectAtIndex:l5];
    str_file_ID=str_file_id;
    NSString *str_url_link=[_arr_data objectAtIndex:l2];
    NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
    NSString *str_urldata= [str_url_link stringByTrimmingCharactersInSet:whitespace];
    NSString *str_substring=[str_urldata substringWithRange:NSMakeRange(0, 1)];
    if (![str_substring isEqualToString:@"/"]) {
        str_urldata=[NSString stringWithFormat:@"%@%@",@"/",str_urldata];
    }
   // NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@%@",@"http://",str_ip,str_port,@"/default/mobile/oa/download.jsp?isOpen=false&fileid=",str_file_id];
    NSString *str_url=[self GetFileUrl];
    
    barButtonItem.accessibilityHint=str_url;
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    UIImageView *img_Logo=[[UIImageView alloc]initWithFrame:CGRectMake(0.38*Width, 0.1223*Height, 0.2447*Width, 0.1114*Height)];
    img_Logo.image=[UIImage imageNamed:@"filefolder.png"];
    
  
    
    UILabel *lbl_file_name=[[UILabel alloc]initWithFrame:CGRectMake(50, 0.2663*Height, Width-100, 0.03*Height)];
    lbl_file_name.textColor=[UIColor colorWithRed:5/255.0f green:5/255.0f blue:5/255.0f alpha:1];
    lbl_file_name.textAlignment=NSTextAlignmentCenter;
    lbl_file_name.font=[UIFont systemFontOfSize:20];
    lbl_file_name.text=[_arr_data objectAtIndex:l3];
    lbl_file_name.numberOfLines=0;
    
    UILabel *lbl_file_time=[[UILabel alloc]initWithFrame:CGRectMake(50, 0.325*Height, Width-100, 0.022645*Height)];
    lbl_file_time.textColor=[UIColor colorWithRed:155/255.0f green:155/255.0f blue:155/255.0f alpha:1];
    lbl_file_time.textAlignment=NSTextAlignmentCenter;
    lbl_file_time.font=[UIFont systemFontOfSize:18];
    lbl_file_time.text=[_arr_data objectAtIndex:l4];

    
    NSString *str_tmp_name=[_arr_data objectAtIndex:l3];
    str_file_title=str_tmp_name;
    NSArray *arr_tmp=[str_tmp_name componentsSeparatedByString:@"."];
    if (arr_tmp!=nil && [arr_tmp count]>0) {
        str_file_category=[arr_tmp lastObject];
    }

  //  NSArray *arr_link_name=[str_url_link componentsSeparatedByString:@"/"];
    str_file_name=[NSString stringWithFormat:@"%@.%@",str_file_id,str_file_category];
   // NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  //  NSString *filePath = [pathDocuments  stringByAppendingPathComponent:str_file_name];
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:str_file_name];
    NSFileManager *file_manager=[[NSFileManager alloc]init];
    if ([file_manager fileExistsAtPath:fileURL.relativePath]) {
        NSLog(@"已有文件");
        _isDownLoad=YES;
    }
    else {
        NSLog(@"待下载");
        _isDownLoad=NO;
    }
    
    _btn_download=[[UIButton alloc]initWithFrame:CGRectMake(0.0805*Width, Height*0.4248,Width*0.839,0.07156*Height)];
    _btn_download.layer.cornerRadius=5;
    _btn_download.backgroundColor=[UIColor whiteColor];
    [_btn_download setTitleColor:[UIColor colorWithRed:83/255.0f green:127/255.0f blue:238/255.0f alpha:1] forState:UIControlStateNormal];
    _btn_download.titleLabel.font=[UIFont systemFontOfSize:21];
    
    _btn_share=[[UIButton alloc]initWithFrame:CGRectMake(0.0805*Width, Height*0.548,Width*0.839,0.07156*Height)];
    _btn_share.layer.cornerRadius=5;
    _btn_share.backgroundColor=[UIColor whiteColor];
    [_btn_share setTitleColor:[UIColor colorWithRed:83/255.0f green:127/255.0f blue:238/255.0f alpha:1] forState:UIControlStateNormal];
    _btn_share.titleLabel.font=[UIFont systemFontOfSize:21];
    
    if (_isDownLoad==NO) {
        _btn_download.accessibilityHint=str_url;
        if (_partialData==nil) {
            if ([str_file_category isEqualToString:@"zip"] || [str_file_category isEqualToString:@"rar"]) {
                [_btn_download setTitle:@"下   载" forState:UIControlStateNormal];
                _btn_download.tag=1001;
                [_btn_download addTarget:self action:@selector(DownLoad:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
             //   if (i_size>2000) {
                    [_btn_download setTitle:@"下   载" forState:UIControlStateNormal];
                    _btn_download.tag=1001;
                    [_btn_download addTarget:self action:@selector(DownLoad:) forControlEvents:UIControlEventTouchUpInside];
            /*
                }
                else {
                    [_btn_download setTitle:@"查   看" forState:UIControlStateNormal];
                    _btn_download.tag=1002;
                    [_btn_download addTarget:self action:@selector(LookUp:) forControlEvents:UIControlEventTouchUpInside];
                }
             */
            }
        }
        else {
            _isResume=YES;
             [_btn_download setTitle:@"继   续" forState:UIControlStateNormal];
            _btn_download.tag=1005;
            [_btn_download addTarget:self action:@selector(DownLoadResume:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else {
        _btn_download.accessibilityHint=fileURL.relativePath;
        if ([str_file_category isEqualToString:@"zip"] || [str_file_category isEqualToString:@"rar"]) {
            [_btn_download setTitle:@"打    开" forState:UIControlStateNormal];
            _btn_download.tag=1003;
            [_btn_download addTarget:self action:@selector(Unzip:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [_btn_download setTitle:@"预    览" forState:UIControlStateNormal];
            _btn_download.tag=1004;
            [_btn_download addTarget:self action:@selector(FilePreview:) forControlEvents:UIControlEventTouchUpInside];
            [_btn_share setTitle:@"其他应用打开" forState:UIControlStateNormal];
            _btn_share.accessibilityHint=fileURL.relativePath;
            [_btn_share addTarget:self action:@selector(FileShare:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
   
    
    
    
    [self.view addSubview:_btn_download];
    if (_btn_download.tag==1004) {
        [self.view addSubview:_btn_share];
    }
    
    if (_btn_download.tag==1001) {
      //   [self.view addSubview:_lbl_percentage];
        if(!_waveProgress)
        {
            _waveProgress = [[WaveProgressView alloc] initWithFrame:CGRectMake(0.38*Width, 0.1223*Height, 0.2447*Width, 0.1114*Height)];
            [self.view addSubview:_waveProgress];
        }
        else {
            if (_isDownLoad==NO) {
                [_waveProgress initWave];
            }
        }
    }
    else if (_btn_download.tag==1005) {
        if(!_waveProgress)
        {
            _waveProgress = [[WaveProgressView alloc] initWithFrame:CGRectMake(0.38*Width, 0.1223*Height, 0.2447*Width, 0.1114*Height)];
            CGFloat tmp_progress=[_partialData_percent floatValue];
            _waveProgress.percent=tmp_progress;
            NSString *str_percent=[NSString stringWithFormat:@"%.2f%@",tmp_progress*100.0,@"%"];
            _waveProgress.centerLabel.text=str_percent;
            [self.view addSubview:_waveProgress];
        }
        else {
            if (_isDownLoad==NO) {
                [_waveProgress initWave];
                _waveProgress.percent=[_partialData_percent floatValue];
                CGFloat tmp_progress=[_partialData_percent floatValue];
                _waveProgress.percent=tmp_progress;
                NSString *str_percent=[NSString stringWithFormat:@"%.2f%@",tmp_progress*100.0,@"%"];
                _waveProgress.centerLabel.text=str_percent;
            }
        }
    }
    else {
        [self.view addSubview:img_Logo];
    }
    
   
    //侧滑返回
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    
    // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    
    
    // 一定要禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    [self.view addSubview:lbl_file_name];
    [self.view addSubview:lbl_file_time];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MovePreviousVc:(UIButton*)sender {
     NSString *str_percent=[NSString stringWithFormat:@"%f",f_percent];
    if (_downloadTask!=nil) {
        if (_downloadTask.error==nil) {
            if (_downloadTask.state==NSURLSessionTaskStateSuspended) {
                str_percent=_btn_download.accessibilityValue;
                [_downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                    self.partialData=resumeData;
                    NSDictionary *dic_data=[NSDictionary dictionary];
                    if (resumeData!=nil) {
                         dic_data=[NSDictionary dictionaryWithObjectsAndKeys:str_file_title,@"title",resumeData,@"data",str_percent,@"percent",_downloadTask,@"downloadTask",nil];
                    }
                    [self.delegate PassPartialData:dic_data];
                }];
            }
            else if (_downloadTask.state==NSURLSessionTaskStateRunning) {
                NSDictionary *dic_downloadTask=[NSDictionary dictionaryWithObjectsAndKeys:str_file_title,@"title",_downloadTask,@"downloadTask",str_percent,@"percent",nil];
                [self.delegate PassPartialData:dic_downloadTask];
            }
        }
        else {
            /*
            NSError *error=_downloadTask.error;
            NSDictionary *dic_error=error.userInfo;
            NSData *resumeData=[dic_error objectForKey:@"NSURLSessionDownloadTaskResumeData"];
            str_percent=_btn_download.accessibilityValue;
            NSDictionary *dic_data=[NSDictionary dictionaryWithObjectsAndKeys:str_file_title,@"title",str_percent,@"percent",resumeData,@"data",nil];
               // [self.delegate PassPartialData:dic_data];
            */
        }

    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark tableview方法

//下载
-(void)DownLoad:(UIButton*)btn {
    NSString *str_url=btn.accessibilityHint;
    [btn setTitle:@"暂   停" forState:UIControlStateNormal];
    [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [btn addTarget:self action:@selector(DownLoadPause:) forControlEvents:UIControlEventTouchUpInside];
    if (str_url!=nil) {
        CGFloat i_totalsize=[str_file_size floatValue];
        [self DownLoadFile:str_url btn:btn file_id:str_file_ID totalsize:i_totalsize];
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
    
       //不要每次都解压
    
    NSArray *tempArray=[fileManager contentsOfDirectoryAtPath:createPath error:nil];
    if (tempArray==nil || tempArray.count==0) {
        [self unArchive:str_path andPassword:nil destinationPath:createPath];
        tempArray=[fileManager contentsOfDirectoryAtPath:createPath error:nil];
    }

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


-(void)DownLoadFile:(NSString*)str_url btn:(UIButton*)btn file_id:(NSString*)str_file_id totalsize:(CGFloat)i_totalsize{
    
    //退回后后台下载可以继续
   // NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:str_file_name];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
   // str_url=@"http://192.168.1.65/default/uploadfile/XMYY_YYSQ/20170206/143_B502626088_370857395_undefined.pdf";
    NSURL *URL=[NSURL URLWithString:str_url];

    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    

    _downloadTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * downloadProgress) {
            CGFloat f_progress=1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            f_percent=f_progress;
            NSLog(@"%lf",f_progress);
            dispatch_async(dispatch_get_main_queue(), ^{
                UINavigationController *nav=(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                OAViewController *oa_vc=[nav.viewControllers objectAtIndex:1];
                UINavigationController *nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:0];
                NSURL *tmp_url=request.URL;
                if ([nav_main.viewControllers.lastObject isKindOfClass:[TableFilesDetail class]]) {
                        [self DownLoadProgress:nav_main progress:f_progress url:tmp_url] ;
                }
                else {
                    nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:2];
                    if ([nav_main.viewControllers.lastObject isKindOfClass:[TableFilesDetail class]]) {
                        [self DownLoadProgress:nav_main progress:f_progress url:tmp_url];
                    }
                }
            });
       
    }
   destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
       NSString *str_suggestname=[response.suggestedFilename stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       //把名称换成id号 0215 明天改方法
       NSString *str_FileName=[NSString stringWithFormat:@"%@.%@",str_file_id,str_file_category];
        return [documentsDirectoryURL URLByAppendingPathComponent:str_FileName];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        UINavigationController *nav=(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        OAViewController *oa_vc=[nav.viewControllers objectAtIndex:1];
        UINavigationController *nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:0];
        NSURL *tmp_url=request.URL;
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSString *str_FileName=[NSString stringWithFormat:@"%@.%@",str_file_id,str_file_category];
        NSURL *doc_file_Path=[documentsDirectoryURL URLByAppendingPathComponent:str_FileName];
        if ([nav_main.viewControllers.lastObject isKindOfClass:[TableFilesDetail class]])  {
            if (filePath!=nil) {
                [self DownLoadFinished:nav_main filePath:doc_file_Path url:tmp_url];
            }
            
        }
        else {
            nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:2];
            if ([nav_main.viewControllers.lastObject isKindOfClass:[TableFilesDetail class]]){
                if (filePath!=nil) {
                    [self DownLoadFinished:nav_main filePath:doc_file_Path url:tmp_url];
                }
                
            }
        }
       
    }];
    
    /*
   // __block TableFilesDetail *blockSelf=self;
    [_manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        CGFloat f_progress= (totalBytesWritten/(1024.0))/i_totalsize;
        f_percent=f_progress;
        NSLog(@"%f",f_progress);
        NSLog(@"%lf",f_progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            UINavigationController *nav=(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            OAViewController *oa_vc=[nav.viewControllers objectAtIndex:1];
            UINavigationController *nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:0];
            NSURL *tmp_url=request.URL;
            if ([nav_main.viewControllers.lastObject isKindOfClass:[TableFilesDetail class]]) {
                [self DownLoadProgress:nav_main progress:f_progress url:tmp_url] ;
            }
            else {
                nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:2];
                if ([nav_main.viewControllers.lastObject isKindOfClass:[TableFilesDetail class]]) {
                    [self DownLoadProgress:nav_main progress:f_progress url:tmp_url];
                }
            }
        });
    }];
    */
    [_downloadTask resume];
    
  //  [self.progress_view setProgressWithDownloadProgressOfTask:downloadTask animated:YES];
}


-(void)DownLoadPause:(UIButton*)btn {
    [btn setTitle:@"继    续" forState:UIControlStateNormal];
    [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [btn addTarget:self action:@selector(DownLoadResume:) forControlEvents:UIControlEventTouchUpInside];
    btn.accessibilityValue=[NSString stringWithFormat:@"%f",f_percent];
    //NSString *str_url=btn.accessibilityHint;
    NSLog(@"%@", _downloadTask.description);
    if (_isResume==YES) {
        _isResume=NO;
    }
    
    if (_downloadTask.state== NSURLSessionTaskStateRunning) {
        [_downloadTask suspend];
    }
    
    UINavigationController *nav=(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    OAViewController *oa_vc=[nav.viewControllers objectAtIndex:1];
    UINavigationController *nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:0];
    TableFilesDetail *vc_tb=nav_main.viewControllers.lastObject;
    NSURL *url=[NSURL URLWithString:btn.accessibilityHint];
    if ([self FindTheTableFilesDetail:vc_tb url:url]) {
        vc_tb.navigationItem.leftBarButtonItem.enabled=NO;
        if (vc_tb.view.gestureRecognizers.count>0) {
            for (int i=0; i<vc_tb.view.gestureRecognizers.count; i++) {
                UIGestureRecognizer *tmp_rc=[vc_tb.view.gestureRecognizers objectAtIndex:i];
                [vc_tb.view removeGestureRecognizer:tmp_rc];
            }
        }
    }
    
   
    NSError *error=_downloadTask.error;
    NSLog(@"%@%@",@"pause:",error.description);
}


-(void)DownLoadResume:(UIButton*)btn {
    [btn setTitle:@"暂   停" forState:UIControlStateNormal];
    [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [btn addTarget:self action:@selector(DownLoadPause:) forControlEvents:UIControlEventTouchUpInside];
    
    UINavigationController *nav=(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    OAViewController *oa_vc=[nav.viewControllers objectAtIndex:1];
    UINavigationController *nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:0];
    TableFilesDetail *vc_tb=nav_main.viewControllers.lastObject;
    NSURL *url=[NSURL URLWithString:btn.accessibilityHint];
    if ([self FindTheTableFilesDetail:vc_tb url:url]) {
        vc_tb.navigationItem.leftBarButtonItem.enabled=YES;
        if (vc_tb.view.gestureRecognizers.count==0) {
            //侧滑返回
            id target = vc_tb.navigationController.interactivePopGestureRecognizer.delegate;
            
            // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
            panGesture.delegate = self; // 设置手势代理，拦截手势触发
            [vc_tb.view addGestureRecognizer:panGesture];
        }
    }
    

    
    if (_isResume==YES) {
        if (_partialData) {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            _downloadTask =[_manager downloadTaskWithResumeData:_partialData progress:^(NSProgress * _Nonnull downloadProgress) {
                CGFloat f_progress=1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                NSLog(@"%lf",f_progress);
                f_percent=f_progress;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UINavigationController *nav=(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                    OAViewController *oa_vc=[nav.viewControllers objectAtIndex:1];
                    UINavigationController *nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:0];
                    NSURL *tmp_url=[NSURL URLWithString:btn.accessibilityHint];
                    if ([nav_main.viewControllers.lastObject isKindOfClass:[TableFilesDetail class]]) {
                        [self DownLoadProgress:nav_main progress:f_progress url:tmp_url] ;
                    }
                    else {
                        nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:2];
                        if ([nav_main.viewControllers.lastObject isKindOfClass:[TableFilesDetail class]]) {
                            [self DownLoadProgress:nav_main progress:f_progress url:tmp_url];
                        }
                    }
                });
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                NSString *str_FileName=[NSString stringWithFormat:@"%@.%@",str_file_ID,str_file_category];
                return [documentsDirectoryURL URLByAppendingPathComponent:str_FileName];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                UINavigationController *nav=(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                OAViewController *oa_vc=[nav.viewControllers objectAtIndex:1];
                UINavigationController *nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:0];
                NSURL *tmp_url=[NSURL URLWithString:btn.accessibilityHint];
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                NSString *str_FileName=[NSString stringWithFormat:@"%@.%@",str_file_ID,str_file_category];
                NSURL *doc_file_Path=[documentsDirectoryURL URLByAppendingPathComponent:str_FileName];
                if ([nav_main.viewControllers.lastObject isKindOfClass:[TableFilesDetail class]])  {
                    if (filePath!=nil) {
                        [self DownLoadFinished:nav_main filePath:doc_file_Path url:tmp_url];
                    }
                    
                }
                else {
                    nav_main=(UINavigationController*)[oa_vc.viewControllers objectAtIndex:2];
                    if ([nav_main.viewControllers.lastObject isKindOfClass:[TableFilesDetail class]]){
                        if (filePath!=nil) {
                            [self DownLoadFinished:nav_main filePath:doc_file_Path url:tmp_url];
                        }
                        
                    }
                }
                
            }];
            
            [_downloadTask resume];
        }
    }
    
    if (_downloadTask.state==NSURLSessionTaskStateSuspended) {
        [_downloadTask resume];
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

-(void)viewDidDisappear:(BOOL)animated {
    NSLog(@"消失");
    [super viewDidDisappear:animated];
}

//下载事件
-(void)DownLoadProgress:(UINavigationController*)nav_main progress:(CGFloat)f_progress url:(NSURL*)url {
    TableFilesDetail *vc_tb=nav_main.viewControllers.lastObject;
    if ([self FindTheTableFilesDetail:vc_tb url:url]) {
        NSString *str_percent=[NSString stringWithFormat:@"%.2f%@",f_progress*100.0,@"%"];
        vc_tb.waveProgress.percent=f_progress;
        vc_tb.waveProgress.centerLabel.text=str_percent;
        
        [vc_tb.btn_download setTitle:@"暂   停" forState:UIControlStateNormal];
        [vc_tb.btn_download removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [vc_tb.btn_download addTarget:self action:@selector(DownLoadPause:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
   
}

//下载完成事件
-(void)DownLoadFinished:(UINavigationController*)nav_main filePath:(NSURL*)filePath url:(NSURL*)url{
    TableFilesDetail *vc_tb=nav_main.viewControllers.lastObject;
    if ([vc_tb FindTheTableFilesDetail:vc_tb url:url]) {
        [vc_tb.btn_download removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
      //  NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
     //   NSString *str_filePath = [pathDocuments  stringByAppendingPathComponent:str_file_name];
        NSFileManager *manager=[[NSFileManager alloc]init];
        
        if ([manager fileExistsAtPath:filePath.relativePath]) {
            NSLog(@"可以找到");
            vc_tb.btn_download.accessibilityHint=filePath.relativePath;
        }
        
         [vc_tb.waveProgress clearWave];
        UIGraphicsBeginImageContext(vc_tb.waveProgress.frame.size);
        [[UIImage imageNamed:@"filefolder"] drawInRect:vc_tb.waveProgress.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        vc_tb.waveProgress.backgroundColor = [UIColor colorWithPatternImage:image];
       
        
        
        if ([str_file_category isEqualToString:@"zip"] || [str_file_category isEqualToString:@"rar"]) {
            [vc_tb.btn_download setTitle:@"打    开" forState:UIControlStateNormal];
            [vc_tb.btn_download addTarget:self action:@selector(Unzip:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            _documentController=[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath.absoluteString]];
            if (![_documentController.UTI isEqualToString:@"public.data"]) {
                [vc_tb.btn_download setTitle:@"预    览" forState:UIControlStateNormal];
              //  vc_tb.btn_download.accessibilityHint=filePath.absoluteString;
                [vc_tb.btn_download addTarget:self action:@selector(FilePreview:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                [vc_tb.btn_download setHidden:YES];
            }
            [_btn_share setTitle:@"其他应用打开" forState:UIControlStateNormal];
            _btn_share.accessibilityHint=filePath.relativePath;
            [_btn_share addTarget:self action:@selector(FileShare:) forControlEvents:UIControlEventTouchUpInside];
            [vc_tb.view addSubview:_btn_share];
            [vc_tb.view setNeedsDisplay];
        }
        NSLog(@"File downloaded to: %@", filePath);
    }
   
}

-(void)RefreshViewData {
   // [self viewDidLoad];
    [_btn_share removeFromSuperview];
    [_btn_download removeFromSuperview];
    [_waveProgress initWave];
    _btn_download=[[UIButton alloc]initWithFrame:CGRectMake(0.0805*Width, Height*0.4248,Width*0.839,0.07156*Height)];
    _btn_download.layer.cornerRadius=5;
    _btn_download.backgroundColor=[UIColor whiteColor];
    [_btn_download setTitleColor:[UIColor colorWithRed:83/255.0f green:127/255.0f blue:238/255.0f alpha:1] forState:UIControlStateNormal];
    _btn_download.titleLabel.font=[UIFont systemFontOfSize:21];
    [_btn_download setTitle:@"下   载" forState:UIControlStateNormal];
    _btn_download.tag=1001;
    _btn_download.accessibilityHint=[self GetFileUrl];
    [_btn_download addTarget:self action:@selector(DownLoad:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_download];
    NSLog(@"测试");
    [self.view setNeedsDisplay];
}

//用url找到那个唯一的tableFilesDetail
-(BOOL)FindTheTableFilesDetail:(TableFilesDetail*)vc_tb  url:(NSURL*)url{
    NSInteger l=0;
    for (int i=0; i<vc_tb.arr_title.count; i++) {
        NSString *str_title=[vc_tb.arr_title objectAtIndex:i];
        if ([str_title isEqualToString:@"附件id"]) {
            l=i;
            break;
        }
    }
    NSString *str_id=[vc_tb.arr_data objectAtIndex:l];
    /*
    NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
    NSString *str_urldata= [str_url_link stringByTrimmingCharactersInSet:whitespace];
    NSString *str_substring=[str_urldata substringWithRange:NSMakeRange(0, 1)];
    if (![str_substring isEqualToString:@"/"]) {
        str_urldata=[NSString stringWithFormat:@"%@%@",@"/",str_urldata];
    }
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@%@",@"http://",str_ip,str_port,@"/default",str_urldata];
     */
    
    if ([str_id isEqualToString:str_file_ID]) {
        return YES;
    }
    else {
        return NO;
    }
}

-(NSString*)GetFileUrl {
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }

    int l5=0;
    int l2=0;
    for (int i=0; i<_arr_title.count; i++) {
        NSString *str_title=[_arr_title objectAtIndex:i];
        if ([str_title isEqualToString:@"附件id"]) {
            l5=i;
        }
        else if ([str_title isEqualToString:@"附件路径"]) {
            l2=i;
        }
    }

    NSString *str_file_id=@"";
    NSString *str_url=@"";
    if (l5>0) {
        str_file_id=[_arr_data objectAtIndex:l5];
        str_url=[NSString stringWithFormat:@"%@%@:%@%@%@",@"http://",str_ip,str_port,@"/default/mobile/oa/download.jsp?isOpen=false&fileid=",str_file_id];
    }
    else {
        NSString *str_path=[_arr_data objectAtIndex:l2];
      // str_url=@"http://192.168.1.65/default/uploadfile/XMYY_YYSQ/20170206/143_B502626088_370857395_undefined.pdf"
        str_url=[NSString stringWithFormat:@"%@%@:%@%@%@",@"http://",str_ip,str_port,@"/default/",str_path];
    }
    
    
    return str_url;
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
