//
//  GaHudView.h
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2019/5/6.
//  Copyright © 2019 TinyWind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GaHudButton.h"
#import "GaHudLabel.h"

//
//typedef NS_ENUM(NSUInteger,GaHudViewMode) {
//    GaHudViewModeDefault,   //default有ActivityIndicator,label,detail,button;
//    GaHudViewModeNoIndicator,  //没有ActivityIndicator;
//    GaHudViewModeCustomIndicator //自定义的Indicator;
//};



NS_ASSUME_NONNULL_BEGIN

@interface GaHudView : UIView


//可以设置
@property (nonatomic,strong,nullable) UIView * indicatorView;
@property (nonatomic,strong,readonly) GaHudLabel * titleLabel;
@property (nonatomic,strong,readonly) GaHudLabel * detailLabel;
@property (nonatomic,strong,readonly) GaHudButton * btn;


@end

NS_ASSUME_NONNULL_END
