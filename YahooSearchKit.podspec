Pod::Spec.new do |spec|
  spec.name = 'YahooSearchKit'
  spec.platform = :ios, '7.0'
  spec.version = ‘0.5.0’
  spec.summary = "Yahoo Search SDK for iOS"
  spec.license     = { :type => 'Yahoo', :text => 'Yahoo Confidential' }
  spec.homepage = 'https://github.com/yahoo/searchsdk-ios'
  spec.author = {
    'Mobile Search' => 'mobile-search-eng@yahoo-inc.com'
  }

  spec.source = {
    :git => 'https://github.com/yahoo/searchsdk-ios.git',
    :tag => spec.version.to_s
  }

  spec.requires_arc = true
  spec.preserve_paths = ['Framework/YahooSearchKit.framework']
  spec.vendored_frameworks = ['Framework/YahooSearchKit.framework']
  spec.resources = 'Framework/YahooSearchKit.framework/Versions/A/Resources/YahooSearchKitResources.bundle'
  spec.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/Framework', 'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/Framework' }
  spec.weak_framework = 'WebKit'
end
