//
//  CYChildVCView.m
//  ChildVCDemo
//
//  Created by Fly on 16/4/14.
//  Copyright © 2016年 Fly. All rights reserved.
//

#import "CYChildVCView.h"
#import "SXTitleLable.h"
#import "CYChildController.h"


@interface CYChildVCView () <UIScrollViewDelegate> {
    NSUInteger controlIndex;
    NSMutableArray *titleArr;
    UIScrollView *smallScroll;
    UIScrollView *bigScroll;
    UIImageView *bottomLine;
}

@end

@implementation CYChildVCView {
    CGRect bigScrollFrame;//内容scrollFrame
    CGRect smallScrollFrame;//顶部scrollFrame
    CGFloat labelWidth;//标题的宽度
    CGFloat bottomWidth;//标题底部横线长度
    CGFloat labelHight;//标题高度=顶部frame的高度
}

- (instancetype)initWithFrame:(CGRect)frame Top:(CGRect)topFrame Title:(CGFloat)titleWidth Line:(CGFloat)lineWidth {
    smallScrollFrame=topFrame;
    labelWidth=titleWidth;
    bottomWidth=lineWidth;
    labelHight = topFrame.size.height;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {//如果没有设置初始值
        if (!labelWidth||!labelHight||!bottomWidth) {
            labelHight = 40.0;
            labelWidth = kWidth/5.0;
            bottomWidth = kWidth/7.0;
            smallScrollFrame=CGRectMake(0, 0, kWidth, labelHight);
        }
        
        #pragma mark 布局页面
        //主页面scrollView背景
        bigScroll = [[UIScrollView alloc] init];
        bigScrollFrame = CGRectMake(0, labelHight, frame.size.width, frame.size.height-labelHight);
        bigScroll.showsHorizontalScrollIndicator = NO;
        bigScroll.showsVerticalScrollIndicator = NO;
        [bigScroll setFrame:bigScrollFrame];
        [self addSubview:bigScroll];
        bigScroll.delegate =self;
        
        UIView *smallBackView = [[UIView alloc] initWithFrame:smallScrollFrame];
        smallBackView.backgroundColor = mainColor;
        [self addSubview:smallBackView];
        
        //日期栏scrollView背景
        smallScroll = [[UIScrollView alloc] init];
        CGRect smallRect = CGRectMake(smallScrollFrame.origin.x, smallScrollFrame.origin.y, smallScrollFrame.size.width, smallScrollFrame.size.height+6);
        [smallScroll setFrame: smallRect];
        smallScroll.showsHorizontalScrollIndicator = NO;
        smallScroll.showsVerticalScrollIndicator = NO;
        [self addSubview:smallScroll];


        
        //底部分割线
//        UIView *longLine = [[UIView alloc] init];
//        [longLine setFrame:CGRectMake(0, labelHight-kLenth(1), frame.size.width, kLenth(1))];
//        longLine.backgroundColor = backColor;
//        [self addSubview:longLine];
    }
    return self;
}


static UIFont *titleFount;//设置title大小
#pragma mark 设置子控制器
- (void)setControllers:(NSArray *)controllers {
    _controllers = controllers;
    if (_controllers.count>3) {
        titleFount=CYFont(30);
    } else {
        titleFount=CYFont(36);
    }
    [smallScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [bigScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addTopSmallScrolTitleLables];
    [self addBigScrollViewControllers];
}

#pragma mark 根据数组添加标题
- (void)addTopSmallScrolTitleLables {
    titleArr = [NSMutableArray array];
    smallScroll.contentSize = CGSizeMake(labelWidth * _controllers.count, 0);
    
    
    for (int i = 0; i < _controllers.count; i++) {
        CGRect lblFrame =CGRectMake(labelWidth*i, -0, labelWidth, labelHight-kLenth(12));
        SXTitleLable *lbl = [[SXTitleLable alloc]initWithFrame:lblFrame];
        lbl.text = ((CYChildController *)self.controllers[i]).title;
        lbl.userInteractionEnabled = YES;
        lbl.font=titleFount;
        lbl.tag = i;
        [titleArr addObject:lbl];
        [smallScroll addSubview:lbl];
        [lbl addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
    }
}

- (void)lblClick:(UITapGestureRecognizer *)recognizer {
    SXTitleLable *titlelable = (SXTitleLable *)recognizer.view;
    CGFloat offsetX = titlelable.tag * bigScroll.frame.size.width;
    CGFloat offsetY = bigScroll.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [bigScroll setContentOffset:offset animated:YES];
}

#pragma mark 设置默认控制器和标题
- (void)addBigScrollViewControllers {
    CGFloat contentX = self.controllers.count * self.frame.size.width;
    bigScroll.contentSize = CGSizeMake(contentX, 0);
    bigScroll.pagingEnabled = YES;
    
    //标题
    SXTitleLable *lable = [titleArr firstObject];
    lable.scale = 1.0;
    
    //控制器视图
    CYChildController *vc = [self.controllers firstObject];
    vc.view.frame = bigScroll.bounds;
    [bigScroll addSubview:vc.view];
    vc.index = 0;
    
    //底部动画线
    bottomLine = [[UIImageView alloc] init];
    [bottomLine setFrame:CGRectMake((labelWidth-bottomWidth)/2.0, labelHight-kLenth(12), bottomWidth, 12)];
    bottomLine.image = [UIImage imageNamed:@"nav_selectbar"];
    [smallScroll addSubview:bottomLine];
}



#pragma mark - ******************** scrollView代理方法
//正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    SXTitleLable *labelLeft = titleArr[leftIndex];
    labelLeft.scale = scaleLeft;
    
    if (rightIndex < titleArr.count) {// 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
        SXTitleLable *labelRight = titleArr[rightIndex];
        labelRight.scale = scaleRight;
    }
    
    CGFloat bottomLineX = value*labelWidth;
    bottomLine.frame = CGRectMake(bottomLineX+(labelWidth-bottomWidth)/2.0, bottomLine.frame.origin.y, bottomWidth, kLenth(24));
    
}

//滚动结束后调用（代码导致)
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView   {
    controlIndex = scrollView.contentOffset.x / bigScroll.frame.size.width;//获得索引
    SXTitleLable *titleLable = (SXTitleLable *)titleArr[controlIndex];    //滚动标题栏
    
    CGFloat offsetx = titleLable.center.x - smallScroll.frame.size.width * 0.5;
    CGFloat offsetMax = smallScroll.contentSize.width - smallScroll.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax) {
        offsetx = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetx, smallScroll.contentOffset.y);
    [smallScroll setContentOffset:offset animated:YES];
    
    // 向右滑动时 添加控制器
    CYChildController *newsVc = self.controllers[controlIndex];
    newsVc.index = controlIndex;
    [titleArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != controlIndex) {
            SXTitleLable *temlabel = titleArr[idx];
            [temlabel setScale:0.0];
        }
    }];
    if (newsVc.view.superview) return;
    newsVc.view.frame = scrollView.bounds;
    [bigScroll addSubview:newsVc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {//滚动结束（手势导致)
    [self scrollViewDidEndScrollingAnimation:scrollView];
}








@end
