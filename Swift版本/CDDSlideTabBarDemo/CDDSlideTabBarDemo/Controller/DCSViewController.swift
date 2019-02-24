//
//  DCSViewController.swift
//  CDDSlideTabBarDemo
//
//  Created by 陈甸甸 on 2019/2/23.
//Copyright © 2019 陈甸甸. All rights reserved.
//

import UIKit

class DCSViewController: UIViewController {
    
    // MARK: - LazyLoad
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
}

// MARK: - 设置 UI 界面
extension DCSViewController {
    
    fileprivate func setUpUI() {
        
        view.backgroundColor = .gray
        navigationItem.title = "第二控制器"
    }
}
