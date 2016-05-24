//
//  Soundselectvc.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/24.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "Soundselectvc.h"
#import <AudioToolbox/AudioToolbox.h>

@interface Soundselectvc ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

//系统铃声目录
@property (nonatomic,strong) NSURL *str_soundpath;

//铃声数组
@property (nonatomic,strong) NSMutableArray *arr_sounds;

@property (nonatomic,strong) NSIndexPath *indexPath_selected;

@end

@implementation Soundselectvc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"选择铃声";
    
    UIButton *btn_Finish=[[UIButton alloc]initWithFrame:CGRectMake(0,0, 40, 40)];
    [btn_Finish setTitle:@"完成" forState:UIControlStateNormal];
    [btn_Finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_Finish addTarget:self action:@selector(SoundSelect:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_Finish];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
   
    _arr_sounds=[[NSMutableArray alloc]init];
    self.str_soundpath=[NSURL URLWithString:@"/System/Library/Audio/UISounds"];
    NSFileManager* fm=[NSFileManager defaultManager];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    NSDirectoryEnumerator *enumerator = [fm
                                         enumeratorAtURL:self.str_soundpath
                                         includingPropertiesForKeys:keys
                                         options:0
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             // Handle the error.
                                             // Return YES if the enumeration should continue after the error.
                                             return YES;
                                         }];
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            // handle error
        }
        else if (! [isDirectory boolValue]) {
            [_arr_sounds addObject:url];
        }
    }
    
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    [self.view addSubview:self.tableView];
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SoundSelect:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_arr_sounds!=nil) {
        return [_arr_sounds count];

    }
    else {
        return 10;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *cellIdentifier = @"cell";
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if (_arr_sounds!=nil) {
            cell.textLabel.text = [[_arr_sounds objectAtIndex:indexPath.row] lastPathComponent];
            NSURL *url=[_arr_sounds objectAtIndex:indexPath.row];
            NSString *str_url=[url absoluteString];
            cell.accessibilityHint=str_url;
        }
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_indexPath_selected!=indexPath) {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:_indexPath_selected];
        cell.textLabel.textColor=[UIColor blackColor];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSString *str_url=cell.accessibilityHint;
    cell.textLabel.textColor=[UIColor blueColor];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    NSURL *url=[NSURL URLWithString:str_url];
    SystemSoundID sound;
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&sound);
    if (error != kAudioServicesNoError) {
    }
    AudioServicesPlaySystemSound(sound);
    _indexPath_selected=indexPath;

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
