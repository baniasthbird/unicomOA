//
//  LZActionSheet.h
//  LZActionSheetDemo
//
//  Created by LeoZ on 16/3/16.
//  Copyright © 2016年 LeoZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesTableVIewCell.h"
@class LZActionSheet;
@protocol LZActionSheetDelegate <NSObject>
@optional
- (void)LZActionSheet:(LZActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)index;

@end


@interface LZActionSheet : UIView

//做备忘录菜单时添加cell
@property (nonatomic,strong) NotesTableVIewCell *notes_tag;

//做备忘录菜单时添加索引
@property NSInteger note_index;

@property (nonatomic, strong) id<LZActionSheetDelegate> delegate;

- (instancetype)initWithDelegate:(id)delegate cancelButtonTitle:(NSString *)cancleTitle otherButtonTitles:(NSArray *)otherButtonTitles cancelButtonColor:(UIColor *)color_cancel otherButtonColor:(UIColor *)color_other cancelBgColor:(UIColor*)color_cancel_bg otherBgColor:(UIColor*)color_other_bg;
+ (instancetype)showActionSheetWithDelegate:(id)delegate cancelButtonTitle:(NSString *)cancleTitle otherButtonTitles:(NSArray *)otherButtonTitles cancelButtonColor:(UIColor*)color_cancel otherButtonColor:(UIColor*)color_other cancelBgColor:(UIColor*)color_cancel_bg otherBgColor:(UIColor*)color_other_bg;
- (void)show;

@property NSInteger LZActionSheetBaseHeight;

@end


@interface UIView (LZActionSheet)
@property (assign, nonatomic) CGFloat av_x;
@property (assign, nonatomic) CGFloat av_y;
@property (assign, nonatomic) CGFloat av_w;
@property (assign, nonatomic) CGFloat av_h;
@property (assign, nonatomic) CGFloat av_centerX;
@property (assign, nonatomic) CGFloat av_centerY;
@property (assign, nonatomic) CGSize  av_size;
@property (assign, nonatomic) CGPoint av_origin;
@end



@interface UIColor (LZActionSheet)
+ (instancetype)randomColor;
+ (instancetype)colorWithHex:(NSUInteger)hexColor;
@end
