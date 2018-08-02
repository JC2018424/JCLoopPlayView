Pod::Spec.new do |s|
s.name         = 'JCLoopPlayView'
s.version      = '0.0.1'
s.summary      = '简单实用的无限轮播（暂只支持本地图片）'
s.homepage     = 'https://github.com/JC2018424/JCLoopPlayView'
s.license      = 'MIT'
s.authors      = {'JC' => '13451001517@163.com'}
s.platform     = :ios, '9.0'
s.source       = {:git => 'https://github.com/JC2018424/JCLoopPlayView.git', :tag => s.version}
s.source_files = 'JCLoopPlayView/*.swift'
s.requires_arc = true
s.framework  = 'UIKit'
s.dependency 'Kingfisher', '~> 4.7.0'

s.swift_version    = '4.0'

end
