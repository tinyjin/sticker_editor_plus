#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint stickereditor.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sticker_editor_plus'
  s.version          = '1.0.0'
  s.summary          = 'A new Sticker plugin'
  s.description      = <<-DESC
A new Sticker plugin
                       DESC
  s.homepage         = 'https://pub.dev/packages/sticker_editor_plus'
  s.license          = { :file => '../LICENSE' }
  s.author           = {
    'Harsh Radadiya' => '',
    'Jinny You' => 'baram991103@gmail.com'
  }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
