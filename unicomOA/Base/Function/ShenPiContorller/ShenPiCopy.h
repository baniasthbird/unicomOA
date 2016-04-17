//
//  ShenPiCopy.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShenPiStatus.h"
#import "UserInfo.h"

//抄送页面
@class ShenPiCopy;

@protocol ShenPiCopyDelegate <NSObject>

-(void)SendShenPiCopyUser:(NSMutableArray*)usr_copy;

@end


@interface ShenPiCopy : UIViewController

@property (nonatomic,strong) id<ShenPiCopyDelegate> delegate;

@property (nonatomic,strong) UserInfo *userInfo;

@end
