//
//  NotesViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/2/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotePassValueDelegate.h"
#import "NotesTableVIewCell.h"
#import "UserInfo.h"

@interface NotesViewController : UITableViewController<UINoteViewPassValueDelegate,NotesTableSlidCellDelegate>

@property (nonatomic,strong) UserInfo *user_Info;

@end
