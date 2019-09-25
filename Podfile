source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

platform :ios, "10.0"

# ignore all warnings from all pods
inhibit_all_warnings!

use_frameworks!

flutter_application_path = '../inee_flutter/'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target "parenting" do

    #pod 'RealmSwift'            
    pod 'Alamofire'
    pod 'SnapKit'
    pod 'IQKeyboardManagerSwift'
    pod 'Moya'
    pod 'HandyJSON',:git => 'https://github.com/alibaba/HandyJSON.git', :branch => 'dev_for_swift5.0'
    pod 'Kingfisher'
    pod 'UINavigationItem+Margin'
    pod 'Presentr'
    pod 'MLeaksFinder'

    pod 'YYKit'
    pod 'MJRefresh'
    pod 'UITableView+FDTemplateLayoutCell'
    pod 'UITextView+Placeholder'
    pod 'TYCyclePagerView'
    pod 'MBProgressHUD'
    
    pod 'GTSDK'
    pod 'Bugly' 
    pod 'UMCCommon'
    pod 'UMCSecurityPlugins'
    pod 'UMCShare/Social/ReducedWeChat'
    pod 'PLShortVideoKit'
    pod 'Qiniu'
    pod 'PLPlayerKit'

    install_all_flutter_pods(flutter_application_path)
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['ENABLE_BITCODE'] = 'NO'
            end
        end
    end
end


