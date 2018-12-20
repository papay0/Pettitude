# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'Pettitude' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for Pettitude
  pod 'RIBs', '~> 0.9.0'
  pod 'SnapKit', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  pod 'Firebase/Core'
  pod 'Firebase/MLVision'
  pod 'Firebase/MLVisionLabelModel'
  pod 'SwiftLint'
  pod 'BulletinBoard'

  target 'PettitudeTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Firebase'
  end

  target 'PettitudeUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end
