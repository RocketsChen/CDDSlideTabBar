//
//  DCSlideBarAnimation.swift
//  CDDSlideTabBarDemo
//
//  Created by 陈甸甸 on 2019/2/23.
//  Copyright © 2019 陈甸甸. All rights reserved.
//

import UIKit

class DCSlideBarAnimation: NSObject{

}

// MARK: - 代理方法
extension DCSlideBarAnimation : UIViewControllerAnimatedTransitioning{
    
    /// 设置时间间隔
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
    
    /// 处理转场
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromeVc = transitionContext.viewController(forKey: .from),
              let toVc = transitionContext.viewController(forKey: .to) else { return }
        
    
        guard let tabVc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
            let fromeIndex = tabVc.viewControllers?.firstIndex(where: { $0 == fromeVc}),
            let toIndex = tabVc.viewControllers?.firstIndex(where: { $0 == toVc}) else { return }
        
        guard let formView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else { return }
        
        let fromFrame : CGRect = formView.frame
        let toFrame : CGRect = toView.frame

  
        var offSet : CGVector?
        if toIndex > fromeIndex {
            offSet = CGVector(dx: -1, dy: 0)
        }else{
            offSet = CGVector(dx: 1, dy: 0)
        }
        
        guard let animOffSet = offSet else { return }
        formView.frame = fromFrame

        let ofDx : CGFloat = animOffSet.dx
        let ofDy : CGFloat = animOffSet.dy
        toView.frame = CGRect.offsetBy(toFrame)(dx: toFrame.size.width * ofDx * -1, dy: toFrame.size.height * ofDy * -1)
        transitionContext.containerView.addSubview(toView)

        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, animations: { //动画
            
            formView.frame = CGRect.offsetBy(fromFrame)(dx: fromFrame.size.width * ofDx * 1, dy: fromFrame.size.height * ofDy * 1)
            toView.frame = toFrame;

        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
