Pod::Spec.new do |s|
  s.name                  = 'OTFCareKit'
  s.version               = '2.0.2-tf.2'
  s.summary               = 'OTFCareKit is an open source software framework for creating apps that help people better understand and manage their health.'
  s.homepage              = 'https://github.com/TheraForge/OTFCareKit'
  s.documentation_url     = 'https://github.com/TheraForge/OTFCareKit/blob/main/README.md'
  s.license               = { :type => 'BSD', :file => 'LICENSE' }
  s.author                = { 'Hippocrates Technologies' => 'hippocratestech-dev@googlegroups.com' }
  s.source                = { :git => 'https://github.com/TheraForge/OTFCareKit.git', :tag => s.version.to_s }
  s.exclude_files         = [ 'OTFCareKit/OTFCareKit/**/*.plist', 'OCKCatalog', 'OCKSample', 'DerivedData' ]

  s.requires_arc          = true
  
  s.ios.deployment_target = '16.0'
  s.watchos.deployment_target = '9.0'
  s.swift_versions = '5.0'
  s.default_subspec = 'Default'
  s.dependency 'OTFCareKitUI', '2.0.2-tf.2'

  s.subspec 'Default' do |ss|
    ss.source_files = 'OTFCareKit/OTFCareKit/**/*.{h,m,swift}'
    ss.dependency 'OTFCareKitStore', '2.0.2-tf.2'
  end

  s.subspec 'Care' do |ss|
    ss.source_files = 'OTFCareKit/OTFCareKit/**/*.{h,m,swift}'
    ss.dependency 'OTFCareKitStore/Care', '2.0.2-tf.2'
  end

  s.subspec 'Health' do |ss|
    ss.source_files = 'OTFCareKit/OTFCareKit/**/*.{h,m,swift}'
    ss.dependency 'OTFCareKitStore/Health', '2.0.2-tf.2'
  end

  s.subspec 'CareHealth' do |ss|
    ss.source_files = 'OTFCareKit/OTFCareKit/**/*.{h,m,swift}'
    ss.dependency 'OTFCareKitStore/CareHealth', '2.0.2-tf.2'
  end
end
