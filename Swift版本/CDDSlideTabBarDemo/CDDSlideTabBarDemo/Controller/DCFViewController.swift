//
//  DCFViewController.swift
//  CDDSlideTabBarDemo
//
//  Created by 陈甸甸 on 2019/2/23.
//Copyright © 2019 陈甸甸. All rights reserved.
//

import UIKit

class DCFViewController: UIViewController {
    
    // MARK: - LazyLoad
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
}

// MARK: - 设置 UI 界面
extension DCFViewController {
    
    fileprivate func setUpUI() {
        
        view.backgroundColor = .brown
        navigationItem.title = "第一控制器"
    }
}
