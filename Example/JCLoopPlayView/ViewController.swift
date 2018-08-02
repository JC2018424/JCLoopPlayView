//
//  ViewController.swift
//  JCLoopPlayView
//
//  Created by jc on 2018/7/30.
//  Copyright © 2018年 jc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JCLoopPlayDelegate {

    private let loopView: JCLoopPlayView = {
        let imageStrs = ["cat", "http://img.hb.aicdn.com/e7c668c293eaf44165c254b059ea991a765c525f70bb3d-GcUann_fw658", "cup", "orange", "desk", "fllow"]
        let rect = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 300)
        let loopView = JCLoopPlayView(frame: rect, imageStrs: imageStrs)
        return loopView
    }()
    
    public func currentIndex(_ index: Int) {
        print("当前index = \(index - 1)")
    }
    
    public func selectedIndex(_ index: Int) {
        print("选中index = \(index - 1)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loopView.delegate = self
        view.addSubview(loopView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

