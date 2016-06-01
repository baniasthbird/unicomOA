//
//  PrintApplicationDetailCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//备注信息 textView

@class PrintApplicationDetailCell;
@protocol PrintApplicationDetailCellDelegate<NSObject>

-(void)sendCellValue:(NSString*)str_text indexPath:(NSIndexPath*)i_indexPath;

@end

@interface PrintApplicationDetailCell : UITableViewCell

/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*)str_Name withPlaceHolder:(NSString*)str_placeHolder withText:(NSString*)str_text atIndexPath:(NSIndexPath*)indexPath atHeight:(CGFloat)i_Height;

@property (strong,nonatomic) UITextView *txt_detail;

@property (strong,nonatomic) NSIndexPath *i_indexPath;

@property (nonatomic,strong) id<PrintApplicationDetailCellDelegate> delegate;


@end
