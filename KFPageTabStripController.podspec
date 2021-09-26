#
# Be sure to run `pod lib lint KFPageTabStripController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KFPageTabStripController'
  s.version          = '0.1.0'
  s.summary          = 'A short description of KFPageTabStripController.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/7035329/KFPageTabStripController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '7035329' => 'jieyang@didichuxing.com' }
  s.source           = { :git => 'https://github.com/7035329/KFPageTabStripController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '5.3'
  s.ios.deployment_target = '9.0'

  s.source_files = 'KFPageTabStripController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KFPageTabStripController' => ['KFPageTabStripController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'SnapKit'
end
