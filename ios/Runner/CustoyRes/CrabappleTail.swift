
//: Declare String Begin

/*: "mf/recharge/createApplePay" :*/
fileprivate let loggerEveryLastToken:[Character] = ["m","f"]
fileprivate let const_instanceTime:String = "/recclear secret bounce origin"
fileprivate let configNoCurrencyDate:String = "/creattrust factory name"

/*: "productId" :*/
fileprivate let factoryLifestyleBringError:String = "systemodu"
fileprivate let dataFullToken:String = "response windowctId"

/*: "source" :*/
fileprivate let user_serverBlackKey:[Character] = ["s"]
fileprivate let formatterBounceData:String = "ourscripte"

/*: "orderNum" :*/
fileprivate let k_logID:[Character] = ["o","r","d","e","r","N","u","m"]

/*: "mf/recharge/applePayNotify" :*/
fileprivate let app_dateAgentToken:String = "mf/recwindow post tag now body"
fileprivate let managerViewToken:String = "ascalescalele"
fileprivate let show_secondURL:[Character] = ["y"]

/*: "reportMoney" :*/
fileprivate let kActivityValue:String = "REP"
fileprivate let modelCoreMessage:[Character] = ["o","r","t","M","o","n","e","y"]

/*: "transactionId" :*/
fileprivate let networkWithFormat:[Character] = ["t","r","a","n"]
fileprivate let notiTransformToken:String = "sactionIdprogress content adjustment"

/*: "mf/AutoSub/AppleCreateOrder" :*/
fileprivate let data_progressCaptureName:[Character] = ["m","f","/","A","u","t","o","S","u","b","/","A","p","p","l"]
fileprivate let const_toMicMessage:[Character] = ["e","C","r","e","a","t","e","O","r","d","e","r"]

/*: "orderId" :*/
fileprivate let sessionProductionReduceDict:[UInt8] = [0xab,0xae,0xa0,0xa1,0xae,0x85,0xa0]

fileprivate func versionText(ad num: UInt8) -> UInt8 {
    let value = Int(num) - 60
    if value < 0 {
        return UInt8(value + 256)
    } else {
        return UInt8(value)
    }
}

/*: "mf/AutoSub/ApplePaySuccess" :*/
fileprivate let viewUsedTitle:String = "mf/Aubehavior script"
fileprivate let showClearToken:String = "local mediab/Appl"
fileprivate let k_productStr:String = "ucceobserver"

/*: "App" :*/
fileprivate let routerTabList:String = "Apptext can that to"

/*: "OrderTransactionInfo_Cache" :*/
fileprivate let kStreakData:String = "Ordebuild scene"
fileprivate let helperMapValue:String = "actimanager"
fileprivate let configLaunchToken:String = "data sizeo_Cache"

/*: "OrderTransactionInfo_Subscribe_Cache" :*/
fileprivate let k_poseDict:[UInt8] = [0x56,0x6b,0x7d,0x7c,0x6b,0x4d,0x6b,0x78,0x77,0x6a,0x78,0x7a,0x6d,0x70,0x76,0x77,0x50,0x77,0x7f,0x76,0x46,0x4a,0x6c,0x7b,0x6a,0x7a,0x6b,0x70,0x7b,0x7c,0x46,0x5a,0x78,0x7a,0x71,0x7c]

/*: "verifyData" :*/
fileprivate let showNetError:[UInt8] = [0xd6,0xc5,0xd2,0xc9,0xc6,0xd9,0xa4,0xc1,0xd4,0xc1]

fileprivate func fileThird(app num: UInt8) -> UInt8 {
    let value = Int(num) + 160
    if value > 255 {
        return UInt8(value - 256)
    } else {
        return UInt8(value)
    }
}

/*: " 未知的交易类型" :*/
fileprivate let helperAfterwardError:[Character] = [""," ","未","\u{77e5}","\u{7684}","交","\u{6613}"]
fileprivate let parserEliteResult:[Character] = ["类","\u{578b}"]

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//: import UIKit
import UIKit
//: import StoreKit
import StoreKit
 
// 最大失败重试次数
//: let APPLE_IAP_MAX_RETRY_COUNT = 9
let constPublicTransportValue = 9

/// 支付类型
//: enum ApplePayType {
enum AddressVariable {
    //: case Pay        
    case Pay        // 支付
    //: case Subscribe  
    case Subscribe  // 订阅
}
/// 支付状态
//: enum AppleIAPStatus: String {
enum InsincereStoneFruitSum: String {
    //: case unknow            = "未知类型"
    case unknow            = "未知类型"
    //: case createOrderFail   = "创建订单失败"
    case createOrderFail   = "创建订单失败"
    //: case notArrow          = "设备不允许"
    case notArrow          = "设备不允许"
    //: case noProductId       = "缺少产品Id"
    case noProductId       = "缺少产品Id"
    //: case failed            = "交易失败/取消"
    case failed            = "交易失败/取消"
    //: case restored          = "已购买过该商品"
    case restored          = "已购买过该商品"
    //: case deferred          = "交易延期"
    case deferred          = "交易延期"
    //: case verityFail        = "服务器验证失败"
    case verityFail        = "服务器验证失败"
    //: case veritySucceed     = "服务器验证成功"
    case veritySucceed     = "服务器验证成功"
    //: case renewSucceed      = "自动续订成功"
    case renewSucceed      = "自动续订成功"
}

