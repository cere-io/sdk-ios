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

public class CereSDK: NSObject, WKNavigationDelegate {
    private var appId: String?
    private var integrationPartnerUserId: String?
    private var controller: UIViewController?
    private var version: String = "unknown"
    private var env: Environment = Environment.LOCAL
    
    internal var webView: WKWebView?
    
    internal var onInitializationFinishedHandler: OnInitializationFinishedHandler?
    
    public override init() {}
    
    public func initSDK(appId: String, integrationPartnerUserId: String, controller: UIViewController) {
        determineCurrentVersion()
        
        self.appId = appId
        self.integrationPartnerUserId = integrationPartnerUserId
        self.controller = controller
        
        initWebView()
        addScriptHandlers()
        loadContent()
    }
    
    public func sendEvent(eventType: String) {
        self.postMessage(action: JSBridgeActions.SEND_EVENT.rawValue, data: eventType)
    }
    
    private func initWebView() {
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.webView!.navigationDelegate = self
        self.controller!.view.addSubview(self.webView!)
        
        self.webView!.translatesAutoresizingMaskIntoConstraints = false
        self.webView!.topAnchor.constraint(equalTo: self.controller!.view.topAnchor).isActive = true
        self.webView!.bottomAnchor.constraint(equalTo: self.controller!.view.bottomAnchor).isActive = true
        self.webView!.leadingAnchor.constraint(equalTo: self.controller!.view.leadingAnchor).isActive = true
        self.webView!.trailingAnchor.constraint(equalTo: self.controller!.view.trailingAnchor).isActive = true
    }
    
    private func addScriptHandlers() {
        self.webView!.configuration.userContentController.add(self, name: SdkScriptHandlers.SDK_INITIALIZED.rawValue)
    }
    
    private func loadContent() {
        let url = URL(string: "\(self.env.widgetURL)/native.html?appId=\(self.appId!)&integrationPartnerUserId=\(self.integrationPartnerUserId!)&iosSdkVersion=\(self.version)&env=\(self.env.name)")
        self.webView!.load(URLRequest(url: url!))
    }
    
    private func determineCurrentVersion() {
        self.version = Bundle.init(for: type(of: self)).object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
