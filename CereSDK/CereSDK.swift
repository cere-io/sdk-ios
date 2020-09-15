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

/// Class that provides all the functionality of the Cere SDK.
///
public class CereSDK: NSObject, WKNavigationDelegate {
    private var appId: String?
    private var integrationPartnerUserId: String?
    private var version: String = "unknown"
    private var env: Environment = Environment.PRODUCTION
    
    internal var controller: UIViewController?
    internal var webView: WKWebView?
    
    internal var onInitializationFinishedHandler: OnInitializationFinishedHandler?
        
    internal var leftPercentage: CGFloat = 0
    internal var topPercentage: CGFloat = 0
    internal var widthPercentage: CGFloat = 100
    internal var heightPercentage: CGFloat = 100
    
    public override init() {}
    
    /// Initializes and prepares the SDK for usage.
    /// - Parameter appId: identifier of the application from RXB.
    /// - Parameter integrationPartnerUserId: The user’s id in the system.
    /// - Parameter controller: UIViewController where SDK's WebView will be attached to
    public func initSDK(appId: String, integrationPartnerUserId: String, controller: UIViewController) {
        determineCurrentVersion()
        
        self.appId = appId
        self.integrationPartnerUserId = integrationPartnerUserId
        self.controller = controller
        
        self.initWebView()
        self.addScriptHandlers()
        self.loadContent()
    }
    
    /// Send event to RXB.
    /// - Parameter eventType: Type of event. For example `APP_LAUNCHED`.
    /// - Parameter payload: Optional parameter which can be passed with event.
    public func sendEvent(eventType: String, payload: String = "") {
        self.postMessage(action: JSBridgeActions.SEND_EVENT.rawValue, data: eventType)
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
    
    private func initWebView() {
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.webView!.navigationDelegate = self
        self.controller!.view.addSubview(self.webView!)
    }
    
    private func loadContent() {
        let url = URL(string: "\(self.env.nativeHtmlUrl)?appId=\(self.appId!)&integrationPartnerUserId=\(self.integrationPartnerUserId!)&platform=ios&version=\(self.version)&env=\(self.env.name)")
        self.webView!.load(URLRequest(url: url!))
    }
    
    private func determineCurrentVersion() {
        self.version = Bundle.init(for: type(of: self)).object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
