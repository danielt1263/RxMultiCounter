
platform :ios, '15.6'

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
      installer.generated_projects.each do |project|
        project.targets.each do |target|
          target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
          end
        end
      end
    end
  end
end
