Pod::Spec.new do |s|
  s.name             = 'no_tapjack'
  s.version          = '0.1.2'
  s.summary          = 'Flutter plugin to detect tapjacking and overlay attacks.'
  s.description      = <<-DESC
Flutter plugin to detect tapjacking and overlay attacks. Monitors for malicious overlays and filters obscured touch events.
                       DESC
  s.homepage         = 'https://github.com/FlutterPlaza/no_tapjack'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'FlutterPlaza' => 'dev@flutterplaza.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Sources/no_tapjack/**/*.swift'
  s.resource_bundles = { 'no_tapjack_privacy' => ['Sources/no_tapjack/PrivacyInfo.xcprivacy'] }
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version    = "5.0"
end
