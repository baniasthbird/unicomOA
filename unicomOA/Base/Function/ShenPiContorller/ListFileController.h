//
//  ListFileController.h
//  unicomOA
//
//  Created by hnsi-03 on 16/5/29.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListFileController;
@protocol ListFileControllerDelegate<NSObject>

-(void)sendBackValue:(NSMutableDictionary*)dic_backvalue indexPath:(NSIndexPath*)i_indexPath title:(NSString*)str_title;

@end

@interface ListFileController : UIViewController

@property (nonatomic,strong) NSArray *arr_value;


@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) NSIndexPath* indexPath;

@property  BOOL mutliselect;

@property (nonatomic,strong) id<ListFileControllerDelegate> delegate;


@end
