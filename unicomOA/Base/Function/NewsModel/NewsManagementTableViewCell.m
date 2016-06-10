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

@end

@implementation NewsManagementTableViewCell

@synthesize lbl_Title,lbl_department,lbl_time;

#pragma mark 创建cell

+(instancetype)cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat)cellHeight titleX:(CGFloat)i_TitleX titleY:(CGFloat)i_TitleY titleW:(CGFloat)i_TitleW titleH:(CGFloat)i_TitleH DepartX:(CGFloat)i_DepartX DepartY:(CGFloat)i_DepartY DepartW:(CGFloat)i_DepartW DepartH:(CGFloat)i_DepartH TimeX:(CGFloat)i_TimeX TimeY:(CGFloat)i_TimeY TimeW:(CGFloat)i_TimeW TimeH:(CGFloat)i_TimeH canScroll:(BOOL)b_scroll{
    static NSString *cellID=@"sideslipCell";
    NewsManagementTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[NewsManagementTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight titleX:i_TitleX titleY:i_TitleY titleW:i_TitleW titleH:i_TitleH depart_X:i_DepartX depart_Y:i_DepartY depart_W:i_DepartW depart_H:i_DepartH time_X:i_TimeX time_Y:i_TimeY time_W:i_TimeW time_H:i_TimeH canScroll:b_scroll];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(CGFloat)cellHeight titleX:(CGFloat)i_titleX titleY:(CGFloat)i_titleY titleW:(CGFloat)i_titleW titleH:(CGFloat)i_titleH depart_X:(CGFloat)i_departX depart_Y:(CGFloat)i_departY depart_W:(CGFloat)i_departW depart_H:(CGFloat)i_departH time_X:(CGFloat)i_timeX time_Y:(CGFloat)i_timeY time_W:(CGFloat)i_tiemW time_H:(CGFloat)i_timeH canScroll:(BOOL)b_scroll
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _cellHeight=cellHeight;
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
        
        lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(i_titleX, i_titleY, i_titleW, i_titleH)];
        lbl_department=[[UILabel alloc]initWithFrame:CGRectMake(i_departX, i_departY, i_departW, i_departH)];
        lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(i_timeX, i_timeY, i_tiemW, i_timeH)];
        lbl_Title.font=[UIFont systemFontOfSize:24];
        lbl_Title.textColor=[UIColor blackColor];
        lbl_Title.numberOfLines=0;
        
        lbl_department.font=[UIFont systemFontOfSize:14];
        lbl_department.textColor=[UIColor lightGrayColor];
        
        lbl_time.textColor=[UIColor lightGrayColor];
        lbl_time.font=[UIFont systemFontOfSize:14];
        
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
