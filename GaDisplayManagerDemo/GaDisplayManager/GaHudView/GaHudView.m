//
//  GaHudView.m
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2019/5/6.
//  Copyright © 2019 TinyWind. All rights reserved.
//

#import "GaHudView.h"
#import "UIView+GaDebugUtility.h"




@interface GaHudView()

@property (nonatomic,strong) NSMutableArray <NSLayoutConstraint *> * marrSubviewConstraint;

@property (nonatomic,assign) CGFloat defaultMargin;
@property (nonatomic,assign) CGFloat defaultPadding;
@property (nonatomic,strong) UIFont * defaultTitleFont;
@property (nonatomic,strong) UIFont * defaultDetailFont;

@end

@implementation GaHudView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

//hudView,是一个指定大小的view,和父视图大小无关,内容有indicatorView,label,detailLabel,button;四个元素;
//+ (GaHudView *) activityHudView {
//
//
//}

#pragma mark 1 LifeCycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

//默认初始化,建立了一个默认样式的hud,其余的样式在这个的基础上改的;
- (void)commonInit {
    
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
     self.defaultMargin = 20;
     self.defaultPadding = 5;
     self.defaultTitleFont = [UIFont boldSystemFontOfSize:16];
     self.defaultDetailFont = [UIFont systemFontOfSize:12];

    
    //1 indicatorView;
    UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self addSubview:indicatorView];
    [indicatorView startAnimating];
    _indicatorView = indicatorView;
    _indicatorView.hidden = NO;
    
    //2 label
    GaHudLabel * titleLabel = [GaHudLabel new];
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
    titleLabel.font = self.defaultTitleFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //3 detailLabel
    GaHudLabel * detailLabel = [GaHudLabel new];
    _detailLabel = detailLabel;
    [self addSubview:detailLabel];
    _detailLabel.font = self.defaultDetailFont;
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.numberOfLines = 0;
    //4 button
    GaHudButton * btn = [GaHudButton new];
    _btn = btn;
//    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [self addSubview:btn];
    
    for (UIView *view in self.subviews) {
       view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.marrSubviewConstraint = [NSMutableArray array];
    
}

- (void)didMoveToSuperview {
//    NSLog(@"didMoveToSuperView");
    [super didMoveToSuperview];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.superview attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
}

//按照固定的算法,用约束布局subviews;
- (void)updateConstraints {
//    NSLog(@"GaHudView_updateConstraints");
    [super updateConstraints];
    
    //使用约束定位???
    //    view.centerx = superview.centerx*1+0;
    //    NSLayoutConstraint *lcCenterX = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    //    NSLayoutConstraint *lcCenterY = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    //    //约束应该添加在哪个对象上呢????
    //    [superview addConstraints:@[lcCenterX,lcCenterY]];
    //
    //    //宽高的约束,没有的话,是0
    //    NSLayoutConstraint *lcWidth = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:view.bounds.size.width];
    //    NSLayoutConstraint *lcHeight = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:view.bounds.size.height];
    //    [view addConstraints:@[lcWidth,lcHeight]];
    
    [self removeConstraints:self.marrSubviewConstraint];
    [self.marrSubviewConstraint removeAllObjects];
    
    for (UIView *view in self.subviews) {
        [view removeConstraints:view.constraints];
        //这个约束表示当控件有内容的时候,内容抗压缩的约束,不显示为...
        [view setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisHorizontal];
        [view setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisVertical];
    }
    
    //为4个元素增加水平的约束
    [self.subviews enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        // 1 水平间距约束
        [self.marrSubviewConstraint addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=margin)-[view]-(>=margin)-|" options:0 metrics:@{@"margin":@(self.defaultMargin)} views:@{@"view":view}]];
        // 2 水平居中的约束
        NSLayoutConstraint * centerConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self.marrSubviewConstraint addObject:centerConstraint];
        // 2 第0个元素的top
        if(idx == 0) {
            //第0个
            NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:self.defaultMargin];
            [self.marrSubviewConstraint addObject:constraint];
        }
        if(idx == self.subviews.count-1) {
            //最后一个
            NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.defaultMargin];
            [self.marrSubviewConstraint addObject:constraint];
        }
        
        if(idx>0) {
            //第1,2,3个增加top的约束
            UIView * previousView = self.subviews[idx-1];
            //如果当前view和前一个view都显示,才有20的padding
            CGFloat padding = 0;
            BOOL isPreviousViewSizeZero = CGSizeEqualToSize(previousView.intrinsicContentSize,CGSizeZero);
            BOOL isCurrentViewSizeZero = CGSizeEqualToSize(view.intrinsicContentSize,CGSizeZero);
            if(!isPreviousViewSizeZero&&!isCurrentViewSizeZero) {
                padding = self.defaultPadding;
            }
            else {
                padding = 0;
            }
            //previousView.bottom = view.top - padding;
//            NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:previousView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:padding];
            //view.top = previousView.bottom+padding
          NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:padding];
            
            [self.marrSubviewConstraint addObject:constraint];
        }
    }];
    [self addConstraints:self.marrSubviewConstraint];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
//    [self showSelfAndSubviewInfo];
    });
//
}

- (void)dealloc {
//    NSLog(@"GaHudView dealloced");
}

#pragma mark 2 Setter/Getter
//- (void)setMode:(GaHudViewMode)mode {
//    if(_mode == mode) {
//        return;
//    }
//    else {
//        _mode = mode;
//        [self updateIndicator];
//    }
//}

#pragma mark 3 Interface

#pragma mark 4 BasicFunction
- (void)setIndicatorView:(UIView *)indicatorView {
    
    if(indicatorView == nil) {
        [_indicatorView removeFromSuperview];
        _indicatorView = indicatorView;
    }
    else if([indicatorView isMemberOfClass:[UIActivityIndicatorView class]]) {
    }
    else {
        [_indicatorView removeFromSuperview];
        _indicatorView = indicatorView;
        //需要在updateConstraint之前设置才有效,否则就晚了;
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self insertSubview:_indicatorView atIndex:0];
    }
    
}
@end

