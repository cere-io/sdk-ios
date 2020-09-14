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
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case SdkScriptHandlers.SDK_INITIALIZED.rawValue:
            self.onInitializationFinishedHandler!()
        default:
            return
        }
    }
    
}
