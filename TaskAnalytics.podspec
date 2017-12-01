#
# Be sure to run `pod lib lint TaskAnalytics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TaskAnalytics'
  s.version          = '1.0.0'
  s.summary          = 'The natural next evolution in digital analytics.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Task Analytics captures and analyzes the intent of your customers and the outcome of their engagement with your business.
                       DESC

  s.homepage         = 'https://github.com/taskanalytics/taskanalytics-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Task Analytics' => 'hello@taskanalytics.com' }
  s.source           = { :git => 'https://github.com/taskanalytics/taskanalytics-ios-sdk.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/taskanalytics'

  s.ios.deployment_target = '10.0'

  s.source_files = 'TaskAnalytics/**/*'
  
  # s.resource_bundles = {
  #   'TaskAnalytics' => ['TaskAnalytics/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
