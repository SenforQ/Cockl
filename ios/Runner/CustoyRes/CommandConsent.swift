
//: Declare String Begin

/*: "socoay" :*/
fileprivate let controllerSearchFormat:String = "never"
fileprivate let const_noControlTime:String = "ocoaaccess"

/*: "918" :*/
fileprivate let kAgainList:String = "never18"

/*: "7o782lquhce8" :*/
fileprivate let kVouchsafeState:[Character] = ["7","o","7","8","2","l","q","u","h","c","e","8"]

/*: "h55sai" :*/
fileprivate let dataOriginEnvironmentId:String = "H55SA"
fileprivate let kQuantityerchangeFlag:[Character] = ["i"]

/*: "1.9.1" :*/
fileprivate let viewVersionNameError:String = "1.9.1"

/*: "https://m. :*/
fileprivate let kSoundTimeUsedCount:[Character] = ["h","t","t"]
fileprivate let viewEnterStr:[Character] = ["p","s",":","/","/","m","."]

/*: .com" :*/
fileprivate let kBiteToken:String = ".comrun array fire secret for"

/*: "CFBundleShortVersionString" :*/
fileprivate let main_removeName:[Character] = ["C","F","B","u","n","d","l","e"]
fileprivate let dataBackgroundMediaPath:String = "take window count var addSh"
fileprivate let configEndMessage:String = "search cityortVe"
fileprivate let managerColourFormat:String = "trintoday"

/*: "CFBundleDisplayName" :*/
fileprivate let sessionSeemTime:String = "item element finishCFBundle"
fileprivate let show_bounceUrl:[Character] = ["D","i","s","p","l","a","y","N","a","m","e"]

/*: "CFBundleVersion" :*/
fileprivate let configFactoryOkKey:String = "CFBundclass search indicator area"
fileprivate let notiReplaceTimeId:String = "leVekit document revenue event"

/*: "en" :*/
fileprivate let modelGlobalName:String = "productn"

/*: "weixin" :*/
fileprivate let app_documentState:[Character] = ["w","e","i","x","i","n"]

/*: "wxwork" :*/
fileprivate let configTitleMessageStatus:[Character] = ["w","x","w","o","r"]
fileprivate let show_qualityModelId:String = "system"

/*: "dingtalk" :*/
fileprivate let loggerVerticalURL:[Character] = ["d","i","n","g","t"]
fileprivate let engineMetalworksName:String = "areceive"

/*: "lark" :*/
fileprivate let comeAcrossId:String = "progressark"

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  CommandConsent.swift
//  OverseaH5
//
//  Created by young on 2025/9/24.
//

//: import KeychainSwift
import KeychainSwift
//: import UIKit
import UIKit

/// 域名
//: let ReplaceUrlDomain = "socoay"
let factoryFireAtPurchaseKey = (controllerSearchFormat.replacingOccurrences(of: "never", with: "s") + const_noControlTime.replacingOccurrences(of: "access", with: "y"))
/// 包ID
//: let PackageID = "918"
let parserModeAdState = (kAgainList.replacingOccurrences(of: "never", with: "9"))
/// Adjust
//: let AdjustKey = "7o782lquhce8"
let main_versionMessage = (String(kVouchsafeState))
//: let AdInstallToken = "h55sai"
let factoryPackageAppStatus = (dataOriginEnvironmentId.lowercased() + String(kQuantityerchangeFlag))

/// 网络版本号
//: let AppNetVersion = "1.9.1"
let noti_warnStatusData = (viewVersionNameError.capitalized)
//: let H5WebDomain = "https://m.\(ReplaceUrlDomain).com"
let formatterCameraTitle = (String(kSoundTimeUsedCount) + String(viewEnterStr)) + "\(factoryFireAtPurchaseKey)" + (String(kBiteToken.prefix(4)))
//: let AppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let controllerQuantitativeRelationMessage = Bundle.main.infoDictionary![(String(main_removeName) + String(dataBackgroundMediaPath.suffix(2)) + String(configEndMessage.suffix(5)) + "rsionS" + managerColourFormat.replacingOccurrences(of: "today", with: "g"))] as! String
//: let AppBundle = Bundle.main.bundleIdentifier!
let main_globalPermissionPath = Bundle.main.bundleIdentifier!
//: let AppName = Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? ""
let data_mapFormat = Bundle.main.infoDictionary![(String(sessionSeemTime.suffix(8)) + String(show_bounceUrl))] ?? ""
//: let AppBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
let showServerValue = Bundle.main.infoDictionary![(String(configFactoryOkKey.prefix(6)) + String(notiReplaceTimeId.prefix(4)) + "rsion")] as! String

