//
//  SXTitleLable.m
//  85 - 网易滑动分页
//
//  Created by 董 尚先 on 15-1-31.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXTitleLable.h"

@implementation SXTitleLable {
        UIView *topLine;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.scale = 0.0;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18];
//        self.font = [UIFont fontWithName:@"HYQiHei" size:17];
//        self.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];//加粗
        self.font = CYFont(34);
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale{
    _scale = scale;
    self.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:scale+0.8];
//    CGFloat minScale = 0.9;
//    CGFloat trueScale = minScale + (1-minScale)*scale;
//    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

@end
