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
#import "YBMonitorNetWorkState.h"
#import "Mpush.h"
#import "OAViewController.h"
#import "MessageViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate ()<YBMonitorNetWorkStateDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate {
    NSString *remark;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //在这里判断是否可以系统更新
        // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:70/255.0f green:156/255.0f blue:241/255.0f alpha:1]];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //ios 10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击
        center.delegate= self;
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@",settings);
                }];
            } else {
                //点击不允许
                NSLog(@"注册失败");
            }
        }];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >=8.0) {
        UIUserNotificationSettings *settings=[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [application registerForRemoteNotifications];
    if (iPad) {
         [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_Nav-IPad.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImage *img_bg=[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"bg_Nav.png"]];
        [[UINavigationBar appearance] setBackgroundImage:img_bg forBarMetrics:UIBarMetricsDefault];
    }
    
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
         sleep(2);
    }
    
    if (application.applicationIconBadgeNumber!=0) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GetNotification"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GetNotification"];
    }

    [self enter];
    return YES;
}

-(void)enter {
    // 设置代理
    [YBMonitorNetWorkState shareMonitorNetWorkState].delegate = self;
    // 添加网络监听
    [[YBMonitorNetWorkState shareMonitorNetWorkState] addMonitorNetWorkState];
    
    [self netWorkStateChanged];
    NSString *str_url=@"https://app.hnsi.cn/hnti_soa/unicomOA.plist";
    BOOL b_update= [self checkUpdate:str_url];
    LoginViewController *login=[[LoginViewController alloc]init];
    login.b_update=b_update;
    if (remark!=nil) {
        login.str_remark=remark;
    }
    else {
        NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
        if ([currentNetWorkState isEqualToString:@"GPRS"]) {
            login.str_remark=@"检查系统更新失败，若要进行系统更新请切换至wifi模式或打开VPN";
        }
        
    }
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:login];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1],NSForegroundColorAttributeName,nil];
    [nav.navigationBar setTitleTextAttributes:attributes];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:attrs];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.window.rootViewController=nav;
}


-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSString *str_version= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        float d_version=[str_version floatValue];
        [[NSUserDefaults standardUserDefaults] setFloat:d_version forKey:@"systemversion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        NSString *str_version= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        float d_version=[str_version floatValue];
        float d_older_version=[[NSUserDefaults standardUserDefaults] floatForKey:@"systemversion"];
        NSString *str_version1=[self notRounding:d_version afterPoint:2];
        NSString *str_older_version=[self notRounding:d_older_version afterPoint:2];
        if (![str_version1 isEqualToString:str_older_version]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
            [[NSUserDefaults standardUserDefaults] setFloat:d_version forKey:@"systemversion"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
       
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
    NSURL *urlString=[NSURL URLWithString:str_url];
    NSURLResponse* urlResponse;
    NSError* error;
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
    if (data==nil) {
        NSLog(@"检查系统更新失败，请切换至wifi更新");
        return NO;
    }
    else {
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:str_url]];
        if (dict) {
            
            NSArray* list = [dict objectForKey:@"items"];
            NSDictionary* dict2 = [list objectAtIndex:0];
            
            NSDictionary* dict3 = [dict2 objectForKey:@"metadata"];
            NSString* newVersion = [dict3 objectForKey:@"bundle-version"];
            CGFloat f_newVersion=[newVersion floatValue];
            
            NSString *newRemark=[dict3 objectForKey:@"remark"];
            
            
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *myVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            CGFloat f_myVersion=[myVersion floatValue];
            
            if (f_newVersion>f_myVersion) {
                if (newRemark!=nil) {
                    remark=newRemark;
                }
                return YES;
            }
            else {
                
                return NO;
            }
        }
        else {
            return NO;
        }
    }
}

-(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
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
    if (application.applicationIconBadgeNumber!=0) {
        [self ChangeIcon];
        application.applicationIconBadgeNumber=0;
    }
    
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
    //app在前台收到推送消息调用此方法
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
    NSString *str_msg=[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
  //  [application setApplicationIconBadgeNumber:0];
    [self ChangeIcon];
    
    //app在前台运行时，针对推送消息单独处理
    if (application.applicationState==UIApplicationStateActive) {
        NSLog(@"前台运行");
    }
    else if (application.applicationState==UIApplicationStateBackground) {
        
    }
}

-(void)netWorkStateChanged {
    // 获取当前网络类型
    NSString *currentNetWorkState = [[YBMonitorNetWorkState shareMonitorNetWorkState] getCurrentNetWorkType];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentNetWorkState forKey:@"connection"];
    [defaults synchronize];
    
   // str_reachable=currentNetWorkState;
    
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"远程通知注册失败：%@",error);
//    LXAlertView *alert=[[LXAlertView alloc]initWithTitle:@"远程通知注册失败" message:error.description  cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
//        
//    }];
  //  [alert showLXAlertView];
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSMutableString *deviceTokenString1 = [NSMutableString string];
    const char *bytes = deviceToken.bytes;
    NSUInteger iCount = deviceToken.length;
    for (int i = 0; i < iCount; i++) {
        [deviceTokenString1 appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
//    LXAlertView *alert=[[LXAlertView alloc]initWithTitle:@"远程通知注册成功" message:deviceTokenString1  cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
//        
//    }];
   // [alert showLXAlertView];
    [MPUserDefaults setObject:deviceTokenString1 forKey:MPDeviceToken];
    //  NSLog(@"%@", deviceToken);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    //ios7-9系统受到推送通知的方法
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo=notification.request.content.userInfo;
    // 收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送的消息内容
    UNNotificationContent *content = request.content;
    //收到推送的角标
    NSNumber *badge= content.badge;
    //推送的消息
    NSString *body= content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    //推送消息的副标题
    NSString *subtitle=content.subtitle;
    
    //推送消息的标题
    NSString *title=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        [self ChangeIcon];
      //  LXAlertView *alert=[[LXAlertView alloc]initWithTitle:@"收到远程通知" message:content.body  cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
    //    }];
     //   [alert showLXAlertView];

    }
    else {
        //判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
    
}

// 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    //点击通知后，显示badge，获取XXX
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        [self ChangeIcon];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    // Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler();  // 系统要求执行这个方法
    
}


//改变消息左上角的ICON
-(void)ChangeIcon {
    UINavigationController *nav=(UINavigationController*)self.window.rootViewController;
    if (nav.viewControllers.count>1) {
        OAViewController *vc_oa=(OAViewController*)[nav.viewControllers objectAtIndex:1];
        UINavigationController *vc_sub=(UINavigationController*)[vc_oa.viewControllers objectAtIndex:0];
        MessageViewController *vc_msg=(MessageViewController*)[vc_sub.viewControllers objectAtIndex:0];
        UIBarButtonItem *button_item=  vc_msg.navigationItem.leftBarButtonItem;
        UIButton *btn_view=(UIButton*)button_item.customView;
        [btn_view setSelected:YES];
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        param[@"userId"]=[NSString stringWithFormat:@"%@",vc_msg.userInfo.str_empid];
        [vc_msg GetPushNotification:param];
        [vc_msg.view setNeedsDisplay];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GetNotification"];
    }
    
}



@end