//: typealias IAPcompletionHandle = (AppleIAPStatus, Double, ApplePayType) -> Void
typealias IAPcompletionHandle = (InsincereStoneFruitSum, Double, AddressVariable) -> Void

//: class AppleIAPManager: NSObject {
class CrabappleTail: NSObject {
    
    //: var completionHandle: IAPcompletionHandle?
    var completionHandle: IAPcompletionHandle?
    //: private var productInfoReq: SKProductsRequest?
    private var productInfoReq: SKProductsRequest?
    //: private var reqRetryCountDict = [String: Int]()         
    private var reqRetryCountDict = [String: Int]()         // 记录每个交易请求重试次数
    //: private var payCacheList = [[String: String]]()         
    private var payCacheList = [[String: String]]()         // 【购买】缓存数据
    //: private var subscribeCacheList = [[String: String]]()   
    private var subscribeCacheList = [[String: String]]()   // 【订阅】缓存数据
    //: private var createOrderId: String?                      
    private var createOrderId: String?                      // 当前支付服务端创建的订单id
    //: private var currentPayType: ApplePayType = .Pay         
    private var currentPayType: AddressVariable = .Pay         // 当前支付类型
    
    // singleton
    //: static let shared = AppleIAPManager()
    static let shared = CrabappleTail()
    //: override func copy() -> Any { return self }
    override func copy() -> Any { return self }
    //: override func mutableCopy() -> Any { return self }
    override func mutableCopy() -> Any { return self }
    //: private override init() {
    private override init() {
        //: super.init()
        super.init()
        //: SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
        SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
        // 监听应用将要销毁
        //: NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate),
        NotificationCenter.default.addObserver(self, selector: #selector(path),
                                               //: name: UIApplication.willTerminateNotification,
                                               name: UIApplication.willTerminateNotification,
                                               //: object: nil)
                                               object: nil)
    }

    // MARK: - NotificationCenter
    //: @objc func appWillTerminate() {
    @objc func path() {
        //: SKPaymentQueue.default().remove(self as SKPaymentTransactionObserver)
        SKPaymentQueue.default().remove(self as SKPaymentTransactionObserver)
    }
}

// MARK: - 【苹果购买】业务接口
//: extension AppleIAPManager {
extension CrabappleTail {
    /// 【购买】创建业务订单
    /// - Parameters:
    ///   - productId: 产品Id
    ///   - block: 回调
    //: fileprivate func req_pay_createAppleOrder(productId: String, source: Int, handle: @escaping (String?, Bool) -> Void) {
    fileprivate func magazine(productId: String, source: Int, handle: @escaping (String?, Bool) -> Void) {
        //: let reqModel = AppRequestModel.init()
        let reqModel = DeleteModel.init()
        //: reqModel.requestPath = "mf/recharge/createApplePay"
        reqModel.requestPath = (String(loggerEveryLastToken) + String(const_instanceTime.prefix(4)) + "harge" + String(configNoCurrencyDate.prefix(6)) + "eApplePay")
        //: var dict = Dictionary<String, Any>()
        var dict = Dictionary<String, Any>()
        //: dict["productId"] = productId
        dict[(factoryLifestyleBringError.replacingOccurrences(of: "system", with: "pr") + String(dataFullToken.suffix(4)))] = productId
        //: dict["source"] = source
        dict[(String(user_serverBlackKey) + formatterBounceData.replacingOccurrences(of: "script", with: "c"))] = source
        //: reqModel.params = dict
        reqModel.params = dict
        //: AppRequestTool.startPostRequest(model: reqModel) { succeed, result, errorModel in
        HostAdjust.offColor(model: reqModel) { succeed, result, errorModel in
            //: guard succeed == true else {
            guard succeed == true else {
                //: handle(nil, succeed)
                handle(nil, succeed)
                //: return
                return
            }

            //: var orderId: String?
            var orderId: String?
            //: let dict = result as? [String: Any]
            let dict = result as? [String: Any]
            //: if let value = dict?["orderNum"] as? String {
            if let value = dict?[(String(k_logID))] as? String {
                //: orderId = value
                orderId = value
            }
            //: handle(orderId, succeed)
            handle(orderId, succeed)
        }
    }
    
