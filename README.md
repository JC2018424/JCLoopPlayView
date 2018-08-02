# JCLoopPlayView
一行代码解决：无限轮播（暂只支持本地图片，后续支持url路径与自定义视图等...）

# 支持pod
pod 'JCLoopPlayView'

# 头文件
import JCLoopPlayView

# Example，初始化视图大小，图片名称或url路径
let loopView = JCLoopPlayView(frame: CGRect(x: 0, y: 20, width: view.bounds.width, height: 300), imageStrs: ["", ""])
view.addSubview(loopView)

# 设置代理（JCLoopPlayDelegate）
loopView.delegate = self

# 代理方法
当前轮播的下标
func currentIndex(_ index: Int) { }
选中图片的下标
func selectedIndex(_ index: Int) { }
