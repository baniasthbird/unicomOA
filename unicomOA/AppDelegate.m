//
//  AppDelegate.m
//  unicomOA
//
//  Created by zr-mac on 16/2/14.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LXAlertView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XZMCoreNewFeatureVC.h"
#import "CALayer+Transition.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //在这里判断是否可以系统更新
        // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:70/255.0f green:156/255.0f blue:241/255.0f alpha:1]];
    
    if (iPad) {
         [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_Nav-IPad.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_Nav.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        self.window.rootViewController=[XZMCoreNewFeatureVC newFeatureVCWithImageNames:@[@"new1",@"new2",@"new3"] enterBlock:^{
            NSLog(@"进入主页面");
            [self enter];
        } configuration:^(UIButton *enterButton) {
            [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_nor"] forState:UIControlStateNormal];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_pressed"] forState:UIControlStateHighlighted];
            enterButton.bounds = CGRectMake(0, 0, 120, 40);
            enterButton.center = CGPointMake(KScreenW * 0.5, KScreenH* 0.85);
        }];
        /*
        if ([launchView isMemberOfClass:[UIImageView class]]) {
            UIImageView *img_launchView=(UIImageView*)launchView;
            [img_launchView setImage:[UIImage imageNamed:@"FirstImage"]];
        }
        
        // 这里判断是否第一次
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"第一次"
                                                      message:@"进入App"
                                                     delegate:self
                                            cancelButtonTitle:@"我知道了"
                                            otherButtonTitles:nil];
        [alert show];
        */
    }
    else {
        /*
        if ([launchView isMemberOfClass:[UIImageView class]]) {
           
        }
        sleep(2);
         */
        sleep(2);
        [self enter];
        
    }
   
   
    
    
    
    return YES;
}

-(void)enter {
    NSString *str_url=@"https://app.hnsi.cn/hnti_soa/unicomOA.plist";
    BOOL b_update= [self checkUpdate:str_url];
    LoginViewController *login=[[LoginViewController alloc]init];
    login.b_update=b_update;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:login];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1],NSForegroundColorAttributeName,nil];
    [nav.navigationBar setTitleTextAttributes:attributes];
    self.window.rootViewController=nav;
}


-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }

    /*
    UIViewController *viewController=[[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    UIView *launchView = viewController.view;
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:launchView.frame];
    imgView.image=[UIImage imageNamed:@"new1"];
    [launchView addSubview:imgView];
  */
    return YES;
}


-(BOOL)checkUpdate:(NSString*)str_url {
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:str_url]];
    if (dict) {
        
        NSArray* list = [dict objectForKey:@"items"];
        NSDictionary* dict2 = [list objectAtIndex:0];
        
        NSDictionary* dict3 = [dict2 objectForKey:@"metadata"];
        NSString* newVersion = [dict3 objectForKey:@"bundle-version"];
        CGFloat f_newVersion=[newVersion floatValue];
        
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *myVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
        CGFloat f_myVersion=[myVersion floatValue];
        
        if (f_newVersion>f_myVersion) {
            return YES;
        }
    }
    return NO;
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSString *str_content=notification.alertBody;
    NSString *str_soundname=notification.soundName;
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:str_content cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        
    }];
    [alert showLXAlertView];
    
    NSURL *path=[NSURL URLWithString:@"/System/Library/Audio/UISounds/alarm.caf"];
    SystemSoundID sound;
    if (path) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:str_soundname],&sound);
        
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)path,&sound);
        }
    }
    
    AudioServicesPlaySystemSound(sound);
}


-(void)application:(UIApplication*)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    
}



@end