    /// 【购买】上传支付信息到服务器验证
    /// - Parameters:
    ///   - transaction: 交易信息
    ///   - params: 接口参数
    //: fileprivate func req_pay_uploadAppletransaction(_ transactionId: String, params: [String: String]) {
    fileprivate func confirm(_ transactionId: String, params: [String: String]) {
        //: let reqModel = AppRequestModel.init()
        let reqModel = DeleteModel.init()
        //: reqModel.requestPath = "mf/recharge/applePayNotify"
        reqModel.requestPath = (String(app_dateAgentToken.prefix(6)) + "harge/" + managerViewToken.replacingOccurrences(of: "scale", with: "p") + "PayNotif" + String(show_secondURL))
        //: reqModel.params = params
        reqModel.params = params
        //: AppRequestTool.startPostRequest(model: reqModel) { succeed, result, errorModel in
        HostAdjust.offColor(model: reqModel) { succeed, result, errorModel in
            //: guard succeed == true || errorModel?.errorCode == 405 else { 
            guard succeed == true || errorModel?.errorCode == 405 else { // 验证接口失败，重试接口
                //: DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    //: self.transcationPurchasedToCheck(transactionId, .Pay)
                    self.script(transactionId, .Pay)
                }
                //: return
                return
            }

            //: let dict = result as? [String: Any]
            let dict = result as? [String: Any]
            //: let reportMoney: Double = {
            let reportMoney: Double = {
                //: if let d = dict?["reportMoney"] as? Double { return d }
                if let d = dict?[(kActivityValue.lowercased() + String(modelCoreMessage))] as? Double { return d }
                //: return 0
                return 0
            //: }()
            }()
            
            // 过滤已验证成功的订单数据
            //: let newPayCacheList = self.payCacheList.filter({$0["transactionId"] != transactionId})
            let newPayCacheList = self.payCacheList.filter({$0[(String(networkWithFormat) + String(notiTransformToken.prefix(9)))] != transactionId})
            //: let diskPath = self.getPayCachePath()
            let diskPath = self.systemResponse()
            //: NSKeyedArchiver.archiveRootObject(newPayCacheList, toFile: diskPath)
            NSKeyedArchiver.archiveRootObject(newPayCacheList, toFile: diskPath)
                        
            // 成功回调
            //: self.completionHandle?(.veritySucceed, reportMoney, .Pay)
            self.completionHandle?(.veritySucceed, reportMoney, .Pay)
        }
    }
}

// MARK: - 【苹果订阅】业务接口
//: extension AppleIAPManager {
extension CrabappleTail {
    /// 【订阅】创建业务订单
    /// - Parameters:
    ///   - productId: 产品Id
    ///   - block: 回调
    //: fileprivate func req_subscribe_createAppleOrder(productId: String, source: Int, handle: @escaping (String?, Bool) -> Void) {
    fileprivate func conduct(productId: String, source: Int, handle: @escaping (String?, Bool) -> Void) {
        //: let reqModel = AppRequestModel.init()
        let reqModel = DeleteModel.init()
        //: reqModel.requestPath = "mf/AutoSub/AppleCreateOrder"
        reqModel.requestPath = (String(data_progressCaptureName) + String(const_toMicMessage))
        //: var dict = Dictionary<String, Any>()
        var dict = Dictionary<String, Any>()
        //: dict["productId"] = productId
        dict[(factoryLifestyleBringError.replacingOccurrences(of: "system", with: "pr") + String(dataFullToken.suffix(4)))] = productId
        //: dict["source"] = source
        dict[(String(user_serverBlackKey) + formatterBounceData.replacingOccurrences(of: "script", with: "c"))] = source
        //: reqModel.params = dict
        reqModel.params = dict
        //: AppRequestTool.startPostRequest(model: reqModel) { succeed, result, errorModel in
        HostAdjust.offColor(model: reqModel) { succeed, result, errorModel in
            //: guard succeed == true else {
            guard succeed == true else {
                //: handle(nil, succeed)
                handle(nil, succeed)
                //: return
                return
            }

            //: var orderId: String? = nil
            var orderId: String? = nil
            //: let dict = result as? [String: Any]
            let dict = result as? [String: Any]
            //: if let value = dict?["orderId"] as? String {
            if let value = dict?[String(bytes: sessionProductionReduceDict.map{versionText(ad: $0)}, encoding: .utf8)!] as? String {
                //: orderId = value
                orderId = value
            }
            //: handle(orderId, succeed)
            handle(orderId, succeed)
        }
    }
    
