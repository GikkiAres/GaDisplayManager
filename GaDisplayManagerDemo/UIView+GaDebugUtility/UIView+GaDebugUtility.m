//
//  UIView+GaDebugUtility.m
//  Ga8thManager
//
//  Created by GikkiAres on 2018/12/3.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import "UIView+GaDebugUtility.h"

@implementation UIView (GaDebugUtility)

- (void)showSelfAndSubviewInfo {
    NSMutableString * mstr = [[NSMutableString alloc]init];
    [self addSelfAndSubviewInfo:self withTag:@"0" level:0 result:mstr];
    NSLog(@"View Hierachy is:\n%@",mstr);
}

//显示自己和子视图的info
- (void)addSelfAndSubviewInfo:(UIView *)view withTag:(NSString *)tag level:(int)level  result:(NSMutableString *)mstr{
    //增加自身view的信息
    [self addSelfInfo:view withTag:tag level:level result:mstr];
    //增加子view的信息
    for(int i = 0;i<view.subviews.count;i++) {
        UIView * subview = view.subviews[i];
        NSString *subTag = [NSString stringWithFormat:@"%@.%d",tag,i];
        [self addSelfAndSubviewInfo:subview withTag:subTag level:level+1 result:mstr];
    }
}

//显示自己的info
- (void)addSelfInfo:(UIView *)view withTag:(NSString *)tag level:(int)level result:(NSMutableString *)mstr{
    NSString * strPrefix = @"";
    for(int i = 0;i<level;i++) {
        strPrefix = [strPrefix stringByAppendingString:@"-|"];
    }
    NSString * str = [NSString stringWithFormat:@"%@%@:%@\n",strPrefix,tag,view.description];
    [mstr appendString:str];
}

@end
