Pod::Spec.new do |s|
  s.name             = "MXChat"
  s.version          = "0.1.0"
  s.summary          = "just chat"

  s.homepage         = "https://github.com/longminxiang/MXChat"

  s.license          = 'MIT'
  s.author           = { "Eric Lung" => "longminxiang@163@gmail.com" }
  s.source           = { :git => "https://github.com/longminxiang/MXChat.git", :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.dependency 'SDWebImage', '~> 3.7.2'
  s.dependency 'DACircularProgress', '~> 2.3.1'
  s.dependency 'MBProgressHUD', '~> 0.9.1'
  s.dependency = 'EGOCache', :git => 'https://github.com/longminxiang/EGOCache.git'

  s.source_files = 'MXChatView/**/*.{h,m}'
  s.public_header_files = 'MXChatView/**/*.h'
  s.resource = 'MXChatView/MXChat.bundle'

end