    /// 【订阅】上传支付信息到服务器验证
    /// - Parameters:
    ///   - transaction: 交易信息
    ///   - params: 接口参数
    //: fileprivate func req_subscribe_uploadAppletransaction(_ transactionId: String, params: [String: String]) {
    fileprivate func enableceRange(_ transactionId: String, params: [String: String]) {
        //: let reqModel = AppRequestModel.init()
        let reqModel = DeleteModel.init()
        //: reqModel.requestPath = "mf/AutoSub/ApplePaySuccess"
        reqModel.requestPath = (String(viewUsedTitle.prefix(5)) + "toSu" + String(showClearToken.suffix(6)) + "ePayS" + k_productStr.replacingOccurrences(of: "observer", with: "ss"))
        //: reqModel.params = params
        reqModel.params = params
        //: AppRequestTool.startPostRequest(model: reqModel) { succeed, result, errorModel in
        HostAdjust.offColor(model: reqModel) { succeed, result, errorModel in
            //: guard succeed == true || errorModel?.errorCode == 405 else { 
            guard succeed == true || errorModel?.errorCode == 405 else { // 验证接口失败，重试接口
                //: DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    //: self.transcationPurchasedToCheck(transactionId, .Subscribe)
                    self.script(transactionId, .Subscribe)
                }
                //: return
                return
            }

            //: let dict = result as? [String: Any]
            let dict = result as? [String: Any]
            //: let reportMoney: Double = {
            let reportMoney: Double = {
                //: if let d = dict?["reportMoney"] as? Double { return d }
                if let d = dict?[(kActivityValue.lowercased() + String(modelCoreMessage))] as? Double { return d }
                //: return 0
                return 0
            //: }()
            }()

            // 过滤已验证成功的订单数据
            //: let newSubscribeCacheList = self.subscribeCacheList.filter({$0["transactionId"] != transactionId})
            let newSubscribeCacheList = self.subscribeCacheList.filter({$0[(String(networkWithFormat) + String(notiTransformToken.prefix(9)))] != transactionId})
            //: let diskPath = self.getSubscribeCachePath()
            let diskPath = self.dismiss()
            //: NSKeyedArchiver.archiveRootObject(newSubscribeCacheList, toFile: diskPath)
            NSKeyedArchiver.archiveRootObject(newSubscribeCacheList, toFile: diskPath)
 
            // 成功回调
            //: self.completionHandle?(.veritySucceed, reportMoney, .Subscribe)
            self.completionHandle?(.veritySucceed, reportMoney, .Subscribe)
        }
    }
}

// MARK: - Event
//: extension AppleIAPManager {
extension CrabappleTail {
    /// 初始化数据
    //: private func iap_initData() {
    private func nowPic() {
        //: self.payCacheList = getLocalPayCacheList(payType: .Pay)
        self.payCacheList = record(payType: .Pay)
        //: self.subscribeCacheList = getLocalPayCacheList(payType: .Subscribe)
        self.subscribeCacheList = record(payType: .Subscribe)
        //: self.createOrderId = nil
        self.createOrderId = nil
    }
    
    /// 获取缓存列表
    /// - Parameter payType: 支付类型
    /// - Returns: 缓存列表
    //: private func getLocalPayCacheList(payType: ApplePayType) -> [[String: String]] {
    private func record(payType: AddressVariable) -> [[String: String]] {
        //: var list: [[String: String]]?
        var list: [[String: String]]?
        //: var diskPath = ""
        var diskPath = ""
        //: if payType == .Pay {
        if payType == .Pay {
            //: diskPath = getPayCachePath()
            diskPath = systemResponse()
        //: } else {
        } else {
            //: diskPath = getSubscribeCachePath()
            diskPath = dismiss()
        }
        
        //: if FileManager.default.fileExists(atPath: diskPath) {
        if FileManager.default.fileExists(atPath: diskPath) {
            //: list = NSKeyedUnarchiver.unarchiveObject(withFile: diskPath) as? [[String: String]]
            list = NSKeyedUnarchiver.unarchiveObject(withFile: diskPath) as? [[String: String]]
            //: if list == nil {
            if list == nil {
               //: try? FileManager.default.removeItem(atPath: diskPath)
               try? FileManager.default.removeItem(atPath: diskPath)
            }
        }
        //: if list == nil {
        if list == nil {
            //: list = [[String: String]]()
            list = [[String: String]]()
        }
        //: return list!
        return list!
    }
    
    /// 获取【购买】缓存路径【和uid关联】
    /// - Returns: 缓存路径
    //: private func getPayCachePath() -> String {
    private func systemResponse() -> String {
        //: let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        //: let appDirectoryPath = (documentDirectoryPath as NSString).appendingPathComponent("App")
        let appDirectoryPath = (documentDirectoryPath as NSString).appendingPathComponent((String(routerTabList.prefix(3))))
        
        //: let fileManager = FileManager.default
        let fileManager = FileManager.default
        //: if fileManager.fileExists(atPath: appDirectoryPath) == false {
        if fileManager.fileExists(atPath: appDirectoryPath) == false {
           //: try? fileManager.createDirectory(atPath: appDirectoryPath, withIntermediateDirectories: true)
           try? fileManager.createDirectory(atPath: appDirectoryPath, withIntermediateDirectories: true)
        }
    
        //: let filePath = (appDirectoryPath as NSString).appendingPathComponent("OrderTransactionInfo_Cache")
        let filePath = (appDirectoryPath as NSString).appendingPathComponent((String(kStreakData.prefix(4)) + "rTrans" + helperMapValue.replacingOccurrences(of: "manager", with: "o") + "nInf" + String(configLaunchToken.suffix(7))))
        //: return filePath
        return filePath
    }
    
