#
# Be sure to run `pod lib lint HorizontalList.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HList'
  s.version          = '1.2.0'
  s.summary          = 'A container that presents horizontal scrollable view.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'HorizontalList is an efficient SwiftUI horizontal ScrollView which loads only visible elements. HorizontalList subviews could be different size.'
  s.homepage         = 'https://github.com/ivorost/HorizontalList'
  s.screenshots      = 'https://habrastorage.org/getpro/habr/post_images/ac2/668/eed/ac2668eed4fd65240cb7e8f17b5b4220.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ivan Khvorostinin' => 'ihvorostinin@gmail.com' }
  s.source           = { :git => 'https://github.com/ivorost/HorizontalList.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_versions = ['5.0']

  s.source_files = 'HorizontalList/Classes/**/*'
  
end
