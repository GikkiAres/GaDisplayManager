//
//  GaDisplayManager.m
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2019/5/6.
//  Copyright © 2019 TinyWind. All rights reserved.
//

#import "GaDisplayManager.h"
#import <objc/runtime.h>

@implementation GaDisplayManager

static int displayStyleKey;
//static int maskButtonKey;
static int hudViewKey;
#pragma mark display


//在superView上显示指定view;
+ (void)displayView:(UIView *)view inSuperview:(UIView *)superview {
    GaDisplayStyle * displayStyle = [GaDisplayStyle defaultStyle];
    displayStyle.displayDuration = 3;
    [self displayView:view inSuperview:superview withDisplayStyle:displayStyle];
}
// 显示的最终代码
+ (void)displayView:(nonnull UIView *)view inSuperview:(nonnull UIView *)superview withDisplayStyle:(nonnull GaDisplayStyle *)displayStyle {
    //1 显示
    //为了简化逻辑,maskButton是默认会加上的,只不过,根据设置不同,隐藏还是显示,有没有消失的触发事件;
    UIButton * maskButton = [[UIButton alloc]initWithFrame:superview.bounds];
    [superview addSubview:maskButton];
    [maskButton addSubview:view];
    if(displayStyle.isShowMaskView) {
        maskButton.hidden = NO;
        if(displayStyle.isMaskViewClickable) {
            [maskButton addTarget:self action:@selector(disappear:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else {
        maskButton.hidden = YES;
    }
    
    
    //2 定位
    view.translatesAutoresizingMaskIntoConstraints = NO;
    //使用约束定位
    //    view.centerx = superview.centerx*1+0;
    NSLayoutConstraint *lcCenterX = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *lcCenterY = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    //约束应该添加在父视图上
    [superview addConstraints:@[lcCenterX,lcCenterY]];
    
    
    
    
    // 3 动画
    //初始状态根据动画的种类不一样,结束的状态是一样的;
    void(^displayAnimationFinishBlock)(void)  = ^{
        view.alpha = 1;
        view.transform = CGAffineTransformIdentity;
    };
    CGFloat animationDuration = displayStyle.animationDuration;
    switch(displayStyle.displayAnimationType) {
        case GaDisplayAnimationTypeNone: {
            //什么也不需要做,直接显示;
            break;
        }
        case GaDisplayAnimationTypeFadeIn:{
            //fadein,初始alpha为0,结束alpha为1;
            view.alpha = 0;
            [UIView animateWithDuration:animationDuration animations:displayAnimationFinishBlock];
            
            break;
        }
        case GaDisplayAnimationTypeZoomIn:{
            //ZoomIn,由小到大
            view.alpha = 0;
            view.transform = CGAffineTransformMakeScale(0.5, 0.5);
            [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:2 initialSpringVelocity:1 options:0 animations:displayAnimationFinishBlock completion:nil];
            
            break;
        }
        case GaDisplayAnimationTypeZoomOut:{
            //ZoomOut,由大到小
            view.alpha = 0;
            view.transform = CGAffineTransformMakeScale(1.5, 1.5);
            [UIView animateWithDuration:animationDuration animations:displayAnimationFinishBlock completion:nil];
            break;
        }
        case GaDisplayAnimationTypeFromLeft:{
            //FromLeft,从左到右
            view.alpha = 0;
            view.transform = CGAffineTransformMakeTranslation(-200, 0);
            [UIView animateWithDuration:animationDuration animations:displayAnimationFinishBlock completion:nil];
            break;
        }
        default:{
            CGFloat effectOffset = 20.f;
            UIInterpolatingMotionEffect * effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
            effectX.maximumRelativeValue = @(effectOffset);
            effectX.minimumRelativeValue = @(-effectOffset);
            
            UIInterpolatingMotionEffect * effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
            effectY.maximumRelativeValue = @(effectOffset);
            effectY.minimumRelativeValue = @(-effectOffset);
            
            UIMotionEffectGroup * group = [[UIMotionEffectGroup alloc] init];
            group.motionEffects = @[effectX,effectY];
            
            [view addMotionEffect:group];
            
            break;
        }
            
    }
    
    // 3 关联必要信息
    objc_setAssociatedObject(view, &displayStyleKey, displayStyle, OBJC_ASSOCIATION_RETAIN);
//    objc_setAssociatedObject(view,&maskButtonKey,maskButton,OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(superview, &hudViewKey, view, OBJC_ASSOCIATION_RETAIN);
    
    // 4 auto disappear if needed
    if(displayStyle.displayDuration>0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(displayStyle.displayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self disappearHudView:view];
        });
    }
}



#pragma mark 1.2 显示指定形式的view
#pragma mark 1.2.1 显示转圈
+ (GaHudView *)displayActivityInSuperview:(UIView *)superview {
    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    return [self displayIndicatorView:activity title:nil detail:nil buttonTitle:nil inSuperview:superview];
}
#pragma mark 1.2.2 显示消息
+ (GaHudView *)displayMessage:(NSString *)message inSuperview:(UIView *)superview interval:(CGFloat)interval {
    
    GaHudView * view = [[GaHudView alloc]init];
    GaDisplayStyle *style = [GaDisplayStyle defaultStyle];
    view.indicatorView = nil;
    view.titleLabel.text = message;
    view.detailLabel.text = nil;
    style.displayDuration = interval;
    style.isShowMaskView = YES;
    style.isMaskViewClickable = NO;
    [GaDisplayManager displayView:view inSuperview:superview withDisplayStyle:style];
    return view;
}

#pragma mark 1.2.3 显示转圈+title+detail+button
//显示转子,标题,详细,和确认按钮;
+ (GaHudView *)displayActivityIndicatorWithTitle:(NSString *)title detail:(NSString *)detail buttonTitle:(NSString *)buttonTitle inSuperview:(UIView *)superview {
    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    return [self displayIndicatorView:activity title:title detail:detail buttonTitle:buttonTitle inSuperview:superview];
}

+ (GaHudView *)displayIndicatorView:(UIView * )indicator title:(NSString *)title detail:(NSString *)detail buttonTitle:(NSString *)buttonTitle inSuperview:(UIView *)superview {
    GaHudView * view = [[GaHudView alloc]init];
    GaDisplayStyle *style = [GaDisplayStyle defaultStyle];
    view.indicatorView = indicator;
    view.titleLabel.text = title;
    view.detailLabel.text = detail;
        style.displayDuration = 0;
        [view.btn setTitle:buttonTitle forState:UIControlStateNormal];
        [view.btn addTarget:self action:@selector(disappear:) forControlEvents:UIControlEventTouchUpInside];
        style.isShowMaskView = YES;
        style.isMaskViewClickable = NO;
    
    [GaDisplayManager displayView:view inSuperview:superview withDisplayStyle:style];
    return view;
}

#pragma mark 2 disappear;
#pragma mark 2.1 Disappera from superview
//隐藏superview当前关联的hudView;当显示了多个的时候,可能会有影响;
+ (void)disappearHudViewFromSuper:(UIView *)superview {
    GaHudView * hudView = objc_getAssociatedObject(superview, &hudViewKey);
    [self disappearHudView:hudView];
}

+ (void)disappearHudView:(UIView *)view {
    
    //1 获取style,取消关联
    GaDisplayStyle * displayStyle = objc_getAssociatedObject(view, &displayStyleKey);
    UIButton * maskButton = (UIButton *)view.superview;
    objc_setAssociatedObject(view, &displayStyleKey, nil, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(view.superview.superview, &hudViewKey, nil, OBJC_ASSOCIATION_RETAIN);
    
    void(^disappearAnimationFinishBlock)(BOOL finished) = ^(BOOL finished) {
        //2 remove
//        [view removeFromSuperview];
        [maskButton removeFromSuperview];
    };
    
    //1 animate if needed
    CGFloat animationDuration = displayStyle.animationDuration;
    switch(displayStyle.disappearAnimationType) {
        case GaDisappearAnimationTypeNone:{
            disappearAnimationFinishBlock(YES);
            break;
        }
        case GaDisappearAnimationTypeFadeOut:{
            [UIView animateWithDuration:animationDuration animations:^{
                view.alpha = 0;
            } completion:disappearAnimationFinishBlock];
            
            break;
        }
        case GaDisappearAnimationTypeZoomIn:{
            //ZoomIn
            [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:2 initialSpringVelocity:1 options:0 animations:^{
                view.alpha = 0;
                view.transform = CGAffineTransformMakeScale(1.5, 1.5);
            } completion:disappearAnimationFinishBlock];
            
            break;
        }
        case GaDisappearAnimationTypeZoomOut:{
            //ZoomOut
            [UIView animateWithDuration:animationDuration animations:^{
                view.alpha = 0;
                view.transform = CGAffineTransformMakeScale(0.5, 0.5);
            } completion:disappearAnimationFinishBlock];
            
            break;
        }
        case GaDisappearAnimationTypeToRight:{
            [UIView animateWithDuration:animationDuration animations:^{
                view.alpha = 0;
                CGAffineTransform transform = CGAffineTransformMakeTranslation(200, 0);
                view.transform = transform;
            } completion:disappearAnimationFinishBlock];
            break;
        }
        default:{
            
            break;
        }
    }
}

+(void)disappear:(UIButton *)btn {
    if([btn isKindOfClass:[GaHudButton class]]) {
        //如果点击了HudView的取消按钮;
        [GaDisplayManager disappearHudView:btn.superview];
    }
    else {
        //点击了MaskView
        [GaDisplayManager disappearHudView:btn.subviews[0]];
    }
    
}


@end