    /// 获取【订阅】缓存路径【和uid关联】
    /// - Returns: 缓存路径
    //: private func getSubscribeCachePath() -> String {
    private func dismiss() -> String {
        //: let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        //: let appDirectoryPath = (documentDirectoryPath as NSString).appendingPathComponent("App")
        let appDirectoryPath = (documentDirectoryPath as NSString).appendingPathComponent((String(routerTabList.prefix(3))))
        
        //: let fileManager = FileManager.default
        let fileManager = FileManager.default
        //: if fileManager.fileExists(atPath: appDirectoryPath) == false {
        if fileManager.fileExists(atPath: appDirectoryPath) == false {
           //: try? fileManager.createDirectory(atPath: appDirectoryPath, withIntermediateDirectories: true)
           try? fileManager.createDirectory(atPath: appDirectoryPath, withIntermediateDirectories: true)
        }
    
        //: let filePath = (appDirectoryPath as NSString).appendingPathComponent("OrderTransactionInfo_Subscribe_Cache")
        let filePath = (appDirectoryPath as NSString).appendingPathComponent(String(bytes: k_poseDict.map{$0^25}, encoding: .utf8)!)
        //: return filePath
        return filePath
    }
 
    /// 获取本地收据数据
    /// - Parameters:
    ///   - transactionId: 收据标识符
    ///   - payType: 支付类型
    /// - Returns: 收据数据
    //: fileprivate func getVerifyData(_ transactionId: String, _ payType: ApplePayType) -> String? {
    fileprivate func deadlineBy(_ transactionId: String, _ payType: AddressVariable) -> String? {
        // 有未完成的订单，先取缓存
        //: var paramsArr = [[String: String]]()
        var paramsArr = [[String: String]]()
        //: switch(payType) {
        switch(payType) {
        //: case .Pay:
        case .Pay:
            //: paramsArr = self.payCacheList.filter({$0["transactionId"] == transactionId})
            paramsArr = self.payCacheList.filter({$0[(String(networkWithFormat) + String(notiTransformToken.prefix(9)))] == transactionId})
        //: case .Subscribe:
        case .Subscribe:
            //: paramsArr = self.subscribeCacheList.filter({$0["transactionId"] == transactionId})
            paramsArr = self.subscribeCacheList.filter({$0[(String(networkWithFormat) + String(notiTransformToken.prefix(9)))] == transactionId})
        }
        //: if paramsArr.count > 0 && paramsArr.first!["verifyData"] != nil {
        if paramsArr.count > 0 && paramsArr.first![String(bytes: showNetError.map{fileThird(app: $0)}, encoding: .utf8)!] != nil {
            //: return paramsArr.first!["verifyData"]
            return paramsArr.first![String(bytes: showNetError.map{fileThird(app: $0)}, encoding: .utf8)!]
        }

        // 取本地
        //: guard let receiptUrl = Bundle.main.appStoreReceiptURL else { return nil }
        guard let receiptUrl = Bundle.main.appStoreReceiptURL else { return nil }
        //: let data = NSData(contentsOf: receiptUrl)
        let data = NSData(contentsOf: receiptUrl)
        //: let receiptStr = data?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let receiptStr = data?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        //: return receiptStr
        return receiptStr
    }
}

// MARK: - 失败重试流程
//: extension AppleIAPManager {
extension CrabappleTail {
    /// 检测未完成的苹果支付【只会重试当前登录用户】
    //: func iap_checkUnfinishedTransactions() {
    func manager() {
        //: iap_initData()
        nowPic()

        // 【购买】失败重试
        //: for dict in self.payCacheList {
        for dict in self.payCacheList {
            //: iap_failedRetry(dict["transactionId"], .Pay)
            error(dict[(String(networkWithFormat) + String(notiTransformToken.prefix(9)))], .Pay)
        }
        
        // 【订阅】失败重试
        //: for dict in self.subscribeCacheList {
        for dict in self.subscribeCacheList {
            //: iap_failedRetry(dict["transactionId"], .Subscribe)
            error(dict[(String(networkWithFormat) + String(notiTransformToken.prefix(9)))], .Subscribe)
        }
    }
    
