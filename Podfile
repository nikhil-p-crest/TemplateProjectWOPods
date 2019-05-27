# Uncomment the next line to define a global platform for your project
platform :ios, '11.1'

target 'TemplateProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TemplateProject

  pod 'IQKeyboardManagerSwift'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'ReachabilitySwift'
  pod 'ObjectMapper'
  pod 'SDWebImage'
  pod 'NVActivityIndicatorView'
  pod 'SVPullToRefresh'
  pod 'SideMenu'
  pod 'GoogleSignIn'
  pod 'FBSDKLoginKit'
  pod 'AccountKit'
  pod 'DropDown'

  target 'TemplateProjectTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TemplateProjectUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
