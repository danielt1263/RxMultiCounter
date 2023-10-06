
platform :ios, '13.3'

target 'RxMultiCounter' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'Cause-Logic-Effect'
	pod 'Curry'
  pod 'RxCocoa'
	pod 'RxDataSources'
	pod 'RxEnumKit'
  pod 'RxSwift'

  target 'RxMultiCounterTests' do
    inherit! :search_paths
    pod 'RxTest'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if target.name == 'RxSwift' and config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
      end
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.3'
      end
    end
  end
end
