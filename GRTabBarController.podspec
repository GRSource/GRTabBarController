Pod::Spec.new do |s|
  s.name         = "GRTabBarController"
  s.version      = "1.0.1"
  s.summary      = "Highly customizable tabBar and tabBarController for iOS"
  s.description  = "GRTabBarController is iPad and iPhone compatible. Supports landscape and portrait orientations and can be used inside UINavigationController."
  s.homepage     = "https://github.com/GRSource/GRTabBarController"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "delon alain" => "delonalain@gmail.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/GRSource/GRTabBarController.git", :tag => "v1.0.1" }
  s.source_files  = 'GRTabBarController', 'GRTabBarController/**/*.{swift}’
  s.framework = 'UIKit', 'CoreGraphics', 'Foundation'
  s.requires_arc = true
end
