//
//  NewApplication.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarService.h"
#import "PrintService.h"

@class NewApplication;

@protocol NewApplicationDelegate <NSObject>

-(void)PassValueFromCarApplication:(NSString*)str_title CarObject:(CarService*)service;

-(void)PassValueFromPrintApplication:(NSString*)str_title PrintObject:(PrintService*)service;

@end

//新建审批

@interface NewApplication : UIViewController

@property (nonatomic,unsafe_unretained) id<NewApplicationDelegate> delegate;

@end
