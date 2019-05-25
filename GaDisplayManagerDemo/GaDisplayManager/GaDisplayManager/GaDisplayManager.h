//
//  GaDisplayManager.h
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2019/5/6.
//  Copyright © 2019 TinyWind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GaDisplayStyle.h"
#import "GaHudView.h"


@interface GaDisplayManager : NSObject

#pragma mark 1 display
#pragma mark 1.1 显示自定义形式的view
//显示和隐藏指定View,需要指定是否需要maskView,以及点击mask的事件;
+ (void)displayView:(UIView *)view inSuperview:(UIView *)superview;

+ (void)displayView:(nonnull UIView *)view inSuperview:(nonnull UIView *)superview withDisplayStyle:(nonnull GaDisplayStyle *)displayStyle;

#pragma mark 1.2 显示指定形式的GaHudView
+ (GaHudView *)displayActivityInSuperview:(UIView *)superview;
+ (GaHudView *)displayMessage:(NSString *)message inSuperview:(UIView *)superview interval:(CGFloat)interval;

+ (GaHudView *)displayActivityIndicatorWithTitle:(NSString *)title detail:(NSString *)detail buttonTitle:(NSString *)buttonTitle inSuperview:(UIView *)superview;

+ (GaHudView *)displayIndicatorView:( UIView * _Nullable)indicator title:(NSString *)title detail:(NSString *)detail buttonTitle:(NSString *)buttonTitle inSuperview:(UIView *)superview;


#pragma mark 2 disappear;
#pragma mark 2.1 Disappera from superview
+ (void)disappearHudViewFromSuper:(UIView *)superview;
+ (void)disappearHudView:(UIView *)view;

//显示和隐藏GaActivityView
//+ (void)displayActivityInSuperview:(UIView *)superView;
//+ (void)disappearActivity;

@end

