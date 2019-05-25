//
//  GaHudButton.m
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2019/5/23.
//  Copyright © 2019 TinyWind. All rights reserved.
//

#import "GaHudButton.h"

@implementation GaHudButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//该尺寸是在使用约束布局的时候的默认尺寸,默认高度有34...
- (CGSize)intrinsicContentSize {
    // Only show if we have associated control events
//    if (self.allControlEvents == 0) {
//        return CGSizeZero;
//    }
    if (self.titleLabel.text.length==0) {
        return CGSizeZero;
    }
    
    CGSize size = [super intrinsicContentSize];
    // Add some side padding
    size.width += 20.f;
    return size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

@end
