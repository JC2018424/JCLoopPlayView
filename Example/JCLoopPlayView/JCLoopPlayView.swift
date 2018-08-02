//
//  JCLoopPlayView.swift
//  LoopPlayView
//
//  Created jc on 2018/7/30.
//  Copyright © 2018年 jc. All rights reserved.
//

import UIKit
import Kingfisher

public protocol JCLoopPlayDelegate {
    func currentIndex(_ index: Int)
}

extension JCLoopPlayDelegate {
    func currentIndex(_ index: Int) { }
}

// MARK: - 外部事件
extension JCLoopPlayView {
    
    /// 开始循环
    public func startLoop(timeInterval: TimeInterval = 2) {
        stopLoop()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(loop), userInfo: nil, repeats: true)
    }
    
    /// 停止循环
    public func stopLoop() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - 代理事件
extension JCLoopPlayView: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopLoop()
        isHandleScroll = true
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isHandleScroll else { return }
        if scrollView.contentOffset.x <= 0 {
            scrollView.contentOffset.x = CGFloat(imageStrs.count - 2) * bounds.width
        } else if scrollView.contentOffset.x >= bounds.width * CGFloat(imageStrs.count - 1) {
            scrollView.contentOffset.x = bounds.width
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startLoop()
        isHandleScroll = false
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x = CGFloat(imageStrs.count - 2) * bounds.width
            index = imageStrs.count - 2
            delegate?.currentIndex(index)
        } else {
            let currentOff = lround(Double(scrollView.contentOffset.x / bounds.width))
            let bool = currentOff == imageStrs.count - 1
            index = bool ? 1 : currentOff
            scrollView.contentOffset.x = bool ? bounds.width : CGFloat(currentOff) * bounds.width
            delegate?.currentIndex(index)
        }
    }
}

final public class JCLoopPlayView: UIView {
    
    // MARK: - 公共变量
    
    /// 代理
    public var delegate: JCLoopPlayDelegate?
    
    // MARK: - 私有变量
    
    /// 循环事件
    @objc internal func loop() {
        index += 1
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.scrollView.contentOffset.x = CGFloat(self?.index ?? 1) * (self?.bounds.width ?? 1)
        }
        guard index == imageStrs.count - 1 else { delegate?.currentIndex(index); return }
        index = 1
        scrollView.contentOffset.x = bounds.width
        delegate?.currentIndex(index)
    }
    
    /// 当前下表
    private var index: Int = 1
    /// 计时器
    private var timer: Timer?
    /// 是否是手动滑动
    private var isHandleScroll: Bool = false
    /// 图片资源
    private var imageStrs: [String] = []
    
    // MARK: - 初始化
    public init(frame: CGRect, imageStrs: [String]) {
        super.init(frame: frame)
        
        self.imageStrs = imageStrs
        self.imageStrs.insert(imageStrs.last ?? "", at: 0)
        self.imageStrs.append(imageStrs.first ?? "")
        baseConfig(); addSubView(); layout()
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        startLoop()
    }
    
    public override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        stopLoop()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 基础设置
    fileprivate func baseConfig() {
        
    }
    
    // MARK: - 添加控件
    fileprivate func addSubView() {
        addSubview(scrollView)
        for i in 0..<imageStrs.count {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: CGFloat(i) * bounds.width,
                                     y: 0,
                                     width: bounds.width,
                                     height: bounds.height)
            imageView.image = UIImage(named: imageStrs[i])
            scrollView.addSubview(imageView)
        }
    }
    
    // MARK: - 控件布局
    fileprivate func layout() {
        scrollView.frame = bounds
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentOffset.x = bounds.width
        scrollView.contentSize = CGSize(width: CGFloat(imageStrs.count) * bounds.width,
                                        height: bounds.height)
    }
    
    // MARK: - 控件加载
    
    /// scrollView加载
    private let scrollView = UIScrollView()
}
