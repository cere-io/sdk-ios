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
            self.onInitializationFinishedHandler!()
        case SdkScriptHandlers.ENGAGEMENT_RECEIVED.rawValue:
            self.updateWebViewSize()
        default:
            return
        }
    }
    
    internal func addScriptHandlers() {
        self.webView!.configuration.userContentController.add(self, name: SdkScriptHandlers.SDK_INITIALIZED.rawValue)
        self.webView!.configuration.userContentController.add(self, name: SdkScriptHandlers.ENGAGEMENT_RECEIVED.rawValue)
    }
    
}
