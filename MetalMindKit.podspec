#
# Be sure to run `pod lib lint MetalMindKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MetalMindKit"
  s.version          = "0.1-alpha.1"
  s.summary          = "Framework for metal mind game iOS"
  s.description      = "Framework for metal mind game iOS"
  s.homepage         = "https://github.com/s-i-m-p-l-e/MetalMindKit"
  s.license          = ' '
  s.author           = { "s-i-m-p-l-e" => "vasilica.victor@gmail.com" }
  s.source           = { :git => "git@github.com:s-i-m-p-l-e/MetalMindKit.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Source/*.swift'

  #s.frameworks = 'UIKit'
end
