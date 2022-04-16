Pod::Spec.new do |s|
    s.name                  = 'Skima'
    s.version               = '0.1.1'
    s.homepage              = 'https://github.com/Skima-Framework/skima-ios'
    s.summary               = 'Skima - module'
    s.license               = { :type => 'AGPL-3.0', :file => 'LICENSE' }
    s.author                = 'Skima Framework'
    s.source                = { :git => 'https://github.com/Skima-Framework/skima-ios.git', :tag => s.version.to_s }
    
    s.platform              = :ios, '11.0'
    s.requires_arc          = true
    s.swift_version         = '5.1'
    s.static_framework      = true
    
    s.source_files          = 'Skima/**/*.{h,swift}'
  
    s.dependency 'PureLayout', '3.1.9'
    s.dependency 'Alamofire'
    s.dependency 'NanoID'
  
  end
  
