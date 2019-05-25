//
//  GaHudLabel.m
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2019/5/25.
//  Copyright © 2019 TinyWind. All rights reserved.
//

#import "GaHudLabel.h"

@implementation GaHudLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//text是@"",反而contentSize是0,text是nil,反而不对...
- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    if(self.text.length==0) {
        return CGSizeZero;
    }
    else {
//    NSLog(@"self is %@,inrinsicContentSize is %@",self,NSStringFromCGSize(size));
    return size;
    }
}

@end
