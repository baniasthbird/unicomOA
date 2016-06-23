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


@end

@implementation NewsManagementTableViewCell

@synthesize lbl_Title,lbl_department,lbl_Category;

#pragma mark 创建cell

+(instancetype)cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat)cellHeight  withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withTitle:(NSMutableAttributedString *)str_title withCategory:(NSString *)str_category withDepart:(NSString *)str_depart titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont  canScroll:(BOOL)b_scroll withImage:(NSString *)str_Image {
    static NSString *cellID=@"sideslipCell";
    NewsManagementTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    //if (!cell) {
        cell=[[NewsManagementTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight  withTitleHeight:h_title withButtonHeight:h_depart withCateGroy:str_category withTitle:str_title withDepartment:str_depart  titleFont:i_titleFont otherFont:i_otherFont canScroll:b_scroll withImage:str_Image];
    //}
    return cell;

}



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(CGFloat)cellHeight  withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withCateGroy:(NSString*)str_categroy withTitle:(NSMutableAttributedString*)str_title withDepartment:(NSString*)str_department titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont  canScroll:(BOOL)b_scroll withImage:(NSString*)str_Image;
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
        
        
        
        UIImageView *logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(11, 7.5, 16, 16)];
        CGFloat i_left=17;
        if (str_Image!=nil) {
            if (!iPad) {
                i_left=32;
            }
            else {
                logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, 7.5, 23, 23)];
                i_left=80;
            }
            logoImage.image=[UIImage imageNamed:str_Image];
        }
        
        lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(i_left, 5, WHScreenW-34, h_title)];
        
        lbl_Title.font=[UIFont systemFontOfSize:i_titleFont];
        lbl_Title.textColor=[UIColor blackColor];
        lbl_Title.numberOfLines=0;
        lbl_Title.attributedText = str_title;
        [lbl_Title sizeToFit];
        
      //  lbl_Category=[[UILabel alloc] initWithFrame:CGRectMake(i_left, lbl_Title.frame.origin.y+lbl_Title.frame.size.height+5, WHScreenW*0.35, h_depart)];
        lbl_Category=[[UILabel alloc] initWithFrame:CGRectMake(i_left, cellHeight-h_depart-10, WHScreenW*0.35, h_depart)];

        lbl_Category.font=[UIFont systemFontOfSize:i_otherFont];
        lbl_Category.textColor=[UIColor lightGrayColor];
       // lbl_Category.numberOfLines=1;
        lbl_Category.text=str_categroy;
        lbl_Category.textAlignment=NSTextAlignmentLeft;
        [lbl_Category sizeToFit];

        
        lbl_department=[[UILabel alloc]initWithFrame:CGRectMake(WHScreenW*0.5, cellHeight-h_depart-10, WHScreenW*0.5, h_depart)];
        
        lbl_department.font=[UIFont systemFontOfSize:i_otherFont];
        lbl_department.textColor=[UIColor lightGrayColor];
        lbl_department.text=str_department;
        [lbl_department sizeToFit];
        /*
        lbl_time.textColor=[UIColor lightGrayColor];
        lbl_time.font=[UIFont systemFontOfSize:i_otherFont];
        NSArray *arr_time=[str_time componentsSeparatedByString:@" "];
        lbl_time.text=[arr_time objectAtIndex:0];
        */
        lbl_department.textAlignment=NSTextAlignmentRight;
        
      
        
        
        [baseView addSubview:lbl_Category];
        [baseView addSubview:lbl_Title];
        [baseView addSubview:lbl_department];
        [baseView addSubview:logoImage];
      //  [baseView addSubview:lbl_time];
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
