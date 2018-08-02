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
        let imageStrs = ["cat", "book", "cup", "orange", "desk", "fllow"]
        let rect = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 300)
        let loopView = JCLoopPlayView(frame: rect, imageStrs: imageStrs)
        return loopView
    }()
    
    public func currentIndex(_ index: Int) {
        print("index = \(index - 1)")
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

