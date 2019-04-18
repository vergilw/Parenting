source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

platform :ios, "10.0"

# ignore all warnings from all pods
inhibit_all_warnings!

use_frameworks!

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

end

flutter_application_path = '../inee_flutter/'
eval(File.read(File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')), binding)
