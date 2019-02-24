//
//  DCSlideTabBarController.m
//  CDDSlideTabBarDemo
//
//  Created by SnailChen on 2018/10/17.
//Copyright © 2018年 SnailChen. All rights reserved.
//

/******************    TabBar          *************/
#define MallClassKey   @"rootVCClassString"
#define MallTitleKey   @"title"
#define MallImgKey     @"imageName"
#define MallSelImgKey  @"selectedImageName"

#import "DCSlideTabBarController.h"
// Controllers

// Models
#import "DCSlideBarViewAnimation.h"
// Views

// Vendors

// Categories

// Others

@interface DCSlideTabBarController ()<UITabBarControllerDelegate>



@end

@implementation DCSlideTabBarController

#pragma mark - LazyLoad


#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //遵守代理
    self.delegate = self;
    
    [self addChildViewContorller];
}


#pragma mark - 添加子控制器
- (void)addChildViewContorller
{
    NSArray *childArray = @[
                            @{MallClassKey  : @"DCFViewController",
                              MallTitleKey  : @"美信",
                              MallImgKey    : @"tabr_01_up",
                              MallSelImgKey : @"tabr_01_down"},
                            
                            @{MallClassKey  : @"DCSViewController",
                              MallTitleKey  : @"首页",
                              MallImgKey    : @"tabr_02_up",
                              MallSelImgKey : @"tabr_02_down"},
                            
                            @{MallClassKey  : @"DCTViewController",
                              MallTitleKey  : @"美媒榜",
                              MallImgKey    : @"tabr_03_up",
                              MallSelImgKey : @"tabr_03_down"},
                            ];
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *vc = [NSClassFromString(dict[MallClassKey]) new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.image = [UIImage imageNamed:dict[MallImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[MallSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0);//（当只有图片的时候）需要自动调整
        [self addChildViewController:nav];
    }];
}



#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
    
}

- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    return tabBarButton;
}


#pragma mark - <UITabBarControllerDelegate>

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    [self tabBarButtonClick:[self getTabBarButton]]; //点击tabBarItem动画代理
}

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    //页面切换代理
    NSArray *tabViewControllers = tabBarController.viewControllers;
    
    NSLog(@"toVc : %zd  ----- fromVc : %zd",[tabViewControllers indexOfObject:toVC],[tabViewControllers indexOfObject:fromVC]);
    
    if ([tabViewControllers indexOfObject:toVC] > [tabViewControllers indexOfObject:fromVC]) { // left
        return [[DCSlideBarViewAnimation alloc] dcInitWithSlideTargetEdge:UIRectEdgeLeft];
    }else{ // right
        return [[DCSlideBarViewAnimation alloc] dcInitWithSlideTargetEdge:UIRectEdgeRight];
    }
}

@end