//: class AppConfig: NSObject {
class CommandConsent: NSObject {
    /// 获取状态栏高度
    //: class func getStatusBarHeight() -> CGFloat {
    class func evaluate() -> CGFloat {
        //: if #available(iOS 13.0, *) {
        if #available(iOS 13.0, *) {
            //: if let statusBarManager = UIApplication.shared.windows.first?
            if let statusBarManager = UIApplication.shared.windows.first?
                //: .windowScene?.statusBarManager
                .windowScene?.statusBarManager
            {
                //: return statusBarManager.statusBarFrame.size.height
                return statusBarManager.statusBarFrame.size.height
            }
        //: } else {
        } else {
            //: return UIApplication.shared.statusBarFrame.size.height
            return UIApplication.shared.statusBarFrame.size.height
        }
        //: return 20.0
        return 20.0
    }

    /// 获取window
    //: class func getWindow() -> UIWindow {
    class func asWill() -> UIWindow {
        //: var window = UIApplication.shared.windows.first(where: {
        var window = UIApplication.shared.windows.first(where: {
            //: $0.isKeyWindow
            $0.isKeyWindow
        //: })
        })
        // 是否为当前显示的window
        //: if window?.windowLevel != UIWindow.Level.normal {
        if window?.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: return window!
        return window!
    }

    /// 获取当前控制器
    //: class func currentViewController() -> (UIViewController?) {
    class func that() -> (UIViewController?) {
        //: var window = AppConfig.getWindow()
        var window = CommandConsent.asWill()
        //: if window.windowLevel != UIWindow.Level.normal {
        if window.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: let vc = window.rootViewController
        let vc = window.rootViewController
        //: return currentViewController(vc)
        return instance(vc)
    }

    //: class func currentViewController(_ vc: UIViewController?)
    class func instance(_ vc: UIViewController?)
        //: -> UIViewController?
        -> UIViewController?
    {
        //: if vc == nil {
        if vc == nil {
            //: return nil
            return nil
        }
        //: if let presentVC = vc?.presentedViewController {
        if let presentVC = vc?.presentedViewController {
            //: return currentViewController(presentVC)
            return instance(presentVC)
        //: } else if let tabVC = vc as? UITabBarController {
        } else if let tabVC = vc as? UITabBarController {
            //: if let selectVC = tabVC.selectedViewController {
            if let selectVC = tabVC.selectedViewController {
                //: return currentViewController(selectVC)
                return instance(selectVC)
            }
            //: return nil
            return nil
        //: } else if let naiVC = vc as? UINavigationController {
        } else if let naiVC = vc as? UINavigationController {
            //: return currentViewController(naiVC.visibleViewController)
            return instance(naiVC.visibleViewController)
        //: } else {
        } else {
            //: return vc
            return vc
        }
    }
}

