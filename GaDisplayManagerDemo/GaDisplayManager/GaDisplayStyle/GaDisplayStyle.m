//
//  GaDisplayStyle.m
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2019/5/6.
//  Copyright © 2019 TinyWind. All rights reserved.
//

#import "GaDisplayStyle.h"

@implementation GaDisplayStyle

+ (GaDisplayStyle *)defaultStyle {
    GaDisplayStyle * style = [GaDisplayStyle new];
    style.displayDuration = 3;
    style.animationDuration = 0.5;
    style.displayAnimationType = GaDisplayAnimationTypeZoomIn;
    return style;
}

//根据不同的显示动画,默认有对应的消失动画
- (void)setDisplayAnimationType:(GaDisplayAnimationType)displayAnimationType {
    _displayAnimationType = displayAnimationType;
    switch (displayAnimationType) {
        case GaDisplayAnimationTypeNone:{
            self.disappearAnimationType = GaDisplayAnimationTypeNone;
            break;
        }
        case GaDisplayAnimationTypeFadeIn:{
            self.disappearAnimationType = GaDisappearAnimationTypeFadeOut;
            break;
        }
        case GaDisplayAnimationTypeFromLeft: {
            self.disappearAnimationType = GaDisappearAnimationTypeToRight;
            break;
        }
        case GaDisplayAnimationTypeZoomIn : {
            self.disappearAnimationType = GaDisappearAnimationTypeZoomIn;
            break;
        }
        case GaDisplayAnimationTypeZoomOut: {
            self.disappearAnimationType = GaDisappearAnimationTypeZoomOut;
            break;
        }
        default:{
            break;
        }
    }
}

@end