    /// 失败重试
    /// - Parameters:
    ///   - transactionId: Id
    ///   - payType: 支付类型
    //: private func iap_failedRetry(_ transactionId: String?, _ payType: ApplePayType) {
    private func error(_ transactionId: String?, _ payType: AddressVariable) {
        //: guard let transactionId = transactionId else { return }
        guard let transactionId = transactionId else { return }
        // 初始化每个交易请求次数
        //: reqRetryCountDict[transactionId] = 0
        reqRetryCountDict[transactionId] = 0
        // 3. 服务端校验流程
        //: transcationPurchasedToCheck(transactionId, payType)
        script(transactionId, payType)
    }
}

// MARK: - 苹果正常支付流程
//: extension AppleIAPManager {
extension CrabappleTail {
    /// 发起苹果支付【1.创建订单； 2.发起苹果支付； 3.服务端校验】
    /// - Parameters:
    ///   - purchID: 产品ID
    ///   - payType: 支付类型
    ///   - handle: 回调
    ///   - source: 0 常规充值 1 观看视频后充值或订阅
    //: func iap_startPurchase(productId: String, payType: ApplePayType, source: Int = 0, handle: @escaping IAPcompletionHandle) {
    func view(productId: String, payType: AddressVariable, source: Int = 0, handle: @escaping IAPcompletionHandle) {
        //: iap_initData()
        nowPic()
        //: self.completionHandle = handle
        self.completionHandle = handle
        //: self.currentPayType = payType
        self.currentPayType = payType
        
        // 1. 根据类型创建订单
        //: switch(payType) {
        switch(payType) {
        //: case .Pay:
        case .Pay:
            //: req_pay_createAppleOrder(productId: productId, source: source) { [weak self] orderId, succeed in
            magazine(productId: productId, source: source) { [weak self] orderId, succeed in
                //: guard let self = self else { return }
                guard let self = self else { return }
                //: guard succeed == true && orderId != nil else { 
                guard succeed == true && orderId != nil else { // 订单创建失败
                    //: self.completionHandle?(.createOrderFail, 0, .Pay)
                    self.completionHandle?(.createOrderFail, 0, .Pay)
                    //: return
                    return
                }
                
                //: self.createOrderId = orderId
                self.createOrderId = orderId
                //: self.requestProductInfo(productId)
                self.appeal(productId)
            }
        
        //: case .Subscribe:
        case .Subscribe:
            //: req_subscribe_createAppleOrder(productId: productId, source: source) { [weak self] orderId, succeed in
            conduct(productId: productId, source: source) { [weak self] orderId, succeed in
                //: guard let self = self else { return }
                guard let self = self else { return }
                //: guard succeed == true && orderId != nil else { 
                guard succeed == true && orderId != nil else { // 订单创建失败
                    //: self.completionHandle?(.createOrderFail, 0, .Subscribe)
                    self.completionHandle?(.createOrderFail, 0, .Subscribe)
                    //: return
                    return
                }
                
                //: self.createOrderId = orderId
                self.createOrderId = orderId
                //: self.requestProductInfo(productId)
                self.appeal(productId)
            }
        }
    }
        
    // 2 发起苹果支付，查询apple内购商品
    //: fileprivate func requestProductInfo(_ productId: String) {
    fileprivate func appeal(_ productId: String) {
        //: guard SKPaymentQueue.canMakePayments() else {
        guard SKPaymentQueue.canMakePayments() else {
            //: self.completionHandle?(.notArrow, 0, currentPayType)
            self.completionHandle?(.notArrow, 0, currentPayType)
            //: return
            return
        }
        
        // 销毁当前请求
        //: self.clearProductInfoRequest()
        self.streetSmart()
        // 查询apple内购商品
        //: let identifiers: Set<String> = [productId]
        let identifiers: Set<String> = [productId]
        //: productInfoReq = SKProductsRequest(productIdentifiers: identifiers)
        productInfoReq = SKProductsRequest(productIdentifiers: identifiers)
        //: productInfoReq?.delegate = self
        productInfoReq?.delegate = self
        //: productInfoReq?.start()
        productInfoReq?.start()
    }
    
    // 销毁当前请求
    //: fileprivate func clearProductInfoRequest() {
    fileprivate func streetSmart() {
        //: guard productInfoReq != nil else { return }
        guard productInfoReq != nil else { return }
        //: productInfoReq?.delegate = nil
        productInfoReq?.delegate = nil
        //: productInfoReq?.cancel()
        productInfoReq?.cancel()
        //: productInfoReq = nil
        productInfoReq = nil
    }
}

// MARK: - SKProductsRequestDelegate【商品查询】
//: extension AppleIAPManager: SKProductsRequestDelegate {
extension CrabappleTail: SKProductsRequestDelegate {
    // 查询apple内购商品成功回调
     //: func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
     func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
         //: guard response.products.count > 0 else {
         guard response.products.count > 0 else {
             //: self.completionHandle?( .noProductId, 0, currentPayType)
             self.completionHandle?( .noProductId, 0, currentPayType)
             //: return
             return
         }
         
