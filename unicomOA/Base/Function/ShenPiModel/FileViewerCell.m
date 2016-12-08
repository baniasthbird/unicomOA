//
//  FileViewerCell.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/11/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "FileViewerCell.h"
#import "UILabel+LabelHeightAndWidth.h"

@implementation FileViewerCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*)str_Name index:(NSIndexPath*)indexPath withPath:(NSString*)str_Path withHeight:(CGFloat)i_Height {
    static NSString *cellID=@"cellID";
   
    FileViewerCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell=[[FileViewerCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID withName:str_Name withHeight:i_Height withPath:str_Path];
    
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString*)str_Name withHeight:(CGFloat)i_Height withPath:(NSString*)str_Path {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView=[[UIView alloc]initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];

        UILabel *lbl_name=[[UILabel alloc]initWithFrame:CGRectMake(0.2*Width, 0, 0.6*Width, i_Height)];
        lbl_name.textColor=[UIColor blackColor];
        lbl_name.font=[UIFont systemFontOfSize:16];
        lbl_name.numberOfLines=0;
        lbl_name.text=str_Name;
        
        UIImageView *img_Folder=[[UIImageView alloc]initWithFrame:CGRectMake(0.0644*Width, 0.273*i_Height,0.092592592592593*Width, 0.463414634146341*i_Height)];
        img_Folder.image=[UIImage imageNamed:@"filecellLogo"];
        
        UIButton *btn_preview=[[UIButton alloc]initWithFrame:CGRectMake(0.6*Width, 5, 50, i_Height-10)];
        [btn_preview setTitle:@"预览" forState:UIControlStateNormal];
        [btn_preview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_preview addTarget:self action:@selector(PassValue:) forControlEvents:UIControlEventTouchUpInside];
        btn_preview.accessibilityHint=str_Path;
        btn_preview.tag=0;
        
        UIButton *btn_share=[[UIButton alloc]initWithFrame:CGRectMake(0.8*Width, 5, 50, i_Height-10)];
        [btn_share setTitle:@"打开" forState:UIControlStateNormal];
        [btn_share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_share addTarget:self action:@selector(PassValue:) forControlEvents:UIControlEventTouchUpInside];
        btn_share.accessibilityHint=str_Path;
        btn_share.tag=1;
        
        [self.contentView addSubview:lbl_name];
        [self.contentView addSubview:img_Folder];
        
        /*
        UIDocumentInteractionController *documentController=[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:str_Path]];
        [self.contentView addSubview:btn_share];
        if (![documentController.UTI isEqualToString:@"public.data"]) {
            [self.contentView addSubview:btn_preview];
        }
        */
    }
    return self;
}


-(void)PassValue:(UIButton*)btn {
    [_delegate PassFilePathAndCategory:btn.accessibilityHint category:btn.tag];
}




@end
