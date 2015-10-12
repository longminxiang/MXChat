Pod::Spec.new do |s|
  s.name             = "MXChat"
  s.version          = "0.2.0"
  s.summary          = "just chat"

  s.homepage         = "https://github.com/longminxiang/MXChat"

  s.license          = 'MIT'
  s.author           = { "Eric Lung" => "longminxiang@gmail.com" }
  s.source           = { :git => "https://github.com/longminxiang/MXChat.git", :tag => "v" + s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.dependency 'SDWebImage/Core', '3.7.3'
  s.dependency 'DACircularProgress', '2.3.1'
  s.dependency 'MBProgressHUD', '0.9.1'
  s.dependency 'MXEGOCache', '2.1.4'
  s.dependency 'DTCoreText', '1.6.16'

  s.vendored_frameworks = 'MXChatView/Vendor/lame.framework'

  s.source_files = 'MXChatView/MXChatView/**/*.{h,m}'
  s.resources = ['MXChatView/MXChatView/**/*.xib', 'MXChatView/MXChatView/Resources/**/*.bundle', 'MXChatView/MXChatView/Resources/Face/*.png']

end