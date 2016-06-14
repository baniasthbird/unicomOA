//
//  NewsManagementTableViewCell.m
//  unicomOA
//
//  Created by zr-mac on 16/3/10.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsManagementTableViewCell.h"
#import "UILabel+LabelHeightAndWidth.h"

#define WHScreenW [UIScreen mainScreen].bounds.size.width

@interface NewsManagementTableViewCell()<UIScrollViewDelegate>

@property (nonatomic,weak) UIView *baseView;
@property (nonatomic,weak) UIView *btnView;
@property (nonatomic,weak) UIScrollView *scrollView;

@property (nonatomic,retain) UILabel *lbl_Category;

@property (nonatomic,retain) UILabel *lbl_Title;

@property (nonatomic,retain) UILabel *lbl_department;

@property (nonatomic,retain) UILabel *lbl_time;

@end

@implementation NewsManagementTableViewCell

@synthesize lbl_Title,lbl_department,lbl_time,lbl_Category;

#pragma mark 创建cell

+(instancetype)cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat)cellHeight withCategoryHeight:(CGFloat)h_category withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withTitle:(NSString *)str_title withCategory:(NSString *)str_category withDepart:(NSString *)str_depart withTime:(NSString *)str_time canScroll:(BOOL)b_scroll {
    static NSString *cellID=@"sideslipCell";
    NewsManagementTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    //if (!cell) {
        cell=[[NewsManagementTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight withCategoryHeight:h_category withTitleHeight:h_title withButtonHeight:h_depart withCateGroy:str_category withTitle:str_title withDepartment:str_depart withTime:str_time canScroll:b_scroll];
    //}
    return cell;

}



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(CGFloat)cellHeight withCategoryHeight:(CGFloat)h_category withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withCateGroy:(NSString*)str_categroy withTitle:(NSString*)str_title withDepartment:(NSString*)str_department withTime:(NSString*)str_time canScroll:(BOOL)b_scroll
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
#pragma 创建滚动条，增加删除按钮
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WHScreenW, cellHeight)];
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.showsVerticalScrollIndicator=NO;
        scrollView.delegate=self;
        
        scrollView.scrollEnabled=b_scroll;
        
        //按钮个数
        NSInteger btnCount=1;
        CGFloat btnW=80;
        CGFloat btnY=0;
        CGFloat btnH=cellHeight;
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
        
        //创建按钮
        CGFloat btnViewH=btnH;
        CGFloat btnViewW=btnCount*btnW;
        CGFloat btnViewX=WHScreenW;
        
        CGFloat btnViewY=0;
        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(btnViewX, btnViewY, btnViewW, btnViewH)];
        btnView.backgroundColor=[UIColor lightGrayColor];
        
        CGFloat btnX=0;
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.backgroundColor=[UIColor redColor];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:btn];
        
        [scrollView addSubview:btnView];
        
        //创建显示内容
        UIView *baseView=[[UIView alloc]initWithFrame:scrollView.bounds];
        
        lbl_Category=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WHScreenW, h_category)];
        lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(0, h_category+5, WHScreenW, h_title)];
        lbl_department=[[UILabel alloc]initWithFrame:CGRectMake(0, h_category+h_title+10,WHScreenW*0.6 , h_depart)];
        lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(WHScreenW*0.6+5, h_category+h_title+10, WHScreenW*0.4-5, h_depart)];
        
        lbl_Category.font=[UIFont systemFontOfSize:14];
        lbl_Category.textColor=[UIColor lightGrayColor];
        lbl_Category.numberOfLines=1;
        lbl_Category.text=str_categroy;
        
        lbl_Title.font=[UIFont systemFontOfSize:24];
        lbl_Title.textColor=[UIColor blackColor];
        lbl_Title.numberOfLines=0;
        lbl_Title.text=str_title;
        
        lbl_department.font=[UIFont systemFontOfSize:14];
        lbl_department.textColor=[UIColor lightGrayColor];
        lbl_department.text=str_department;
        
        lbl_time.textColor=[UIColor lightGrayColor];
        lbl_time.font=[UIFont systemFontOfSize:14];
        lbl_time.text=str_time;
        
        [baseView addSubview:lbl_Category];
        [baseView addSubview:lbl_Title];
        [baseView addSubview:lbl_department];
        [baseView addSubview:lbl_time];
        _baseView=baseView;
        baseView.backgroundColor=[UIColor clearColor];
        [baseView addGestureRecognizer:tapGesture];
        [scrollView addSubview:baseView];
        
        
        scrollView.contentSize=CGSizeMake(WHScreenW+btnViewW, 0);
        _scrollView=scrollView;
        [self.contentView addSubview:scrollView];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)Actiondo:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tapCell:atIndex:)]) {
        [self.delegate tapCell:self atIndex:self.myTag];
        NSLog(@"%ld,%@",(long)self.myTag,@"进入下一版面");
    }
}

-(void)btnClick:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"删除"]) {
        [self removeBegin];
    }
}

#pragma mark 移除按钮
-(void)removeBegin
{
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset  = CGPointZero;
    }];
    if ([self.delegate respondsToSelector:@selector(sideslipCellRemoveCell:atIndex:)]) {
        [self.delegate sideslipCellRemoveCell:self atIndex:self.myTag];
        NSLog(@"%ld,%@",(long)self.myTag,@"移除");
    }
}

#pragma mark 拖动时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _btnView.transform=CGAffineTransformMakeTranslation(scrollView.contentOffset.x, 0);
}

#pragma mark 拖动结束时
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x<_btnView.frame.size.width/2) {
        //没拖动到一半
        scrollView.contentOffset=CGPointZero;
    } else {
        scrollView.contentOffset=CGPointMake(_btnView.frame.size.width, 0);
        _btnView.transform=CGAffineTransformMakeTranslation(scrollView.contentOffset.x, 0);
    }
}

@end
