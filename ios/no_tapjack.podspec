Pod::Spec.new do |s|
  s.name             = 'no_tapjack'
  s.version          = '0.1.0'
  s.summary          = 'Flutter plugin to detect tapjacking and overlay attacks.'
  s.description      = <<-DESC
Flutter plugin to detect tapjacking and overlay attacks. Monitors for malicious overlays and filters obscured touch events.
                       DESC
  s.homepage         = 'https://github.com/FlutterPlaza/no_tapjack'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'FlutterPlaza' => 'dev@flutterplaza.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version    = "5.0"
end
