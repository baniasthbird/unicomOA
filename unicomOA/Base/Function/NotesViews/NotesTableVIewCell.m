//
//  NotesTableVIewCell.m
//  unicomOA
//
//  Created by zr-mac on 16/3/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NotesTableVIewCell.h"

#define WHScreenW [UIScreen mainScreen].bounds.size.width

@interface NotesTableVIewCell()<UIScrollViewDelegate>

@property (nonatomic,weak) UIView *baseView;
@property (nonatomic,weak) UIView *btnView;
@property (nonatomic,weak) UIScrollView *scrollView;

@end

@implementation NotesTableVIewCell

@synthesize lbl_arrangement,lbl_content,lbl_time;

#pragma mark 创建cell
+ (instancetype)cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat)cellHeight
{
    static NSString *cellID = @"sideslipCell";
    NotesTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NotesTableVIewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight];
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(CGFloat)cellHeight
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _cellHeight=cellHeight;
#pragma 创建滚动条，增加删除按钮
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
        CGFloat btnViewX=WHScreenW-btnViewW;
        // CGFloat btnViewX=WHScreenW;
        CGFloat btnViewY=0;
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(btnViewX, btnViewY, btnViewW, btnViewH)];
        _btnView = btnView;
        btnView.backgroundColor = [UIColor clearColor];
        
        CGFloat btnX=0;
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.backgroundColor=[UIColor redColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        [btnView addSubview:btn];
        
        [scrollView addSubview:btnView];
        
        //创建显示内容
        UIView *baseView=[[UIView alloc]initWithFrame:scrollView.bounds];
        
        lbl_arrangement=[[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 20.0f)];
        lbl_content=[[UILabel alloc]initWithFrame:CGRectMake(0.0f, 30.0f, self.frame.size.width, 100.0f)];
        lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(0.0f, 140.0f, self.frame.size.width, 30.0f)];
        lbl_arrangement.textColor=[UIColor blackColor];
        lbl_content.textColor=[UIColor blackColor];
        lbl_time.textColor=[UIColor blackColor];
        [baseView addSubview:lbl_arrangement];
        [baseView addSubview:lbl_content];
        [baseView addSubview:lbl_time];
        _baseView=baseView;
        baseView.backgroundColor=[UIColor whiteColor];
        [baseView addGestureRecognizer:tapGesture];
        [scrollView addSubview:baseView];
        
        
        
        
        
        scrollView.contentSize=CGSizeMake(WHScreenW + btnViewW, 0);
        _scrollView=scrollView;
        
         [self.contentView addSubview:scrollView];
        
        
    }
    return self;
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

-(void)btnClick:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"删除"]) {
        [self removeBegin];
        //NSLog(@"移除");
    }
}

-(void)Actiondo:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tapCell:atIndex:)]) {
        [self.delegate tapCell:self atIndex:self.myTag];
        NSLog(@"%ld,%@",self.myTag,@"移除");
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
        NSLog(@"%ld,%@",self.myTag,@"移除");
    }

}

@end
