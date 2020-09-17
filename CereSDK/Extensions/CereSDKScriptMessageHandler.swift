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
        default:
            return
        }
    }
    
    internal func addScriptHandlers() {
        self.webView.configuration.userContentController.add(self, name: SdkScriptHandlers.SDK_INITIALIZED.rawValue)
        self.webView.configuration.userContentController.add(self, name: SdkScriptHandlers.ENGAGEMENT_RECEIVED.rawValue)
        self.webView.configuration.userContentController.add(self, name: SdkScriptHandlers.SDK_INITIALIZED_ERROR.rawValue)
    }
    
}
