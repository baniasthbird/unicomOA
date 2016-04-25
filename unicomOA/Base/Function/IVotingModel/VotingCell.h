//
//  VotingCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/3/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VotingCell;

@protocol VotingTapDelegate <NSObject>

@required

/**移除的代理方法*/
-(void)sideslipCellRemoveCell:(VotingCell*)cell atIndex:(NSInteger)index;

/**点击的代理方法*/
-(void)tapCell:(VotingCell*)cell atIndex:(NSInteger)index;

@end

@interface VotingCell : UITableViewCell
/** cell的高度*/
{
    CGFloat _cellHeight;
    
    CGFloat i_TitleX;
    
    CGFloat i_TitleY;
    
    CGFloat i_TitleW;
    
    CGFloat i_TitleH;
    
    CGFloat i_VotingConditionX;
    
    CGFloat i_VotingConditionY;
    
    CGFloat i_VotingConditionW;
    
    CGFloat i_VotingConditionH;
    
    CGFloat i_DepartX;
    
    CGFloat i_DepartY;
    
    CGFloat i_DepartW;
    
    CGFloat i_DepartH;
    
    CGFloat i_TimeX;
    
    CGFloat i_TimeY;
    
    CGFloat i_TimeW;
    
    CGFloat i_TimeH;
    
    
}

@property (nonatomic,retain) UILabel *lbl_Titile;

@property (nonatomic,retain) UIImageView *img_condition;

@property (nonatomic,retain) UILabel *lbl_Department;

@property (nonatomic,retain) UILabel *lbl_time;

@property (nonatomic,unsafe_unretained) id<VotingTapDelegate> delegate;

@property (nonatomic,assign) NSInteger myTag;

@property BOOL isVoting;

/**快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView*)tableView withCellHeight:(CGFloat)cellHeight titleX:(CGFloat)i_TitleX titleY:(CGFloat)i_TitleY titleW:(CGFloat)i_TitleW titleH:(CGFloat)i_TitleH  DepartX:(CGFloat)i_DepartX DepartY:(CGFloat)i_DepartY DepartW:(CGFloat)i_DepartW DepartH:(CGFloat)i_DepartH TimeX:(CGFloat)i_TimeX TimeY:(CGFloat)i_TimeY TimeW:(CGFloat)i_TimeW TimeH:(CGFloat)i_TimeH atIndexPath:(NSIndexPath*)indexPath;

@end
