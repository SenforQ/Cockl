
//: Declare String Begin

/*: "init(coder:) has not been implemented" :*/
fileprivate let managerQualityMsg:[UInt8] = [0x63,0x68,0x63,0x6e,0x22,0x5d,0x69,0x5e,0x5f,0x6c,0x34,0x23,0x1a,0x62,0x5b,0x6d,0x1a,0x68,0x69,0x6e,0x1a,0x5c,0x5f,0x5f,0x68,0x1a,0x63,0x67,0x6a,0x66,0x5f,0x67,0x5f,0x68,0x6e,0x5f,0x5e]

fileprivate func contactNative(down num: UInt8) -> UInt8 {
    let value = Int(num) - 250
    if value < 0 {
        return UInt8(value + 256)
    } else {
        return UInt8(value)
    }
}

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  ContextSource.swift
//  AbroadTalking
//
//  Created by Joeyoung on 2022/9/1.
//

//: import UIKit
import UIKit

//: let kProgressHUD_W            = 80.0
let const_raceId            = 80.0
//: let kProgressHUD_cornerRadius = 14.0
let configPackageState = 14.0
//: let kProgressHUD_alpha        = 0.9
let noti_netList        = 0.9
//: let kBackgroundView_alpha     = 0.6
let controllerGatheringRatingVersion     = 0.6
//: let kAnimationInterval        = 0.2
let dataSubscribeMode        = 0.2
//: let kTransformScale           = 0.9
let managerCornerUrl           = 0.9

//: open class ProgressHUD: UIView {
open class ContextSource: UIView {
    //: required public init?(coder: NSCoder) {
    required public init?(coder: NSCoder) {
        //: fatalError("init(coder:) has not been implemented")
        fatalError(String(bytes: managerQualityMsg.map{contactNative(down: $0)}, encoding: .utf8)!)
    }
    
    //: static var shared = ProgressHUD()
    static var shared = ContextSource()
    //: private override init(frame: CGRect) {
    private override init(frame: CGRect) {
        //: super.init(frame: frame)
        super.init(frame: frame)
        //: self.frame = UIScreen.main.bounds
        self.frame = UIScreen.main.bounds
        //: self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //: self.backgroundColor = UIColor(white: 0, alpha: 0)
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        //: self.addSubview(activityIndicator)
        self.addSubview(activityIndicator)
    }
    //: open override func copy() -> Any { return self }
    open override func copy() -> Any { return self }
    //: open override func mutableCopy() -> Any { return self }
    open override func mutableCopy() -> Any { return self }
    
    //: class func show() {
    class func bringHome() {
        //: show(superView: nil)
        component(superView: nil)
    }
    //: class func show(superView: UIView?) {
    class func component(superView: UIView?) {
        //: if superView != nil {
        if superView != nil {
            //: DispatchQueue.main.async {
            DispatchQueue.main.async {
                //: ProgressHUD.shared.frame = superView!.bounds
                ContextSource.shared.frame = superView!.bounds
                //: ProgressHUD.shared.activityIndicator.center = ProgressHUD.shared.center
                ContextSource.shared.activityIndicator.center = ContextSource.shared.center
                //: superView!.addSubview(ProgressHUD.shared)
                superView!.addSubview(ContextSource.shared)
            }
        //: } else {
        } else {
            //: DispatchQueue.main.async {
            DispatchQueue.main.async {
                //: ProgressHUD.shared.frame = UIScreen.main.bounds
                ContextSource.shared.frame = UIScreen.main.bounds
                //: ProgressHUD.shared.activityIndicator.center = ProgressHUD.shared.center
                ContextSource.shared.activityIndicator.center = ContextSource.shared.center
                //: AppConfig.getWindow().addSubview(ProgressHUD.shared)
                CommandConsent.asWill().addSubview(ContextSource.shared)
            }
        }
        //: ProgressHUD.shared.hud_startAnimating()
        ContextSource.shared.cityCenter()
    }
    //: class func dismiss() {
    class func offHauled() {
        //: ProgressHUD.shared.hud_stopAnimating()
        ContextSource.shared.pass()
    }
    
