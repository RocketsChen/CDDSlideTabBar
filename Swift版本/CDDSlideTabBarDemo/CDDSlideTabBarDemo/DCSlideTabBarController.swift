//
//  DCSlideTabBarController.swift
//  CDDSlideTabBarDemo
//
//  Created by 陈甸甸 on 2019/2/23.
//Copyright © 2019 陈甸甸. All rights reserved.
//


import UIKit

class DCSlideTabBarController: UITabBarController{
    
    
    // MARK: - LazyLoad
    var currentChildVc: UIViewController?
    var areaInsets: CGFloat = 0.0
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        addChildViewContorller() //设置子控制器
    }
}

// MARK: - 设置 UI 界面
extension DCSlideTabBarController {
    
    fileprivate func setUpUI() {
        
        view.backgroundColor = .white
        
        self.delegate = self
        
        /// 安全距离的简单判断
        areaInsets = (UIScreen.main.bounds.size.height >= 812) ? 34.0 : 0
    }
}



// MARK: - 设置子控制器
extension DCSlideTabBarController {
    
    func addChildViewContorller () {
        
        let childArray = [
            [
                "rootVCClassString"  : "DCFViewController",
                "title"  : "美信",
                "imageName"    : "tabr_01_up",
                "selectedImageName" : "tabr_01_down"
            ],[
                "rootVCClassString"  : "DCSViewController",
                "title"  : "美信",
                "imageName"    : "tabr_01_up",
                "selectedImageName" : "tabr_01_down"
            ],[
                "rootVCClassString"  : "DCTViewController",
                "title"  : "美信",
                "imageName"    : "tabr_01_up",
                "selectedImageName" : "tabr_01_down"
            ]
            ] as [Any]
        
        for tabDict in childArray {
            
            let result = tabDict as![String:Any]  // 先声明告诉tabDict是个字典
            
            guard let vcName = result["rootVCClassString"] as? String else { continue }
            guard let normalImg = result["imageName"] as? String else { continue }
            guard let selImg = result["selectedImageName"] as? String else { continue }
//            guard let title = result["title"] as? String else { continue }
            
            let childVc = getVcFromString(vcName)
            currentChildVc = childVc
            
            childVc.tabBarItem.image = UIImage(named: normalImg)
            childVc.tabBarItem.selectedImage = UIImage(named: selImg)
            childVc.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0) //只有图片的时候需要设置 大致偏移6px
//            childVc.tabBarItem.title = title //tu
            
            let childNav = UINavigationController(rootViewController: childVc)
            
            addChild(childNav)

        }
        
        if let currentChildVc = currentChildVc { // 处理tabBarItem 选中颜色
            guard let tabBar = currentChildVc.tabBarController?.tabBar else {
                return
            }
            guard let count = currentChildVc.tabBarController?.children.count else {
                return
            }
            let tabBarWidth = tabBar.frame.size.width
            let tabBarHeight = tabBar.frame.size.height
            let childCount = CGFloat(count)
            
            tabBar.selectionIndicatorImage = drawImageWithColor(color: UIColor.darkGray, size: CGSize(width: tabBarWidth / childCount, height: tabBarHeight + areaInsets))
        }
    }
    
    //  swiftlint:disable force_unwrapping
    private func getVcFromString(_ vcName: String) -> UIViewController {
        
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有获取到命名空间")
            return UIViewController()
        }
        
        guard let childVcClass = NSClassFromString(nameSpace + "." + vcName) else {
            print("没有获取到字符串对应的Class")
            return UIViewController()
        }
        
        guard let childVcType = childVcClass as? UIViewController.Type else {
            print("没有获取对应控制器的类型")
            return UIViewController()
        }
        
        return childVcType.init()
    }
    
    
    /// 绘制选中Item的背景色
    private func drawImageWithColor(color : UIColor , size : CGSize) -> UIImage {
        guard  size.width > 0 && size.height > 0  else {
            return UIImage()
        }
        let itemRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(itemRect.size, false, 0) //开始绘制
        let contRef : CGContext = UIGraphicsGetCurrentContext()!;
        
        contRef.setFillColor(color.cgColor);
        contRef.fill(itemRect);
        let selectBgImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage(); //绘图
        UIGraphicsEndImageContext(); //结束绘制
        
        return selectBgImage
    }
}

// MARK: - 处理代理方法
extension DCSlideTabBarController : UITabBarControllerDelegate {

    /// 点击动画
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        tabBarButtonClick(tabBarButton: getTabBarButton())
        
    }
    
    
    /// 滑动动画
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DCSlideBarAnimation() //滑动动画
    }
    

    private func getTabBarButton() -> UIControl {

        var tabBarButtons = Array<UIView>()
        for tabBarButton in tabBar.subviews {
            if (tabBarButton.isKind(of:NSClassFromString("UITabBarButton")!)){
                tabBarButtons.append(tabBarButton)
            }
        }
        return tabBarButtons[selectedIndex] as! UIControl
    }
    
    private func tabBarButtonClick(tabBarButton : UIControl) {
        
        for imageView in tabBarButton.subviews {
            if (imageView.isKind(of: NSClassFromString("UITabBarSwappableImageView")!)){
                let animation = CAKeyframeAnimation()
                animation.keyPath = "transform.scale"
                animation.duration = 0.3
                animation.calculationMode = CAAnimationCalculationMode(rawValue: "cubicPaced")
                animation.values = [1.0,1.1,0.9,1.0]
                imageView.layer.add(animation, forKey: nil)
            }
        }
    }
    
}

