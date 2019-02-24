//
//  DCSlideBarViewAnimation.m
//  CDDSlideTabBarDemo
//
//  Created by SnailChen on 2018/10/17.
//  Copyright © 2018年 SnailChen. All rights reserved.
//

#import "DCSlideBarViewAnimation.h"
#import <UIKit/UIKit.h>
#import "DCSlideTabBarController.h"

@interface DCSlideBarViewAnimation()


/**
 typedef NS_OPTIONS(NSUInteger, UIRectEdge) {
 UIRectEdgeNone   = 0,
 UIRectEdgeTop    = 1 << 0,
 UIRectEdgeLeft   = 1 << 1,
 UIRectEdgeBottom = 1 << 2,
 UIRectEdgeRight  = 1 << 3,
 UIRectEdgeAll    = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight
 } NS_ENUM_AVAILABLE_IOS(7_0);
 */
@property (nonatomic, assign) UIRectEdge targetEdge;

@end

@implementation DCSlideBarViewAnimation

#pragma mark - 初始化
- (instancetype)dcInitWithSlideTargetEdge:(UIRectEdge)targetEdge
{
    if ([self init]) {
        _targetEdge = targetEdge;
    }
    return self;
}

#pragma mark - 事件间隔
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.15;
}

#pragma mark - <UIViewControllerAnimatedTransitioning>
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
  
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromVc];
    CGRect toFrame = [transitionContext finalFrameForViewController:toVc];
    
//    DCSlideTabBarController *tabVc = (DCSlideTabBarController *)UIApplication.sharedApplication.keyWindow.rootViewController;
//    tabVc.viewControllers; //swift 的内部判断UIRectEdge
    
    CGVector offset;
    if (self.targetEdge == UIRectEdgeLeft){
        offset = CGVectorMake(-1.f, 0.f);
    }else if (self.targetEdge == UIRectEdgeRight){
        offset = CGVectorMake(1.f, 0.f);
    }
    fromView.frame = fromFrame;
    toView.frame = CGRectOffset(toFrame,toFrame.size.width * offset.dx * -1,toFrame.size.height * offset.dy * -1);
    [transitionContext.containerView addSubview:toView];
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext]; //获取专场事件
    [UIView animateWithDuration:transitionDuration animations:^{
        fromView.frame = CGRectOffset(fromFrame,fromFrame.size.width * offset.dx,fromFrame.size.height * offset.dy);
        toView.frame = toFrame;
    } completion:^(BOOL finished) {
        //告诉专场动画结束 !transitionContext.transitionWasCancelled，是为了后续手势交互，避免手势取消时，造成卡顿现象。
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
