//
//  GaDisplayStyle.h
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2019/5/6.
//  Copyright © 2019 TinyWind. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,GaDisplayPosition) {
    GaDisplayPositionCenter,
    GaDisplayPositionTop,
    GaDisplayPositionBottom
};

typedef NS_ENUM(NSUInteger,GaDisplayAnimationType) {
    GaDisplayAnimationTypeNone,
    GaDisplayAnimationTypeFadeIn,
    GaDisplayAnimationTypeZoomIn,
    GaDisplayAnimationTypeZoomOut,
    GaDisplayAnimationTypeFromLeft
};

typedef NS_ENUM(NSUInteger,GaDisappearAnimationType) {
    GaDisappearAnimationTypeNone,
    GaDisappearAnimationTypeFadeOut,
    GaDisappearAnimationTypeZoomIn,
    GaDisappearAnimationTypeZoomOut,
    GaDisappearAnimationTypeToRight
};




@interface GaDisplayStyle : NSObject

@property(nonatomic,assign) GaDisplayPosition displayPosition;
//设置显示动画时,默认有对应的消失动画
@property(nonatomic,assign) GaDisplayAnimationType displayAnimationType;

@property(nonatomic,assign) GaDisappearAnimationType disappearAnimationType;

@property(nonatomic,assign) CGFloat animationDuration;

@property(nonatomic,assign) CGFloat displayDuration;

#pragma mark mask view
//是否显示mask view,从而只能在display view上操作
@property(nonatomic,assign) BOOL isShowMaskView;
//是否mask view具有点击取消display view的作用;
@property(nonatomic,assign) BOOL isMaskViewClickable;

#pragma mark

//默认的style;
+ (GaDisplayStyle *)defaultStyle;

@end