    //: private func hud_startAnimating() {
    private func cityCenter() {
        //: DispatchQueue.main.async {
        DispatchQueue.main.async {
            //: self.backgroundColor = UIColor(white: 0, alpha: 0)
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            //: self.activityIndicator.transform = CGAffineTransform(scaleX: kTransformScale, y: kTransformScale)
            self.activityIndicator.transform = CGAffineTransform(scaleX: managerCornerUrl, y: managerCornerUrl)
            //: self.activityIndicator.alpha = 0
            self.activityIndicator.alpha = 0
            //: UIView.animate(withDuration: kAnimationInterval) {
            UIView.animate(withDuration: dataSubscribeMode) {
                //: self.backgroundColor = UIColor(white: 0, alpha: kBackgroundView_alpha)
                self.backgroundColor = UIColor(white: 0, alpha: controllerGatheringRatingVersion)
                //: self.activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
                //: self.activityIndicator.alpha = kProgressHUD_alpha
                self.activityIndicator.alpha = noti_netList
                //: self.activityIndicator.startAnimating()
                self.activityIndicator.startAnimating()
            }
        }
    }
    //: private func hud_stopAnimating() {
    private func pass() {
        //: DispatchQueue.main.async {
        DispatchQueue.main.async {
            //: UIView.animate(withDuration: kAnimationInterval) {
            UIView.animate(withDuration: dataSubscribeMode) {
                //: self.backgroundColor = UIColor(white: 0, alpha: 0)
                self.backgroundColor = UIColor(white: 0, alpha: 0)
                //: self.activityIndicator.transform = CGAffineTransform(scaleX: kTransformScale, y: kTransformScale)
                self.activityIndicator.transform = CGAffineTransform(scaleX: managerCornerUrl, y: managerCornerUrl)
                //: self.activityIndicator.alpha = 0
                self.activityIndicator.alpha = 0
            //: } completion: { finished in
            } completion: { finished in
                //: self.activityIndicator.stopAnimating()
                self.activityIndicator.stopAnimating()
                //: ProgressHUD.shared.removeFromSuperview()
                ContextSource.shared.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Lazy load
    //: private lazy var activityIndicator: UIActivityIndicatorView = {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        //: let indicator = UIActivityIndicatorView(style: .whiteLarge)
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        //: indicator.bounds = CGRect(x: 0, y: 0, width: kProgressHUD_W, height: kProgressHUD_W)
        indicator.bounds = CGRect(x: 0, y: 0, width: const_raceId, height: const_raceId)
        //: indicator.center = self.center
        indicator.center = self.center
        //: indicator.backgroundColor = .black
        indicator.backgroundColor = .black
        //: indicator.layer.cornerRadius = kProgressHUD_cornerRadius
        indicator.layer.cornerRadius = configPackageState
        //: indicator.layer.masksToBounds = true
        indicator.layer.masksToBounds = true
        //: return indicator
        return indicator
    //: }()
    }()
}

//: extension ProgressHUD {
extension ContextSource {
    //: class func toast(_ str: String?) {
    class func firstAcross(_ str: String?) {
        //: toast(str, showTime: 1)
        global(str, showTime: 1)
    }
    //: class func toast(_ str: String?, showTime: CGFloat) {
    class func global(_ str: String?, showTime: CGFloat) {
        //: guard str != nil else { return }
        guard str != nil else { return }
                
        //: let titleLab = UILabel()
        let titleLab = UILabel()
        //: titleLab.backgroundColor = UIColor(white: 0, alpha: 0.8)
        titleLab.backgroundColor = UIColor(white: 0, alpha: 0.8)
        //: titleLab.layer.cornerRadius = 5
        titleLab.layer.cornerRadius = 5
        //: titleLab.layer.masksToBounds = true
        titleLab.layer.masksToBounds = true
        //: titleLab.text = str
        titleLab.text = str
        //: titleLab.font = .systemFont(ofSize: 16)
        titleLab.font = .systemFont(ofSize: 16)
        //: titleLab.textAlignment = .center
        titleLab.textAlignment = .center
        //: titleLab.numberOfLines = 0
        titleLab.numberOfLines = 0
        //: titleLab.textColor = .white
        titleLab.textColor = .white
        //: AppConfig.getWindow().addSubview(titleLab)
        CommandConsent.asWill().addSubview(titleLab)
        //: let size = titleLab.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat(MAXFLOAT)))
        let size = titleLab.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat(MAXFLOAT)))
        //: titleLab.center = AppConfig.getWindow().center
        titleLab.center = CommandConsent.asWill().center
        //: titleLab.bounds = CGRect(x: 0, y: 0, width: size.width + 30, height: size.height + 30)
        titleLab.bounds = CGRect(x: 0, y: 0, width: size.width + 30, height: size.height + 30)
        //: titleLab.alpha = 0
        titleLab.alpha = 0
        
        //: UIView.animate(withDuration: 0.2) {
        UIView.animate(withDuration: 0.2) {
            //: titleLab.alpha = 1
            titleLab.alpha = 1
        //: } completion: { finished in
        } completion: { finished in
            //: DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + showTime) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + showTime) {
                //: UIView.animate(withDuration: 0.2) {
                UIView.animate(withDuration: 0.2) {
                    //: titleLab.alpha = 1
                    titleLab.alpha = 1
                //: } completion: { finished in
                } completion: { finished in
                    //: titleLab.removeFromSuperview()
                    titleLab.removeFromSuperview()
                }
            }
        }
    }
}