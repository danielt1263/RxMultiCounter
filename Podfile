
platform :ios, '13.3'

target 'RxMultiCounter' do
  # Comment the next line if you don't want to use dynamic frameworks
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
        end
    end
end
