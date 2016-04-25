//
//  VotingCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "VotingCell.h"

#define WHScreenW [UIScreen mainScreen].bounds.size.width

@interface VotingCell()<UIScrollViewDelegate>

@property (nonatomic,weak) UIView *baseView;

@property (nonatomic,weak) UIView *btnView;

@property (nonatomic,weak) UIScrollView *scrollView;

@end

@implementation VotingCell

@synthesize lbl_time,lbl_Titile,lbl_Department;

+(instancetype)cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat)cellHeight titleX:(CGFloat)i_TitleX titleY:(CGFloat)i_TitleY titleW:(CGFloat)i_TitleW titleH:(CGFloat)i_TitleH DepartX:(CGFloat)i_DepartX DepartY:(CGFloat)i_DepartY DepartW:(CGFloat)i_DepartW DepartH:(CGFloat)i_DepartH TimeX:(CGFloat)i_TimeX TimeY:(CGFloat)i_TimeY TimeW:(CGFloat)i_TimeW TimeH:(CGFloat)i_TimeH atIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"sideslipCell";
    VotingCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[VotingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight titleX:i_TitleX titleY:i_TitleY titleW:i_TitleW titleH:i_TitleH depart_X:i_DepartX depart_Y:i_DepartY depart_W:i_DepartW depart_H:i_DepartH time_X:i_TimeX time_Y:i_TimeY time_W:i_TimeW time_H:i_TimeH];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(CGFloat)cellHeight titleX:(CGFloat)i_titleX titleY:(CGFloat)i_titleY titleW:(CGFloat)i_titleW titleH:(CGFloat)i_titleH depart_X:(CGFloat)i_departX depart_Y:(CGFloat)i_departY depart_W:(CGFloat)i_departW depart_H:(CGFloat)i_departH time_X:(CGFloat)i_timeX time_Y:(CGFloat)i_timeY time_W:(CGFloat)i_timeW time_H:(CGFloat)i_timeH {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _cellHeight=cellHeight;
#pragma mark 创建滚动条，增加删除按钮
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WHScreenW, cellHeight)];
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.showsVerticalScrollIndicator=NO;
        scrollView.delegate=self;
        
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
        
        lbl_Titile=[[UILabel alloc]initWithFrame:CGRectMake(i_titleX, i_titleY, i_titleW, i_titleH)];
        _img_condition=[[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, 47, 40)];
        
        lbl_Department=[[UILabel alloc]initWithFrame:CGRectMake(i_departX, i_departY, i_departW, i_departH)];
        lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(i_timeX, i_timeY, i_timeW, i_timeH)];
        lbl_Titile.font=[UIFont systemFontOfSize:18];
        lbl_Titile.textColor=[UIColor blackColor];
        lbl_Titile.numberOfLines=0;
        
        
        lbl_Department.font=[UIFont systemFontOfSize:14];
        lbl_Department.textColor=[UIColor lightGrayColor];
        
        lbl_time.font=[UIFont systemFontOfSize:14];
        lbl_time.textColor=[UIColor lightGrayColor];
        
        [baseView addSubview:lbl_Titile];
        [baseView addSubview:_img_condition];
        [baseView addSubview:lbl_Department];
        [baseView addSubview:lbl_time];
        _baseView=baseView;
        baseView.backgroundColor=[UIColor whiteColor];
        
        [baseView addGestureRecognizer:tapGesture];
        [scrollView addSubview:baseView];
        
        scrollView.contentSize=CGSizeMake(WHScreenW+btnViewW, 0);
        _scrollView=scrollView;
        [self.contentView addSubview:scrollView];
    }
    return self;
}

-(void)Actiondo:(UIButton*)sender {
    if ([self.delegate respondsToSelector:@selector(tapCell:atIndex:)]) {
        [self.delegate tapCell:self atIndex:self.myTag];
        NSLog(@"%ld,%@",self.myTag,@"进入下一版面");
    }
}

-(void)btnClick:(UIButton*)sender {
    if ([sender.currentTitle isEqualToString:@"删除"]) {
        [self removeBegin];
    }
}

-(void)awakeFromNib {
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark 移除按钮
-(void)removeBegin
{
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset  = CGPointZero;
    }];
    if ([self.delegate respondsToSelector:@selector(sideslipCellRemoveCell:atIndex:)]) {
        [self.delegate sideslipCellRemoveCell:self atIndex:self.myTag];
        NSLog(@"%ld,%@",self.myTag,@"移除");
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
