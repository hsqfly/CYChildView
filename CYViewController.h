//
//  CYViewController.h
//  学图
//
//  Created by Fly on 2017/3/8.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYNavigationBar.h"


@interface CYViewController : UIViewController


@property (nonatomic, strong) CYNavigationBar *topbar;


- (void)pop;

- (void)popToRootVc;

- (void)popToVc:(UIViewController *)vc;

- (void)dismiss;

- (void)dismissWithCompletion:(void(^)())completion;

- (void)presentVc:(UIViewController *)vc;

- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion;

- (void)pushVc:(UIViewController *)vc;

- (void)removeChildVc:(UIViewController *)childVc;

- (void)addChildVc:(UIViewController *)childVc;

/**跳转到系统相册*/
- (void)presentToPhotoAlbum;



@end
