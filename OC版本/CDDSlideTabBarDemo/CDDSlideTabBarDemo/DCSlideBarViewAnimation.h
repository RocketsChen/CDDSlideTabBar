//
//  DCSlideBarViewAnimation.h
//  CDDSlideTabBarDemo
//
//  Created by SnailChen on 2018/10/17.
//  Copyright © 2018年 SnailChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCSlideBarViewAnimation : NSObject <UIViewControllerAnimatedTransitioning>


/**
 初始化

 @param targetEdge 方向
 @return 转场
 */
- (instancetype)dcInitWithSlideTargetEdge:(UIRectEdge)targetEdge;

@end
