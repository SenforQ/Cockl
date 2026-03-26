
//: Declare String Begin

/*: "USD" :*/
fileprivate let mainSpaceKey:String = "USdisable"

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  DoCondition.swift
//  OverseaH5
//
//  Created by young on 2025/9/24.
//

//: import Adjust
import Adjust


//: class AppAdjustManager: NSObject {
class DoCondition: NSObject {
    //: static let shared = AppAdjustManager()
    static let shared = DoCondition()
    
    /// 初始化Adjust
    //: func initAdjust() {
    func mic() {
        //: let environment = ADJEnvironmentProduction
        let environment = ADJEnvironmentProduction
        //: let adjustConfig = ADJConfig(appToken: AdjustKey, environment: environment)
        let adjustConfig = ADJConfig(appToken: main_versionMessage, environment: environment)
        //: adjustConfig?.logLevel = ADJLogLevelWarn
        adjustConfig?.logLevel = ADJLogLevelWarn
        //: adjustConfig?.delegate = self
        adjustConfig?.delegate = self
        //: Adjust.appDidLaunch(adjustConfig)
        Adjust.appDidLaunch(adjustConfig)
        //: AppAdjustManager.addOnceEvent(token: AdInstallToken)
        DoCondition.contentDoingeTime(token: factoryPackageAppStatus)
    }
}

// MARK: - Event
//: extension AppAdjustManager: AdjustDelegate {
extension DoCondition: AdjustDelegate {
    /// 获取设备id
    //: class func getAdjustAdid() -> String {
    class func extract() -> String {
        //: let adid = Adjust.adid() ?? ""
        let adid = Adjust.adid() ?? ""
        //: return adid
        return adid
    }
    
    /// 添加去重事件【只记录一次】
    /// - Parameter key: 事件名
    //: class func addOnceEvent(token: String) {
    class func contentDoingeTime(token: String) {
        //: let event = ADJEvent(eventToken: token)
        let event = ADJEvent(eventToken: token)
        //: event?.setTransactionId(token)
        event?.setTransactionId(token)
        //: Adjust.trackEvent(event)
        Adjust.trackEvent(event)
    }

    /// 添加 内购/订阅 埋点事件
    /// - Parameters:
    ///   - token: token
    ///   - count: 价格
    //: class func addPurchasedEvent(token: String, count: Double) {
    class func observer(token: String, count: Double) {
        //: let event = ADJEvent(eventToken: token)
        let event = ADJEvent(eventToken: token)
        //: event?.setRevenue(count, currency: "USD")
        event?.setRevenue(count, currency: (mainSpaceKey.replacingOccurrences(of: "disable", with: "D")))
        //: Adjust.trackEvent(event)
        Adjust.trackEvent(event)
    }

    /// 添加埋点事件
    /// - Parameter key: 事件名
    //: class func addEvent(token: String) {
    class func object(token: String) {
        //: let event = ADJEvent(eventToken: token)
        let event = ADJEvent(eventToken: token)
        //: Adjust.trackEvent(event)
        Adjust.trackEvent(event)
    }
}