//
//  AppDelegate.h
//  QQ侧滑菜单Demo
//
//  Created by MCL on 16/7/13.
//  Copyright © 2016年 CHLMA. All rights reserved.
//

#import "LeftMenuViewNew.h"
#import "LeftMenuTableView.h"


#define LOG_METHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface LeftMenuViewNew()<UIGestureRecognizerDelegate, UIActionSheetDelegate>
//required
@property (nonatomic, strong) UIViewController *ContainerVC;
@property (nonatomic, strong) UIView *maskView;
//自定义视图
@property (nonatomic, strong) UIImageView *topBlackView;
@property (nonatomic, strong) UIButton *headButton;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *usrAccountLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *downImage;
@property (nonatomic,strong) UIImageView *upImage;
//@property (nonatomic, strong) UIButton *addButton;
//@property (nonatomic, strong) UILabel *addDeviceNotify;
@property (nonatomic, strong) LeftMenuTableView *menuTableView;

@end

@implementation LeftMenuViewNew

NSInteger menuViewWith = 260;
//Objective-C中的单例
static LeftMenuViewNew *menuView = nil;
+ (instancetype)ShareManager:(NSMutableArray*)arr_menu{
    LOG_METHOD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuView = [[self alloc] initWithFrame:CGRectMake(- menuViewWith, 0, menuViewWith, Height) withArray:arr_menu];
    });
    menuView.arr_menus=arr_menu;
    menuView.menuTableView.arr_menus=arr_menu;
    [menuView.menuTableView reloadData];
    return menuView;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    LOG_METHOD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuView = [super allocWithZone:zone];
    });
    return menuView;
}

- (instancetype)initWithContainerViewController:(UIViewController *)containerVC{
    LOG_METHOD;
    if (self = [super init]) {
        _ContainerVC = containerVC;
        self.isLeftViewHidden = YES;
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = RGBCOLOR(238, 238, 238);
        _maskView.hidden = YES;
        [_ContainerVC.view addSubview:_maskView];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addRecognizer];

    }
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect new = [change[@"new"] CGRectValue];
        CGFloat x = new.origin.x;
        if (x != - menuViewWith) {
            _maskView.hidden = NO;
            _maskView.alpha = (x + menuViewWith)/menuViewWith*0.5;
        }else
        {
            _maskView.hidden = YES;
        }
    }
}

#pragma mark - UIPanGestureRecognizer
-(void)addRecognizer{
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
    pan.delegate = self;
    [_ContainerVC.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeLeftViewEvent:)];
    [_maskView addGestureRecognizer:tap];

}

-(void)closeLeftViewEvent:(UITapGestureRecognizer *)recognizer{
    
    [self closeLeftView];
}

-(void)didPanEvent:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:_ContainerVC.view];
    //NSLog(@"translation.x == %f", translation.x);
    [recognizer setTranslation:CGPointZero inView:_ContainerVC.view];
    
    if(UIGestureRecognizerStateBegan == recognizer.state ||
       UIGestureRecognizerStateChanged == recognizer.state){
        
        if (translation.x > 0 ) {//SwipRight
            [_ContainerVC.tabBarController.tabBar setHidden:YES];
            if (self.x == 0) {
                return;
            }
            CGFloat tempX = self.x + translation.x;
            if (tempX <= 0) {
                
                self.frame = CGRectMake(tempX, 0, menuViewWith, Height);
                
            }else{
                
                self.frame = CGRectMake(0, 0, menuViewWith, Height);
            }
            
        }else{//SwipLeft
             [_ContainerVC.tabBarController.tabBar setHidden:NO];
            [self closeLeftView];
            /*
            CGFloat tempX = self.x + translation.x;
            self.frame = CGRectMake(tempX, 0, menuViewWith, Height);
            */
        }
        
    }else{
        NSLog(@"shoushi ting zhi");
        
            if (self.x >= - menuViewWith *0.8) {
                
                [self openLeftView];
                
            }
            else{
                
                [self closeLeftView];
            }
        
        
       
    }
}

/**
 *  关闭左视图
 */
- (void)closeLeftView{
    
    NSLog(@"closeLeftView");
     [_ContainerVC.tabBarController.tabBar setHidden:NO];
    [UIApplication sharedApplication].keyWindow.rootViewController.tabBarController.tabBar.hidden=NO;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(- menuViewWith, 0, menuViewWith, Height);
        self.isLeftViewHidden = YES;
        _maskView.hidden = YES;
    }];
    
}

