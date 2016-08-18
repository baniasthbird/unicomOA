//
//  LocalViewController.h
//  unicomOA
//
//  Created by hnsi-03 on 16/8/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocalViewController;
@protocol LocalViewControllerDelegate <NSObject>

@optional
-(void)localviewwithview:(LocalViewController *)localviewcontrol province:(NSString*)province city:(NSString*)city;

@end

@interface LocalViewController : UIViewController

@property (nonatomic, weak) id<LocalViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *currentTitle;

@end
