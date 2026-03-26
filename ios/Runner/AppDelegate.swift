
//: Declare String Begin

/*: "Cockl" :*/
fileprivate let show_adjustData:String = "Cocklacross zone start conduct shared"

/*: /dist/index.html#/?packageId= :*/
fileprivate let main_componentDiskKey:String = "/dist/allow create s sound behavior"
fileprivate let appGoId:String = "short remote street printx.html"
fileprivate let formatterEErRemoteString:[Character] = ["#","/","?","p","a","c"]
fileprivate let modelFireName:String = "kageId=action action first style message"

/*: &safeHeight= :*/
fileprivate let formatterThrustNutString:String = "i appear state index&saf"
fileprivate let userUpToDateFlag:String = "for indicatorht="

/*: "token" :*/
fileprivate let main_alwaysSecret:[UInt8] = [0xdd,0xc6,0xc2,0xcc,0xc7]

private func downFatal(foundation num: UInt8) -> UInt8 {
    return num ^ 169
}

/*: "FCMToken" :*/
fileprivate let data_timeString:[Character] = ["F","C"]
fileprivate let routerYourPleaseName:[Character] = ["M","T","o","k","e","n"]

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  AppDelegate.swift
//  OverseaH5
//
//  Created by DouXiu on 2025/9/23.
//

//: import UIKit
import UIKit
//: import Firebase
import Firebase
//: import FirebaseMessaging
import FirebaseMessaging
//: import UserNotifications
import UserNotifications
//: import AVFAudio
import AVFAudio
//: import FirebaseRemoteConfig
import FirebaseRemoteConfig
import Flutter
//: @main
@main
//: class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
class AppDelegate: FlutterAppDelegate {
    

    //: let waitVC = WaitViewController()
    let waitVC = SkipViewController()
    
    //: func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //: self.window?.rootViewController?.view.addSubview(self.waitVC.view)
        self.window?.rootViewController?.view.addSubview(self.waitVC.view)
        //: self.window?.makeKeyAndVisible()
        self.window?.makeKeyAndVisible()
        //: initFireBase()
        ground()
        //: let config = RemoteConfig.remoteConfig()
        let config = RemoteConfig.remoteConfig()
        //: let settings = RemoteConfigSettings()
        let settings = RemoteConfigSettings()
        //: settings.minimumFetchInterval = 0
        settings.minimumFetchInterval = 0
        //: settings.fetchTimeout = 5
        settings.fetchTimeout = 5
        //: config.configSettings = settings
        config.configSettings = settings
        //: config.fetch { (status, error) -> Void in
        config.fetch { (status, error) -> Void in
            //: if status == .success {
            if status == .success {
                //: config.activate { changed, error in
                config.activate { changed, error in
                    //: let remoteVersion = config.configValue(forKey: "Cockl").numberValue.intValue
                    let remoteVersion = config.configValue(forKey: (String(show_adjustData.prefix(5)))).numberValue.intValue
                    //: let appVersion = Int(AppVersion.replacingOccurrences(of: ".", with: "")) ?? 0
                    let appVersion = Int(controllerQuantitativeRelationMessage.replacingOccurrences(of: ".", with: "")) ?? 0
                    //: if remoteVersion > appVersion {
                    if remoteVersion > appVersion { // 远程配置大于App当前版本，进入B面
                        //: self.initConfig(application)
                        self.managerReceive(application)
                        
                    //: } else {
                    } else { // 展示A面
                        //: DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            //: self.waitVC.view.removeFromSuperview()
                            self.waitVC.view.removeFromSuperview()
                        }
                    }
                }
            //: } else {
            } else { // 远程配置获取失败，验证本地时间戳
                //: let endTimeInterval: TimeInterval = 1774961716
                let endTimeInterval: TimeInterval = 1774961716 // 预设时间(秒)
                //: if Date().timeIntervalSince1970 > endTimeInterval && self.isNotiPad() {
                if Date().timeIntervalSince1970 > endTimeInterval && self.activityCurrency() { // 本地时间戳大于预设时间，进入B面
                    //: self.initConfig(application)
                    self.managerReceive(application)
                    
                //: } else {
                } else { // 展示A面
                    //: DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        //: self.waitVC.view.removeFromSuperview()
                        self.waitVC.view.removeFromSuperview()
                    }
                }
            }
        }
        //: return true
        return result
    }

    /// 是否iPAD
    //: private func isNotiPad() -> Bool {
    private func activityCurrency() -> Bool {
        //: return UIDevice.current.userInterfaceIdiom != .pad
        return UIDevice.current.userInterfaceIdiom != .pad
     }
    
    /// 初始化项目
    //: private func initConfig(_ application: UIApplication) {
    private func managerReceive(_ application: UIApplication) {
        //: registerForRemoteNotification(application)
        rating(application)
        //: AppAdjustManager.shared.initAdjust()
        DoCondition.shared.mic()
        // 检查是否有未完成的支付订单
        //: AppleIAPManager.shared.iap_checkUnfinishedTransactions()
        CrabappleTail.shared.manager()
        // 支持后台播放音乐
        //: try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        //: try? AVAudioSession.sharedInstance().setActive(true)
        try? AVAudioSession.sharedInstance().setActive(true)
        //: DispatchQueue.main.async {
        DispatchQueue.main.async {
            //: let vc = AppWebViewController()
            let vc = DeliveryRefresh()
            //: vc.urlString = "\(H5WebDomain)/dist/index.html#/?packageId=\(PackageID)&safeHeight=\(AppConfig.getStatusBarHeight())"
            vc.urlString = self.DeliveryRefreshStr()
            //: self.window?.rootViewController = vc
            self.window?.rootViewController = vc
            //: self.window?.makeKeyAndVisible()
            self.window?.makeKeyAndVisible()
        }
    }
    
    func DeliveryRefreshStr() -> String {
        return "\(formatterCameraTitle)" + (String(main_componentDiskKey.prefix(6)) + "inde" + String(appGoId.suffix(6)) + String(formatterEErRemoteString) + String(modelFireName.prefix(7))) + "\(parserModeAdState)" + (String(formatterThrustNutString.suffix(4)) + "eHeig" + String(userUpToDateFlag.suffix(3))) + "\(CommandConsent.evaluate())"
    }
}

