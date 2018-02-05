#
# Be sure to run `pod lib lint TMChart.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMChart'
  s.version          = '0.1.0'
  s.summary          = 'TMChart图标库-摆乌龙'

  s.description      = <<-DESC
TODO: TMChart图标库,是我个人参考网上其他开源项目进行开发的一款图形图标库，注释还蛮详细，如能帮到你，帮忙点赞一下哈😄
                       DESC

  s.homepage         = 'https://github.com/baiwulong/TMChart'
  #s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'baiwulong' => '1204803180@qq.com' }
  s.source           = { :git => 'https://github.com/baiwulong/TMChart.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'UIKit'
end