- (void)openLeftView{
    
    NSLog(@"openLeftView");
    [_ContainerVC.tabBarController.tabBar setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, 0, menuViewWith, Height);
        self.isLeftViewHidden = NO;
    } completion:^(BOOL finished) {
        
        _maskView.hidden = NO;
        _maskView.alpha = 0.5;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        
        return NO;
    }
    else if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        if (self.isLeftViewHidden==YES) {
            return YES;
        }
        else {
            return NO;
        }
        
    }
    
    return YES;
}

#pragma mark - Private
-(instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray*)array{
    LOG_METHOD;
    if (self=[super initWithFrame:frame]) {
        self.arr_menus=array;
        self.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"LeftView"]];
        _headButton = [[UIButton alloc]init];
        _headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LeftViewTitle"]];
        [self addSubview:_headButton];
        //线条
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(61, 60, 68);
       // [self addSubview:_lineView];
        _usrAccountLabel = [[UILabel alloc]init];
        _usrAccountLabel.text = @"事务类别";
        _usrAccountLabel.textColor = [UIColor whiteColor];
        _usrAccountLabel.font = [UIFont boldSystemFontOfSize:18];
        _usrAccountLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_usrAccountLabel];

        //箭头
        _downImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MenuArrow"]];
        [self addSubview:_downImage];
        
        _upImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MenuArrowUp"]];
        [self addSubview:_upImage];
        /*
        //添加“+”按钮
        _addButton = [[UIButton alloc]init];
        [_addButton setImage:[UIImage imageNamed:@"leftmenu_add_nor"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"leftmenu_add_press"] forState:UIControlStateHighlighted];
        [_addButton setTitle:@"Add Button" forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_addButton setTitleColor:RGBCOLOR(187, 190, 199) forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(AddAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
        */
        //tableview
         //
        _menuTableView = [[LeftMenuTableView alloc]init];
        _menuTableView.arr_menus=_arr_menus;
       
        _menuTableView.backgroundColor = [UIColor clearColor];
        __block LeftMenuViewNew *blockSelf = self;
        _menuTableView.menuActionBlock = ^(NSString *name){
            
            if (blockSelf.menuViewDelegate) {
                [blockSelf.menuViewDelegate LeftMenuViewActionIndex:name];
            }
        };
        [self addSubview:_menuTableView];
        
    }
    //注册通知观察者（接受通知，将记录跳转界面的值从主控制器传过来）
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateUserData:) name:@"UpdateUserData" object:nil];
    return  self ;
}

- (void)layoutSubviews{
    
    CGRect rect = CGRectMake((self.width - 0.075*Height)/2, 0.073*Height, 0.075*Height, 0.048*Height);
    _headButton.frame = rect;
    _headImage.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [_headButton addSubview:_headImage];
    CGFloat marginX = 15;
    _usrAccountLabel.frame = CGRectMake(0, CGRectGetMaxY(_headButton.frame) + marginX, self.width, marginX);
    _lineView.frame = CGRectMake(marginX, CGRectGetMaxY(_usrAccountLabel.frame)+10, self.width - marginX * 2, 0.5);
    _topBlackView.frame = CGRectMake(0, 0, self.width, CGRectGetMaxY(_lineView.frame));
    
    _upImage.frame= CGRectMake(self.width/2-25, CGRectGetMaxY(_lineView.frame), 50, 21.5);
   // CGFloat addBtnW = 30;
    /*
    _addButton.frame = CGRectMake(marginX, Height - 25 - addBtnW, self.width - marginX * 2, addBtnW);
    [_addButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, addBtnW)];
    [_addButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
     */
    CGFloat tablView_top = CGRectGetMaxY(_lineView.frame) + marginX + 10;
    CGFloat tableView_Bottom = Height-40;
    _menuTableView.frame = CGRectMake(0, tablView_top, self.width , tableView_Bottom - tablView_top);
    
     _downImage.frame=CGRectMake(self.width/2-25, CGRectGetMaxY(_menuTableView.frame)+5, 50, 21.5);
}

- (void)UpdateUserData:(NSNotification *)notify{
    
    NSLog(@"UpdateUserData");
}

- (void)changeHeaderImage{
    
    NSLog(@"changeHeaderImage");
}

- (void)AddAction{

    NSLog(@"AddAction");
    if (_menuViewDelegate) {
        [_menuViewDelegate LeftMenuViewActionIndex:@"AddAction"];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"frame"];
}
@end
