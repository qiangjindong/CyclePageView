#
#  Be sure to run `pod spec lint BLAPIManagers.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "CyclePageView"
  s.version      = "0.0.1"
  s.summary      = "CyclePageView."

  s.description  = <<-DESC
                    this is CyclePageView
                   DESC

  s.homepage     = "https://github.com/qiangjindong/CyclePageView"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "QJD" => "qiangjindong@163.com" }
  
  s.swift_version= '4.2'
  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/qiangjindong/CyclePageView.git", :tag => s.version.to_s }

  s.source_files  = "Sources/**/*.{h,m,swift}"

  s.requires_arc = true
  
end