         //: let payment = SKPayment(product: response.products.first!)
         let payment = SKPayment(product: response.products.first!)
         //: SKPaymentQueue.default().add(payment)
         SKPaymentQueue.default().add(payment)
     }
    
    // 查询apple内购商品失败
    //: func request(_ request: SKRequest, didFailWithError error: Error) {
    func request(_ request: SKRequest, didFailWithError error: Error) {
        //: self.completionHandle?( .noProductId, 0, currentPayType)
        self.completionHandle?( .noProductId, 0, currentPayType)
    }
    
    // 查询apple内购商品完成
    //: func requestDidFinish(_ request: SKRequest) {
    func requestDidFinish(_ request: SKRequest) {
        
    }
}

// MARK: - SKPaymentTransactionObserver【支付回调】
//: extension AppleIAPManager: SKPaymentTransactionObserver {
extension CrabappleTail: SKPaymentTransactionObserver {
    /// 2.2 apple内购完成回调
    //: func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //: for transaction in transactions {
        for transaction in transactions {
            //: switch transaction.transactionState {
            switch transaction.transactionState {
            //: case .purchasing:  
            case .purchasing:  // 交易中
                //: break
                break
                
            //: case .purchased:   
            case .purchased:   // 交易成功
                /**
                 original.transactionIdentifier 首次订阅时为nil，transaction.transactionIdentifier有值；
                 后续自动订阅、续订时，original.transactionIdentifier为首次订阅时生成的transaction.transactionIdentifier，值固定不变；
                 每次订阅transaction.transactionIdentifier都不一样，为当前交易的标识；
                 */
                //: if transaction.original != nil && createOrderId == nil { 
                if transaction.original != nil && createOrderId == nil { // 启动自动续订时，不需要调用服务端验证接口
                    //: self.completionHandle?(.renewSucceed, 0, currentPayType)
                    self.completionHandle?(.renewSucceed, 0, currentPayType)
                //: } else { 
                } else { // 普通购买和订阅
                    // 初始化每个交易请求次数
                    //: reqRetryCountDict[transaction.transactionIdentifier!] = 0
                    reqRetryCountDict[transaction.transactionIdentifier!] = 0
                    // 3. 服务端校验流程
                    //: transcationPurchasedToCheck(transaction.transactionIdentifier!, self.currentPayType)
                    script(transaction.transactionIdentifier!, self.currentPayType)
                }
                // 移除苹果支付系统缓存
                //: SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                //: createOrderId = nil
                createOrderId = nil
                
            //: case .failed:      
            case .failed:      // 交易失败/取消
                //: SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                //: self.completionHandle?(.failed, 0, currentPayType)
                self.completionHandle?(.failed, 0, currentPayType)
                //: createOrderId = nil
                createOrderId = nil

            //: case .restored:    
            case .restored:    // 已购买过该商品
                //: SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                //: self.completionHandle?(.restored, 0, currentPayType)
                self.completionHandle?(.restored, 0, currentPayType)
                //: createOrderId = nil
                createOrderId = nil
                
            //: case .deferred:    
            case .deferred:    // 交易延期
                //: SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                //: self.completionHandle?(.deferred, 0, currentPayType)
                self.completionHandle?(.deferred, 0, currentPayType)
                //: createOrderId = nil
                createOrderId = nil
                
            //: @unknown default:
            @unknown default:
                //: SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                //: self.completionHandle?(.unknow, 0, currentPayType)
                self.completionHandle?(.unknow, 0, currentPayType)
                //: createOrderId = nil
                createOrderId = nil
                //: fatalError(" 未知的交易类型")
                fatalError((String(helperAfterwardError) + String(parserEliteResult)))
            }
        }
    }
 
    /// 3. 服务端校验流程
    /// - Parameters:
    ///   - transactionId: 交易唯一标识符
    ///   - payType: 支付类型
    //: fileprivate func transcationPurchasedToCheck(_ transactionId: String, _ payType: ApplePayType) {
    fileprivate func script(_ transactionId: String, _ payType: AddressVariable) {
        //: guard let receiptStr = getVerifyData(transactionId, payType) else {
        guard let receiptStr = deadlineBy(transactionId, payType) else {
            //: self.completionHandle?(.verityFail, 0, payType)
            self.completionHandle?(.verityFail, 0, payType)
            //: return
            return
        }

        // 缓存支付成功信息，防止接口校验失败
        //: if createOrderId != nil { 
        if createOrderId != nil { // 正常支付流程
            //: switch(payType) {
            switch(payType) {
            //: case .Pay:
            case .Pay:
                //: if self.payCacheList.filter({$0["transactionId"] == transactionId || $0["orderId"] == createOrderId}).count == 0 {  // 防止重复添加缓存数据
                if self.payCacheList.filter({$0[(String(networkWithFormat) + String(notiTransformToken.prefix(9)))] == transactionId || $0[String(bytes: sessionProductionReduceDict.map{versionText(ad: $0)}, encoding: .utf8)!] == createOrderId}).count == 0 {  // 防止重复添加缓存数据
                    //: let cacheDict = ["transactionId": transactionId,
                    let cacheDict = [(String(networkWithFormat) + String(notiTransformToken.prefix(9))): transactionId,
                                     //: "orderId": createOrderId!,
                                     String(bytes: sessionProductionReduceDict.map{versionText(ad: $0)}, encoding: .utf8)!: createOrderId!,
                                     //: "verifyData": receiptStr]
                                     String(bytes: showNetError.map{fileThird(app: $0)}, encoding: .utf8)!: receiptStr]
                    //: self.payCacheList.append(cacheDict)
                    self.payCacheList.append(cacheDict)
                    //: let diskPath = self.getPayCachePath()
                    let diskPath = self.systemResponse()
                    //: NSKeyedArchiver.archiveRootObject(self.payCacheList, toFile: diskPath)
                    NSKeyedArchiver.archiveRootObject(self.payCacheList, toFile: diskPath)
                }
                
            //: case .Subscribe:
            case .Subscribe:
                //: if self.subscribeCacheList.filter({$0["transactionId"] == transactionId || $0["orderId"] == createOrderId}).count == 0 { // 防止重复添加缓存数据
                if self.subscribeCacheList.filter({$0[(String(networkWithFormat) + String(notiTransformToken.prefix(9)))] == transactionId || $0[String(bytes: sessionProductionReduceDict.map{versionText(ad: $0)}, encoding: .utf8)!] == createOrderId}).count == 0 { // 防止重复添加缓存数据
                    //: let cacheDict = ["transactionId": transactionId,
                    let cacheDict = [(String(networkWithFormat) + String(notiTransformToken.prefix(9))): transactionId,
                                     //: "orderId": createOrderId!,
                                     String(bytes: sessionProductionReduceDict.map{versionText(ad: $0)}, encoding: .utf8)!: createOrderId!,
                                     //: "verifyData": receiptStr]
                                     String(bytes: showNetError.map{fileThird(app: $0)}, encoding: .utf8)!: receiptStr]
                    //: self.subscribeCacheList.append(cacheDict)
                    self.subscribeCacheList.append(cacheDict)
                    //: let diskPath = self.getSubscribeCachePath()
                    let diskPath = self.dismiss()
                    //: NSKeyedArchiver.archiveRootObject(self.subscribeCacheList, toFile: diskPath)
                    NSKeyedArchiver.archiveRootObject(self.subscribeCacheList, toFile: diskPath)
                }
            }
        }
        
        // 限制交易重试最大次数
        //: var reqCount = reqRetryCountDict[transactionId] ?? 0
        var reqCount = reqRetryCountDict[transactionId] ?? 0
        //: reqCount += 1
        reqCount += 1
        //: reqRetryCountDict[transactionId] = reqCount
        reqRetryCountDict[transactionId] = reqCount
        //: if reqCount > APPLE_IAP_MAX_RETRY_COUNT {
        if reqCount > constPublicTransportValue {
            //: self.completionHandle?(.verityFail, 0, payType)
            self.completionHandle?(.verityFail, 0, payType)
            //: return
            return
        }
        
        // 3.服务端校验，根据transactionId从缓存中取
        //: switch(payType) {
        switch(payType) {
        //: case .Pay:
        case .Pay:
            //: let paramsArr = self.payCacheList.filter({$0["transactionId"] == transactionId})
            let paramsArr = self.payCacheList.filter({$0[(String(networkWithFormat) + String(notiTransformToken.prefix(9)))] == transactionId})
            //: guard paramsArr.count > 0 else { return }
            guard paramsArr.count > 0 else { return }
            //: req_pay_uploadAppletransaction(transactionId, params: paramsArr.first!)
            confirm(transactionId, params: paramsArr.first!)
            
        //: case .Subscribe:
        case .Subscribe:
            //: let paramsArr = self.subscribeCacheList.filter({$0["transactionId"] == transactionId})
            let paramsArr = self.subscribeCacheList.filter({$0[(String(networkWithFormat) + String(notiTransformToken.prefix(9)))] == transactionId})
            //: guard paramsArr.count > 0 else { return }
            guard paramsArr.count > 0 else { return }
            //: req_subscribe_uploadAppletransaction(transactionId, params: paramsArr.first!)
            enableceRange(transactionId, params: paramsArr.first!)
        }
    }
}