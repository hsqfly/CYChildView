//
//  CYChildVCView.h
//  ChildVCDemo
//
//  Created by Fly on 16/4/14.
//  Copyright © 2016年 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYChildVCView : UIView

@property (nonatomic, strong) NSArray *controllers;


- (instancetype)initWithFrame:(CGRect)frame;


- (instancetype)initWithFrame:(CGRect)frame Top:(CGRect)topFrame Title:(CGFloat)titleWidth Line:(CGFloat)lineWidth;


@end
