Pod::Spec.new do |s|
    s.name                  = 'Skima'
    s.version               = '0.1.0'
    s.homepage              = 'www.google.com'
    s.summary               = 'Skima - module'
    s.license               = { :type => 'MIT', :file => 'LICENSE.txt' }
    s.author                = 'Skima Framework'
    s.source                = { :path => '/Users/joaquinbozalla/Desktop/myProjects/Skima' }
    
    s.platform              = :ios, '11.0'
    s.requires_arc          = true
    s.swift_version         = '5.1'
    s.static_framework      = true
    
    s.source_files          = 'Skima/**/*.{h,swift}'
  
    s.dependency 'PureLayout', '3.1.9'
    s.dependency 'Alamofire'
    s.dependency 'NanoID'
  
  end
  