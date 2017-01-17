//
//  ServerIPViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/3/23.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServerIPViewController;
@protocol ServerIPViewControllerDelegate <NSObject>

-(void)RefreshIP:(NSString*)str_name pwd:(NSString*)str_pwd;

@end

@interface ServerIPViewController : UIViewController

@property (nonatomic,strong) id<ServerIPViewControllerDelegate> delegate;

@property (nonatomic,strong) NSString *str_username;

@property (nonatomic,strong) NSString *str_pwd;

@end
