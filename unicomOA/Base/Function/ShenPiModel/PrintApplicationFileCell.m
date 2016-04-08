//
//  PrintApplicationFileCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintApplicationFileCell.h"

#define WHScreenW [UIScreen mainScreen].bounds.size.width

@interface PrintApplicationFileCell()<UIScrollViewDelegate>

//有文件时显示
//文件名
@property (strong,nonatomic) UILabel *lbl_filename;

//复印页数
@property (strong,nonatomic) UILabel *lbl_file_detail;


@property (nonatomic,weak) UIView *baseView;

@property (nonatomic,weak) UIView *btnView;

@property (nonatomic,weak) UIScrollView *scrollView;

@end


@implementation PrintApplicationFileCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString *)str_Title withPages:(int)str_Pages withCopies:(int)str_copies withCellHeight:(CGFloat)cellHeight withPrintFile:(PrintFiles*)tmp_file {
    static NSString *cellID=@"cellID";
    PrintApplicationFileCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
            cell=[[PrintApplicationFileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withTtile:str_Title withPages:str_Pages withCopies:str_copies withCellHeight:cellHeight];
    }
    else {
        if (![cell isMemberOfClass:[PrintApplicationFileCell class]]) {
         //   if (cell.file!=tmp_file) {
                 cell=[[PrintApplicationFileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withTtile:str_Title withPages:str_Pages withCopies:str_copies withCellHeight:cellHeight];
          //  }
           
        }
        else {
            cell=[[PrintApplicationFileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withTtile:str_Title withPages:str_Pages withCopies:str_copies withCellHeight:cellHeight];
            
        }
    }
    return  cell;
}


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTtile:(NSString*)str_Title withPages:(int)i_Pages withCopies:(int)i_copies withCellHeight:(CGFloat)cellHeight {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WHScreenW, cellHeight)];
        
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.showsVerticalScrollIndicator=NO;
        scrollView.delegate=self;
        
        //按钮个数
        NSInteger btnCount=1;
        CGFloat btnW=80;
        CGFloat btnY=0;
        CGFloat btnH=cellHeight;
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ActionDo:)];
        
        //创建按钮
        CGFloat btnViewH=btnH;
        CGFloat btnViewW=btnCount*btnW;
        CGFloat btnViewX=WHScreenW-btnViewW;
        CGFloat btnViewY=0;
        UIView *btnView=[[UIView alloc] initWithFrame:CGRectMake(btnViewX, btnViewY, btnViewW, btnViewH)];
        _btnView=btnView;
        btnView.backgroundColor=[UIColor clearColor];
        
        CGFloat btnX=0;
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.backgroundColor=[UIColor redColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        [btnView addSubview:btn];
        
        [scrollView addSubview:btnView];
        
        //创建显示内容
        UIView *baseView=[[UIView alloc]initWithFrame:scrollView.bounds];
        
        _lbl_filename=[[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, cellHeight*0.5)];
        _lbl_file_detail=[[UILabel alloc]initWithFrame:CGRectMake(0.0f, cellHeight*0.5, self.frame.size.width, cellHeight*0.5)];
        _lbl_filename.text=str_Title;
        _lbl_file_detail.text=[NSString stringWithFormat:@"%@  %d  %@  %d",@"复印页数",i_Pages,@"份数",i_copies];
        _lbl_filename.textColor=[UIColor blackColor];
        _lbl_file_detail.textColor=[UIColor blackColor];
        _lbl_file_detail.font=[UIFont systemFontOfSize:14];
        _lbl_filename.font=[UIFont systemFontOfSize:14];
        _lbl_filename.textAlignment=NSTextAlignmentCenter;
        _lbl_file_detail.textAlignment=NSTextAlignmentCenter;
        
        [baseView addSubview:_lbl_filename];
        [baseView addSubview:_lbl_file_detail];
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

-(void)ActionDo:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tapCell:atIndex:)]) {
        [self.delegate tapCell:self atIndex:self.myTag];
        NSLog(@"%ld,%@",self.myTag,@"进入");
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
