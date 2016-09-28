//
//  LGSettingItem.m
//  LGSettingViewDemo
//
//  Created by LiGo on 11/16/15.
//  Copyright © 2015 LiGo. All rights reserved.
//

#import "LGSettingItem.h"
#import "LGSettingSection.h"

@implementation LGSettingItem

+ (instancetype)initWithtitle:(NSString *)title type:(UITableViewCellAccessoryType)type{
    
    LGSettingItem *item = [[LGSettingItem alloc]init];
    item.title = title;
    if (iPhone4_4s || iPhone5_5s) {
        item.height = 40;
    }
    else {
        item.height=45;
    }
    
    item.type = type;
    return item;
}

@end
