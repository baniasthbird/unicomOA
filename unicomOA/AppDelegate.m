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


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //在这里判断是否可以系统更新
        // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:70/255.0f green:156/255.0f blue:241/255.0f alpha:1]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_Nav.png"] forBarMetrics:UIBarMetricsDefault];
     NSString *str_url=@"https://app.hnsi.cn/hnti_soa/unicomOA.plist";
     BOOL b_update= [self checkUpdate:str_url];
     LoginViewController *login=[[LoginViewController alloc]init];
     login.b_update=b_update;
     UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:login];
     self.window.rootViewController=nav;
   
    
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1],NSForegroundColorAttributeName,nil];
    [nav.navigationBar setTitleTextAttributes:attributes];
    
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

@end
