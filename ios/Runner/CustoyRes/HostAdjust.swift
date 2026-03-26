
//: Declare String Begin

/*: "Net Error, Try again later" :*/
fileprivate let serviceStyleMsg:String = "Net make phone feedback manager core"
fileprivate let showClearUrl:String = ", Try float kind"
fileprivate let parserActivityPath:[Character] = ["a","g","a","i","n"," ","l","a","t","e","r"]

/*: "data" :*/
fileprivate let k_oversightServiceMessage:[Character] = ["d","a","t","a"]

/*: ":null" :*/
fileprivate let showTunValue:String = "stop guard bring launch:null"

/*: "json error" :*/
fileprivate let controllerDownwardsError:String = "json object style already nut session"
fileprivate let viewDataConverterToken:[Character] = ["e","r","r","o","r"]

/*: "platform=iphone&version= :*/
fileprivate let viewByStatusID:String = "platriggerf"
fileprivate let serviceLogKey:[Character] = ["o","r"]
fileprivate let kHandleLoopSharedTitle:String = "where adjustment city confirm previousm=ip"
fileprivate let sessionClearDict:String = "category later after homeversion="

/*: &packageId= :*/
fileprivate let constPrintMediaUrl:String = "poor panel pending item home&pack"
fileprivate let user_firstYearSecret:String = "type feedback transport minuted="

/*: &bundleId= :*/
fileprivate let viewNowadaysID:String = "&bundnormal first for select copy"
fileprivate let show_stopTimeMsg:String = "leId=home production visible script"

/*: &lang= :*/
fileprivate let k_hourString:String = "&lang=too event available presentation else"

/*: ; build: :*/
fileprivate let helperTrackName:[Character] = [";"," ","b","u","i","l","d",":"]

/*: ; iOS  :*/
fileprivate let loggerNetDict:String = "option input push where; iOS "

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//: import UIKit
import UIKit
//: import Alamofire
import Alamofire
//: import CoreMedia
import CoreMedia
//: import HandyJSON
import HandyJSON
 
//: typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: AppErrorResponse?) -> Void
typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: CountervalFir?) -> Void
 
//: @objc class AppRequestTool: NSObject {
@objc class HostAdjust: NSObject {
    /// 发起Post请求
    /// - Parameters:
    ///   - model: 请求参数
    ///   - completion: 回调
    //: class func startPostRequest(model: AppRequestModel, completion: @escaping FinishBlock) {
    class func offColor(model: DeleteModel, completion: @escaping FinishBlock) {
        //: let serverUrl = self.buildServerUrl(model: model)
        let serverUrl = self.willOf(model: model)
        //: let headers = self.getRequestHeader(model: model)
        let headers = self.obtrudeWith(model: model)
        //: AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
        AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
            //: switch responseData.result {
            switch responseData.result {
            //: case .success:
            case .success:
                //: func__requestSucess(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)
                pageIn(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)
                
            //: case .failure:
            case .failure:
                //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "Net Error, Try again later"))
                completion(false, nil, CountervalFir.init(errorCode: OpVariable.NetError.rawValue, errorMsg: (String(serviceStyleMsg.prefix(4)) + "Error" + String(showClearUrl.prefix(6)) + String(parserActivityPath))))
            }
        }
    }
    
    //: class func func__requestSucess(model: AppRequestModel, response: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
    class func pageIn(model: DeleteModel, response: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
        //: var responseJson = String(data: responseData, encoding: .utf8)
        var responseJson = String(data: responseData, encoding: .utf8)
        //: responseJson = responseJson?.replacingOccurrences(of: "\"data\":null", with: "\"data\":{}")
        responseJson = responseJson?.replacingOccurrences(of: "\"" + (String(k_oversightServiceMessage)) + "\"" + (String(showTunValue.suffix(5))), with: "" + "\"" + (String(k_oversightServiceMessage)) + "\"" + ":{}")
        //: if let responseModel = JSONDeserializer<AppBaseResponse>.deserializeFrom(json: responseJson) {
        if let responseModel = JSONDeserializer<EscapeFoundFinish>.deserializeFrom(json: responseJson) {
            //: if responseModel.errno == RequestResultCode.Normal.rawValue {
            if responseModel.errno == OpVariable.Normal.rawValue {
                //: completion(true, responseModel.data, nil)
                completion(true, responseModel.data, nil)
            //: } else {
            } else {
                //: completion(false, responseModel.data, AppErrorResponse.init(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                completion(false, responseModel.data, CountervalFir.init(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                //: switch responseModel.errno {
                switch responseModel.errno {
//                case OpVariable.NeedReLogin.rawValue:
//                    NotificationCenter.default.post(name: DID_LOGIN_OUT_SUCCESS_NOTIFICATION, object: nil, userInfo: nil)
                //: default:
                default:
                    //: break
                    break
                }
            }
        //: } else {
        } else {
            //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "json error"))
            completion(false, nil, CountervalFir.init(errorCode: OpVariable.NetError.rawValue, errorMsg: (String(controllerDownwardsError.prefix(5)) + String(viewDataConverterToken))))
        }
                
    }
    
    //: class func buildServerUrl(model: AppRequestModel) -> String {
    class func willOf(model: DeleteModel) -> String {
        //: var serverUrl: String = model.requestServer
        var serverUrl: String = model.requestServer
        //: let otherParams = "platform=iphone&version=\(AppNetVersion)&packageId=\(PackageID)&bundleId=\(AppBundle)&lang=\(UIDevice.interfaceLang)"
        let otherParams = (viewByStatusID.replacingOccurrences(of: "trigger", with: "t") + String(serviceLogKey) + String(kHandleLoopSharedTitle.suffix(4)) + "hone&" + String(sessionClearDict.suffix(8))) + "\(noti_warnStatusData)" + (String(constPrintMediaUrl.suffix(5)) + "ageI" + String(user_firstYearSecret.suffix(2))) + "\(parserModeAdState)" + (String(viewNowadaysID.prefix(5)) + String(show_stopTimeMsg.prefix(5))) + "\(main_globalPermissionPath)" + (String(k_hourString.prefix(6))) + "\(UIDevice.interfaceLang)"
        //: if !model.requestPath.isEmpty {
        if !model.requestPath.isEmpty {
            //: serverUrl.append("/\(model.requestPath)")
            serverUrl.append("/\(model.requestPath)")
        }
        //: serverUrl.append("?\(otherParams)")
        serverUrl.append("?\(otherParams)")
        
        //: return serverUrl
        return serverUrl
    }
    
    /// 获取请求头参数
    /// - Parameter model: 请求模型
    /// - Returns: 请求头参数
    //: class func getRequestHeader(model: AppRequestModel) -> HTTPHeaders {
    class func obtrudeWith(model: DeleteModel) -> HTTPHeaders {
        //: let userAgent = "\(AppName)/\(AppVersion) (\(AppBundle); build:\(AppBuildNumber); iOS \(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        let userAgent = "\(data_mapFormat)/\(controllerQuantitativeRelationMessage) (\(main_globalPermissionPath)" + (String(helperTrackName)) + "\(showServerValue)" + (String(loggerNetDict.suffix(6))) + "\(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        //: let headers = [HTTPHeader.userAgent(userAgent)]
        let headers = [HTTPHeader.userAgent(userAgent)]
        //: return HTTPHeaders(headers)
        return HTTPHeaders(headers)
    }
}
 