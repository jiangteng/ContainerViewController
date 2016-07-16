#
# Be sure to run `pod lib lint ContainerViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ContainerViewController'
  s.version          = '0.1.1'
  s.summary          = 'ContainerViewController.'

  s.description      = <<-DESC
 Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jiangteng/ContainerViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JiangTeng' => 'teng.jiang@dianping.com' }
  s.source           = { :git => 'https://github.com/jiangteng/ContainerViewController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'ContainerViewController/Classes/**/*'
end