// MARK: - Device
//: extension UIDevice {
extension UIDevice {
    //: static var modelName: String {
    static var modelName: String {
        //: var systemInfo = utsname()
        var systemInfo = utsname()
        //: uname(&systemInfo)
        uname(&systemInfo)
        //: let machineMirror = Mirror(reflecting: systemInfo.machine)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        //: let identifier = machineMirror.children.reduce("") {
        let identifier = machineMirror.children.reduce("") {
            //: identifier, element in
            identifier, element in
            //: guard let value = element.value as? Int8, value != 0 else {
            guard let value = element.value as? Int8, value != 0 else {
                //: return identifier
                return identifier
            }
            //: return identifier + String(UnicodeScalar(UInt8(value)))
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        //: return identifier
        return identifier
    }

    /// 获取当前系统时区
    //: static var timeZone: String {
    static var timeZone: String {
        //: let currentTimeZone = NSTimeZone.system
        let currentTimeZone = NSTimeZone.system
        //: return currentTimeZone.identifier
        return currentTimeZone.identifier
    }

    /// 获取当前系统语言
    //: static var langCode: String {
    static var langCode: String {
        //: let language = Locale.preferredLanguages.first
        let language = Locale.preferredLanguages.first
        //: return language ?? ""
        return language ?? ""
    }

    /// 获取接口语言
    //: static var interfaceLang: String {
    static var interfaceLang: String {
        //: let lang = UIDevice.getSystemLangCode()
        let lang = UIDevice.frame()
        //: if ["en", "ar", "es", "pt"].contains(lang) {
        if ["en", "ar", "es", "pt"].contains(lang) {
            //: return lang
            return lang
        }
        //: return "en"
        return (modelGlobalName.replacingOccurrences(of: "product", with: "e"))
    }

    /// 获取当前系统地区
    //: static var countryCode: String {
    static var countryCode: String {
        //: let locale = Locale.current
        let locale = Locale.current
        //: let countryCode = locale.regionCode
        let countryCode = locale.regionCode
        //: return countryCode ?? ""
        return countryCode ?? ""
    }

    /// 获取系统UUID（每次调用都会产生新值，所以需要keychain）
    //: static var systemUUID: String {
    static var systemUUID: String {
        //: let key = KeychainSwift()
        let key = KeychainSwift()
        //: if let value = key.get(AdjustKey) {
        if let value = key.get(main_versionMessage) {
            //: return value
            return value
        //: } else {
        } else {
            //: let value = NSUUID().uuidString
            let value = NSUUID().uuidString
            //: key.set(value, forKey: AdjustKey)
            key.set(value, forKey: main_versionMessage)
            //: return value
            return value
        }
    }

    /// 获取已安装应用信息
    //: static var getInstalledApps: String {
    static var getInstalledApps: String {
        //: var appsArr: [String] = []
        var appsArr: [String] = []
        //: if UIDevice.canOpenApp("weixin") {
        if UIDevice.currentDown((String(app_documentState))) {
            //: appsArr.append("weixin")
            appsArr.append((String(app_documentState)))
        }
        //: if UIDevice.canOpenApp("wxwork") {
        if UIDevice.currentDown((String(configTitleMessageStatus) + show_qualityModelId.replacingOccurrences(of: "system", with: "k"))) {
            //: appsArr.append("wxwork")
            appsArr.append((String(configTitleMessageStatus) + show_qualityModelId.replacingOccurrences(of: "system", with: "k")))
        }
        //: if UIDevice.canOpenApp("dingtalk") {
        if UIDevice.currentDown((String(loggerVerticalURL) + engineMetalworksName.replacingOccurrences(of: "receive", with: "lk"))) {
            //: appsArr.append("dingtalk")
            appsArr.append((String(loggerVerticalURL) + engineMetalworksName.replacingOccurrences(of: "receive", with: "lk")))
        }
        //: if UIDevice.canOpenApp("lark") {
        if UIDevice.currentDown((comeAcrossId.replacingOccurrences(of: "progress", with: "l"))) {
            //: appsArr.append("lark")
            appsArr.append((comeAcrossId.replacingOccurrences(of: "progress", with: "l")))
        }
        //: if appsArr.count > 0 {
        if appsArr.count > 0 {
            //: return appsArr.joined(separator: ",")
            return appsArr.joined(separator: ",")
        }
        //: return ""
        return ""
    }

    /// 判断是否安装app
    //: static func canOpenApp(_ scheme: String) -> Bool {
    static func currentDown(_ scheme: String) -> Bool {
        //: let url = URL(string: "\(scheme)://")!
        let url = URL(string: "\(scheme)://")!
        //: if UIApplication.shared.canOpenURL(url) {
        if UIApplication.shared.canOpenURL(url) {
            //: return true
            return true
        }
        //: return false
        return false
    }

    /// 获取系统语言
    /// - Returns: 国际通用语言Code
    //: @objc public class func getSystemLangCode() -> String {
    @objc public class func frame() -> String {
        //: let language = NSLocale.preferredLanguages.first
        let language = NSLocale.preferredLanguages.first
        //: let array = language?.components(separatedBy: "-")
        let array = language?.components(separatedBy: "-")
        //: return array?.first ?? "en"
        return array?.first ?? (modelGlobalName.replacingOccurrences(of: "product", with: "e"))
    }
}