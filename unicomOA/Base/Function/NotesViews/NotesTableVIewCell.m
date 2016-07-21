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



@property (nonatomic,strong) UIImageView *img_schedule;

@property (nonatomic,strong) UIImageView *img_clock;

@end

@implementation NotesTableVIewCell

@synthesize lbl_arrangement,lbl_content,lbl_time,lbl_time2;

#pragma mark 创建cell
+ (instancetype)cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat)cellHeight atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"sideslipCell";
    NotesTableVIewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
        
        
        CGFloat i_Width=0;
        CGFloat i_Font=16;
        if (iPhone4_4s || iPhone5_5s) {
            i_Width=320.0f;
            i_Font=14;
        }
        else if (iPhone6) {
            i_Width=375.0f;
            i_Font=17;
        }
        else {
            i_Width=414.0f;
            i_Font=18;
        }
        
       // _view_bg=[[UIView alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, 40)];
        _view_bg=[[UIView alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, i_Width, 40)];
        _view_bg.backgroundColor=[UIColor colorWithRed:89/255.0f green:133/255.0f blue:242/255.0f alpha:1];
       
        _img_schedule=[[UIImageView alloc]initWithFrame:CGRectMake(_view_bg.frame.origin.x+10, _view_bg.frame.origin.y+5, 30, 30)];
        _img_schedule.image=[UIImage imageNamed:@"schedule"];
        
        [_view_bg addSubview:_img_schedule];
        
        lbl_arrangement=[[UILabel alloc]initWithFrame:CGRectMake(_view_bg.frame.origin.x+60, _view_bg.frame.origin.y, _view_bg.frame.size.width*0.3, 40.0f)];
        lbl_arrangement.textColor=[UIColor whiteColor];
        lbl_arrangement.font=[UIFont systemFontOfSize:i_Font];
        [_view_bg addSubview:lbl_arrangement];

        _img_clock=[[UIImageView alloc]initWithFrame:CGRectMake(_view_bg.frame.origin.x+_view_bg.frame.size.width*0.45, _view_bg.frame.origin.y+5, 30, 30)];
        _img_clock.image=[UIImage imageNamed:@"clock"];
        [_view_bg addSubview:_img_clock];
        
        lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(_view_bg.frame.origin.x+_view_bg.frame.size.width*0.55, _view_bg.frame.origin.y, _view_bg.frame.size.width*0.5, 40.0f)];
        lbl_time.textColor=[UIColor whiteColor];
        lbl_time.font=[UIFont systemFontOfSize:i_Font];
        
        [_view_bg addSubview:lbl_time];
        
        lbl_content=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x+5, self.contentView.frame.origin.y+45, self.contentView.frame.size.width, 60.0f)];
        lbl_content.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
        lbl_content.font=[UIFont boldSystemFontOfSize:i_Font];
        
        lbl_time2=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x+5
                                                           , self.contentView.frame.origin.y+140.0f, self.contentView.frame.size.width*0.6, 20.0f)];
        lbl_time2.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
        lbl_time2.font=[UIFont boldSystemFontOfSize:i_Font];
        
        //baseView.backgroundColor=[UIColor whiteColor];
        //[baseView addSubview:lbl_arrangement];
        [baseView addSubview:lbl_content];
        [baseView addSubview:lbl_time2];
       // [baseView addSubview:lbl_time];
        [baseView addSubview:_view_bg];
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
        NSLog(@"%ld,%@",(long)self.myTag,@"进入");
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

@end
