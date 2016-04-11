//
//  CarUser.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarUser;

@protocol CarUserDelgate <NSObject>

-(void)CarUserName:(NSString*)str_name;

@end

@interface CarUser : UIViewController

@property (nonatomic,unsafe_unretained) id<CarUserDelgate> delegate;

@end
