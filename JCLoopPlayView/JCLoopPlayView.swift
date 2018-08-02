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
    
    /// 当前page下标
    func currentIndex(_ index: Int)
    /// 选中下标
    func selectedIndex(_ index: Int)
}

extension JCLoopPlayDelegate {
    func currentIndex(_ index: Int) { }
    func selectedIndex(_ index: Int) { }
}

// MARK: - 外部事件
extension JCLoopPlayView {
    
    /// 设置pageControl的选中/未选中颜色
    ///
    /// - Parameters:
    ///   - pageColor: 所有page的颜色
    ///   - currentPageColor: 选中page的颜色
    public func setPageControl(pageColor: UIColor = .lightGray,
                               currentPageColor: UIColor = .white) {
        control.pageIndicatorTintColor = pageColor
        control.currentPageIndicatorTintColor = currentPageColor
    }
    
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
            showPageIndex(index)
        } else {
            let currentOff = lround(Double(scrollView.contentOffset.x / bounds.width))
            let bool = currentOff == imageStrs.count - 1
            index = bool ? 1 : currentOff
            scrollView.contentOffset.x = bool ? bounds.width : CGFloat(currentOff) * bounds.width
            showPageIndex(index)
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
        guard index == imageStrs.count - 1 else { showPageIndex(index); return }
        index = 1
        scrollView.contentOffset.x = bounds.width
        showPageIndex(index)
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
    
    /// 显示pageControl的页码
    internal func showPageIndex(_ index: Int) {
        delegate?.currentIndex(index)
        control.currentPage = index - 1
    }
    
    /// 图片点击
    @objc internal func click(btn: UIButton) {
        delegate?.selectedIndex(btn.tag - 100)
    }
    
    // MARK: - 基础设置
    fileprivate func baseConfig() {
        control.numberOfPages = imageStrs.count - 2
        setPageControl()
    }
    
    // MARK: - 添加控件
    fileprivate func addSubView() {
        addSubview(scrollView)
        addSubview(control)
        for i in 0..<imageStrs.count {
            let imageBtn = UIButton()
            imageBtn.frame = CGRect(x: CGFloat(i) * bounds.width,
                                     y: 0,
                                     width: bounds.width,
                                     height: bounds.height)
            if let img = UIImage(named: imageStrs[i]) {
                imageBtn.setImage(img, for: .normal)
            } else if let url = URL(string: imageStrs[i]) {
                imageBtn.kf.setImage(with: url, for: .normal)
            }
            imageBtn.isUserInteractionEnabled = true
            imageBtn.tag = 100 + i
            imageBtn.addTarget(self, action: #selector(click), for: .touchUpInside)
            scrollView.addSubview(imageBtn)
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
        control.frame = CGRect(x: 0, y: bounds.height - 30, width: bounds.width, height: 30)
    }
    
    // MARK: - 控件加载
    
    /// scrollView加载
    private let scrollView = UIScrollView()
    
    /// pageControl
    private let control: UIPageControl = {
        let control = UIPageControl()
        control.isUserInteractionEnabled = false
        control.backgroundColor = .clear
        return control
    }()
}
