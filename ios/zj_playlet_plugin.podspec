#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint zj_playlet_plugin.podspec` to validate before publishing.
#

Pod::Spec.new do |s|
  s.name             = 'zj_playlet_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/hzzhongjian/zj_playlet_flutter.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'hzzhongjian' => 'opentwo@hzzhongjian.cn' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.static_framework = true
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'}

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'zj_playlet_plugin_privacy' => ['Resources/PrivacyInfo.xcprivacy']}

  # 再使用pod导入依赖库
  # s.dependency 'Ads-CN/BUAdSDK', '6.8.1.3'
  s.dependency 'TTSDKFramework/Player-SR', '1.42.3.4-premium'
  s.dependency 'PangrowthX/shortplay', '2.8.0.0'
  # 需要导入以下两个适配器
  # s.dependency 'ZJSDK/ZJSDKModuleCSJCompatible'
  s.dependency 'ZJSDK/ZJSDKModuleCSJPlayletSDK'

end
