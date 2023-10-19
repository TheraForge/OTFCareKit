Pod::Spec.new do |s|
  s.name                  = 'OTFCareKit'
  s.version               = '1.0'
  s.summary               = 'OTFCareKit is an open source software framework for creating apps that help people better understand and manage their health.'
  s.homepage              = 'https://github.com/TheraForge/OTFCareKit'
  s.documentation_url     = 'https://github.com/TheraForge/OTFCareKit/blob/main/README.md'
  s.license               = { :type => 'BSD', :file => 'LICENSE' }
  s.author                = { 'Hippocrates Technologies' => 'hippocratestech-dev@googlegroups.com' }
  s.platform              = :ios
  s.ios.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'
  s.swift_versions = '5.0'
  s.source                = { :git => 'https://github.com/tf-pre-release/OTFCareKit.git', :branch => 'main' }
  s.exclude_files         = [ 'OTFCareKit/OTFCareKit/**/*.plist', 'OCKCatalog', 'OCKSample', 'DerivedData' ]
  s.xcconfig              = { 'LIBRARY_SEARCH_PATHS' => "$(SRCROOT)/Pods/**" }
  s.requires_arc          = true
  s.frameworks            = 'OTFCareKitUI', 'OTFCareKitStore'
  
  s.default_subspec = 'Default'
  s.dependency 'OTFCareKitUI', '1.0'

  s.subspec 'Default' do |ss|
    ss.source_files          = 'OTFCareKit/OTFCareKit/**/*.{h,m,swift}'
    ss.dependency 'OTFCareKitStore', '1.0'
  end

  s.subspec 'Care' do |ss|
    ss.source_files          = 'OTFCareKit/OTFCareKit/**/*.{h,m,swift}'
    ss.dependency 'OTFCareKitStore/Care', '1.0'
  end

  s.subspec 'Health' do |ss|
    ss.source_files          = 'OTFCareKit/OTFCareKit/**/*.{h,m,swift}'
    ss.dependency 'OTFCareKitStore/Health', '1.0'
  end

  s.subspec 'CareHealth' do |ss|
    ss.source_files          = 'OTFCareKit/OTFCareKit/**/*.{h,m,swift}'
    ss.dependency 'OTFCareKitStore/CareHealth', '1.0'
  end
   
end
