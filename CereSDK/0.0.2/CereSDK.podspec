Pod::Spec.new do |spec|

  spec.name         = "CereSDK"
  spec.version      = "0.0.2"
  spec.summary      = "CereSDK for iOS"
  spec.description  = "The library is CereSDK wrapper for iOS"

  spec.homepage     = "https://www.cere.io/"

  spec.license      = "MIT"

  spec.author             = { "Cerebellum Network, Inc." => "info@cere.io" }

  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/cere-io/sdk-ios.git", :tag => "#{spec.version}" }

  spec.source_files  = "CereSDK/**/*.swift"
  spec.swift_version = "5"

end