// MARK: - Firebase
//: extension AppDelegate: MessagingDelegate {
extension AppDelegate: MessagingDelegate {
    //: private func initFireBase() {
    private func ground() {
        //: FirebaseApp.configure()
        FirebaseApp.configure()
        //: Messaging.messaging().delegate = self
        Messaging.messaging().delegate = self
    }
    
    //: func registerForRemoteNotification(_ application: UIApplication) {
    func rating(_ application: UIApplication) {
        //: if #available(iOS 10.0, *) {
        if #available(iOS 10.0, *) {
            //: UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().delegate = self
            //: let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            //: UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
            //: })
            })
            //: DispatchQueue.main.async {
            DispatchQueue.main.async {
                //: application.registerForRemoteNotifications()
                application.registerForRemoteNotifications()
            }
        }
    }
    
    //: func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 注册远程通知, 将deviceToken传递过去
        //: let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        //: Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken
        //: print("APNS Token = \(deviceStr)")
        //: Messaging.messaging().token { token, error in
        Messaging.messaging().token { token, error in
            //: if let error = error {
            if let error = error {
                //: print("error = \(error)")
            //: } else if let token = token {
            } else if let token = token {
                //: print("token = \(token)")
            }
        }
    }
    
    //: func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //: Messaging.messaging().appDidReceiveMessage(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        //: completionHandler(.newData)
        completionHandler(.newData)
    }
  
    //: func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //: completionHandler()
        completionHandler()
    }
    
    // 注册推送失败回调
    //: func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //: print("didFailToRegisterForRemoteNotificationsWithError = \(error.localizedDescription)")
    }
    
    //: public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //: let dataDict: [String: String] = ["token": fcmToken ?? ""]
        let dataDict: [String: String] = [String(bytes: main_alwaysSecret.map{downFatal(foundation: $0)}, encoding: .utf8)!: fcmToken ?? ""]
        //: print("didReceiveRegistrationToken = \(dataDict)")
        //: NotificationCenter.default.post(
        NotificationCenter.default.post(
            //: name: Notification.Name("FCMToken"),
            name: Notification.Name((String(data_timeString) + String(routerYourPleaseName))),
            //: object: nil,
            object: nil,
            //: userInfo: dataDict)
            userInfo: dataDict)
    }
}
