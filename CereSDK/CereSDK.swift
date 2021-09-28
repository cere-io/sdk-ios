//
//  CereSDK.swift
//  CereSDK
//
//  Created by Pavel_Viarkhouski on 9/9/20.
//  Copyright © 2020 CerebellumNetwork. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SwiftyJSON

/// Class that provides all the functionality of the Cere SDK.
///
public class CereSDK: NSObject, WKNavigationDelegate {
    
    public enum AuthType {
        case firebase(String)
        case email(String, String)
        case facebook(String)
        case google(String)
        case apple (String)
        
        var typeName: String {
            switch self {
            case .email:
                return "EMAIL"
            case .firebase:
                return "FIREBASE"
            case .apple:
                return "OAUTH_APPLE"
            case .facebook:
                return "OAUTH_FACEBOOK"
            case .google:
                return "OAUTH_GOOGLE"
            }
        }
    }
    
    /// SDK instance
    public static let instance = CereSDK()

    private var appId: String = ""
    private var integrationPartnerUserId: String = ""
    private var version: String = "unknown"
    private var token: String = ""
    private var env: Environment = Environment.PRODUCTION
    private var type: String = ""
    private var password: String = ""
    private var email: String = ""
    internal var webView: WKWebView?
    
    internal var onInitializationFinishedHandler: OnInitializationFinishedHandler?
    internal var onInitializationErrorHandler: OnInitializationErrorHandler?
    internal var onEventReceivedHandler: OnEventReceivedHandler?
        
    internal var leftPercentage: CGFloat = 0
    internal var topPercentage: CGFloat = 0
    internal var widthPercentage: CGFloat = 100
    internal var heightPercentage: CGFloat = 100
    
    internal var sdkInitStatus: SdkStatus = SdkStatus.NOT_INITIALIZED
    
    private override init() {
        super.init()
    }
    
    /// Initializes and prepares the SDK for usage.
    /// - Parameter appId: identifier of the application from RXB.
    /// - Parameter integrationPartnerUserId: The user’s id in the system.
    /// - Parameter controller: UIViewController where SDK's WebView will be attached to
    /// - Parameter token: (Optional) User onboarding access token
    /// - Parameter email: (Optional) User email
    /// - Parameter password: (Optional) User password
    /// - Parameter type: Auth method
    
    public func initSDK(appId: String, integrationPartnerUserId: String, controller: UIViewController, type: AuthType) {
        self.sdkInitStatus = SdkStatus.INITIALIZING
        determineCurrentVersion()
    
        self.appId = appId
        self.integrationPartnerUserId = integrationPartnerUserId
        
        switch type {
        case .email(let email, let password):
            self.type = type.typeName
            self.password = password
            self.email = email
        case .firebase(let token), .apple(let token), .facebook(let token), .google(let token):
            self.type = type.typeName
            self.token = token
        }
        
        self.initWebView(controller: controller)
        self.addScriptHandlers()
        self.loadContent()
    }
    
    /// Send event to RXB.
    /// - Parameter eventType: Type of event. For example `APP_LAUNCHED`.
    /// - Parameter payload: Optional parameter which can be passed with event.
    public func sendEvent(eventType: String, payload: String = "") {
        let json: JSON = JSON(["eventType": eventType, "payload": payload])
        self.postMessage(action: JSBridgeActions.SEND_EVENT.rawValue, data: json)
    }
    
    /// Sets custom size for the widget. Parameters should be specified in percentage of screen bounds.
    public func setDisplay(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) {
        self.leftPercentage = left
        self.topPercentage = top
        self.widthPercentage = width
        self.heightPercentage = height
    }

    /// Hide SDK view
    public func hide() {
        self.hideWebView()
    }
    
    /// Destroy SDK view
    public func destroy() {
        self.webView?.stopLoading()
        self.webView?.removeFromSuperview()
        self.webView = nil
        self.sdkInitStatus = SdkStatus.NOT_INITIALIZED
    }
    
    /// Returns current SDK status
    public func getStatus() -> SdkStatus {
        return self.sdkInitStatus
    }
    
    private func initWebView(controller: UIViewController) {
        self.webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.webView?.navigationDelegate = self
        updateWebViewSize()
        controller.view.addSubview(self.webView!)
    }
    
    private func loadContent() {
        let url = URL(string: "\(self.env.nativeHtmlUrl)?appId=\(self.appId)&integrationPartnerUserId=\(self.integrationPartnerUserId)&platform=ios&version=\(self.version)&env=\(self.env.name)&token=\(self.token)")
        self.webView?.load(URLRequest(url: url!))
    }
    
    private func determineCurrentVersion() {
        self.version = Bundle.init(for: Swift.type(of: self)).object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
