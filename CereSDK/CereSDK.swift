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
    
    public enum C {
        public static let prodHtmlUrl = "https://sdk.dev.cere.io/common/native.html"
        public static let prodEnv = "production"
    }
    
    public enum AuthType {
        case firebase(String)
        case email(String, String)
        case facebook(String)
        case google(String)
        case apple (String)
        case trusted (String, String)
        
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
            case .trusted:
                return "TRUSTED_3RD_PARTY"
            }
        }
    }
    
    /// SDK instance
    public static let instance = CereSDK()
    
    private var appId: String = ""
    private var integrationPartnerUserId: String = ""
    private var externalUserId: String = ""
    private var version: String = "unknown"
    private var token: String = ""
    private var env: Environment = .dev
    private var type: String = ""
    private var password: String = ""
    private var email: String = ""
    private var nativeHtmlUrl: String = C.prodHtmlUrl
    internal var webView: WKWebView?
    
    internal var onInitializationFinishedHandler: OnInitializationFinishedHandler?
    internal var onInitializationErrorHandler: OnInitializationErrorHandler?
    internal var onEventReceivedHandler: OnEventReceivedHandler?
    internal var onJavascriptEventReceivedHandler: OnEventReceivedHandler?
    internal var onHasNftsEventReceivedHandler: OnEventReceivedHandler?
    
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
    /// - Parameter htmlUrl: Native Html Url
    
    public func initSDK(appId: String, integrationPartnerUserId: String, controller: UIViewController, type: AuthType, environment: String = C.prodEnv, htmlUrl: String = C.prodHtmlUrl) {
        self.env = Environment.init(rawValue: environment) ?? .prod
        self.sdkInitStatus = SdkStatus.INITIALIZING
        determineCurrentVersion()
        
        self.appId = appId
        self.integrationPartnerUserId = integrationPartnerUserId
        self.nativeHtmlUrl = htmlUrl
        
        switch type {
        case .email(let email, let password):
            self.type = type.typeName
            self.password = password
            self.email = email
        case .firebase(let token), .apple(let token), .facebook(let token), .google(let token):
            self.type = type.typeName
            self.token = token
        case .trusted(let token, let externalUserId):
            self.externalUserId = externalUserId
            self.token = token
        }
        
        self.initWebView(controller: controller)
        self.addScriptHandlers()
        self.loadContent(with: type)
    }
    
    /// Send event to RXB.
    /// - Parameter eventType: Type of event. For example `APP_LAUNCHED`.
    /// - Parameter payload: Optional parameter which can be passed with event.
    public func sendEvent(eventType: String, payload: String = "") {
        let json: JSON = JSON(["eventType": eventType, "payload": payload])
        self.postMessage(action: JSBridgeActions.SEND_EVENT.rawValue, data: json)
    }
    
    /// Get Nfts for the user
    public func hasNfts() {
        self.postMessage(action: JSBridgeActions.HAS_NFTS.rawValue, data: JSON())
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
        controller.view.addSubview(self.webView!)
    }
    
    private func loadContent(with authType: AuthType) {
        let urlWithPath: URL?
        let url = URL(string: "\(nativeHtmlUrl)?appId=\(self.appId)&integrationPartnerUserId=\(self.integrationPartnerUserId)&platform=ios&version=\(self.version)&env=\(self.env.rawValue)&authMethodType=\(authType.typeName)")
        
        switch authType {
        case .email(let email, let password):
            urlWithPath =   url.flatMap { URL(string: $0.absoluteString + "&email=\(email)&password=\(password)" )}
        case .apple(let token), .google(let token), .firebase(let token), .facebook(let token):
            urlWithPath =   url.flatMap { URL(string: $0.absoluteString + "&accessToken=\(token)" )}
        case .trusted(let token, let externalUserId):
            urlWithPath =   url.flatMap { URL(string: $0.absoluteString + "&token=\(token)" +  "&externalUserId=\(externalUserId)" )}
        }
        self.webView?.load(URLRequest(url: urlWithPath!))
    }
    
    private func determineCurrentVersion() {
        self.version = Bundle.init(for: Swift.type(of: self)).object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == false {
                if let urlToLoad = navigationAction.request.url {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(urlToLoad, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(urlToLoad)
                    }
                }
            }
            return nil
        }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Check for links.
//            if navigationAction.navigationType == .linkActivated {
                // Make sure the URL is set.
                guard let url = navigationAction.request.url else {
                    decisionHandler(.allow)
                    return
                }
                if url.lastPathComponent.contains("browser") {
                    // Open the link in the external browser.
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    // Cancel the decisionHandler because we managed the navigationAction.
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.allow)
                }
//            } else {
//                decisionHandler(.allow)
//            }
        }
}
