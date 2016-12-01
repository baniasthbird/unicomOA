//
//  FileViewerCell.h
//  unicomOA
//
//  Created by hnsi-03 on 2016/11/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileViewDelegate <NSObject>

-(void)PassFilePathAndCategory:(NSString*)str_path category:(NSInteger)i_category;

@end


@interface FileViewerCell : UITableViewCell

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*)str_Name index:(NSIndexPath*)indexPath withPath:(NSString*)str_Path withHeight:(CGFloat)i_Height ;

@property (nonatomic,strong) id<FileViewDelegate> delegate;

@end
