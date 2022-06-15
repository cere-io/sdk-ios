//
//  CereSDK.swift
//  CereSDK
//
//  Created by Pavel_Viarkhouski on 9/14/20.
//  Copyright © 2020 CerebellumNetwork. All rights reserved.
//

import Foundation
import WebKit

extension CereSDK: WKScriptMessageHandler {
    
    /// Handles messages coming from SDK webview
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case SdkScriptHandlers.SDK_INITIALIZED.rawValue:
            self.sdkInitStatus = SdkStatus.INITIALIZED
            self.onInitializationFinishedHandler?()
        case SdkScriptHandlers.ENGAGEMENT_RECEIVED.rawValue:
            self.updateWebViewSize()
        case SdkScriptHandlers.SDK_INITIALIZED_ERROR.rawValue:
            self.sdkInitStatus = SdkStatus.INITIALIZE_ERROR
            self.onInitializationErrorHandler?(message.body as! String)
        case SdkScriptHandlers.EVENT_RECEIVED.rawValue:
            guard let data = (message.body as! String).data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let event = json["event"] as? String,
                  let payloadData = try? JSONSerialization.data(withJSONObject: json["payload"] as Any, options: []),
                  let payload = String(data: payloadData, encoding: .utf8) else {
                return
            }
            self.onEventReceivedHandler?(event, payload)
//        case SdkScriptHandlers.HAS_NFTS_RECEIVED.rawValue:
//            {"payload":{"data":true}}
//            self.showResponsePopup?(message.body as! String)
        case SdkScriptHandlers.JAVASCRIPT_EVENT_RECEIVED.rawValue:
            guard let data = (message.body as! String).data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let event = json["eventName"] as? String else {
                return
            }
            self.onJavascriptEventReceivedHandler?(event, "")
        default:
            return
        }
    }
    
    internal func addScriptHandlers() {
        self.webView?.configuration.userContentController.add(self, name: SdkScriptHandlers.SDK_INITIALIZED.rawValue)
        self.webView?.configuration.userContentController.add(self, name: SdkScriptHandlers.ENGAGEMENT_RECEIVED.rawValue)
        self.webView?.configuration.userContentController.add(self, name: SdkScriptHandlers.SDK_INITIALIZED_ERROR.rawValue)
        self.webView?.configuration.userContentController.add(self, name: SdkScriptHandlers.EVENT_RECEIVED.rawValue)
        self.webView?.configuration.userContentController.add(self, name: SdkScriptHandlers.HAS_NFTS_RECEIVED.rawValue)
        self.webView?.configuration.userContentController.add(self, name: SdkScriptHandlers.JAVASCRIPT_EVENT_RECEIVED.rawValue)
    }
}
