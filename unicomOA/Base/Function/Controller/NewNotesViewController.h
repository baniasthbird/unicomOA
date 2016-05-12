//
//  NewNotesViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/2/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotePassValueDelegate.h"
#import "UserInfo.h"


@interface NewNotesViewController : UIViewController {
    NSObject<UINoteViewPassValueDelegate> *delegate;
}

@property (nonatomic,strong) UserInfo *usrInfo;

@property(nonatomic,retain) NSObject<UINoteViewPassValueDelegate> *delegate;

@property   NSInteger i_index;

//传值
@property (strong,nonatomic) NSString *str_noteContent;

@property (strong,nonatomic) NSString *str_FenLei;

@property (strong,nonatomic) NSString *str_time;


@end
