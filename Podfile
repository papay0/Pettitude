# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

def common_pods
  # Pods for Pettitude
  pod 'RIBs', '~> 0.9.0'
  pod 'SnapKit', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  pod 'Firebase/Core'
  pod 'Firebase/Functions'
  pod 'Firebase/MLVision'
  pod 'Firebase/MLVisionLabelModel'
  pod 'SwiftLint'
  pod 'BulletinBoard'
  pod 'Fabric', '~> 1.9.0'
  pod 'Crashlytics', '~> 3.12.0'
  pod 'Firebase/Performance'
  pod 'Firebase/Auth'
  pod 'RevealingSplashView'
  pod 'Firebase/RemoteConfig'
  pod 'SwiftEntryKit', '0.8.6'
  pod 'Device.swift'
end

target 'Pettitude' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  common_pods

  target 'PettitudeTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Firebase'
  end

  target 'PettitudeUITests' do
    inherit! :search_paths
    # Pods for testing
    common_pods
  end
end
