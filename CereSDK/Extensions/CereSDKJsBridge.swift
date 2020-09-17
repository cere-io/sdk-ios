//
//  CereSDKJsBridge.swift
//  CereSDK
//
//  Created by Pavel_Viarkhouski on 9/14/20.
//  Copyright © 2020 CerebellumNetwork. All rights reserved.
//

import Foundation
import SwiftyJSON

extension CereSDK {
    internal enum JSBridgeActions : String {
        case SEND_EVENT = "sendEvent"
    }
    
    internal func postMessage(action: String, data: JSON) {
        let js = "window.cereBridge.onMessage(\"\(action)\", \(data))"
        self.webView.evaluateJavaScript(js) {(result, error) in
            if error != nil {
                // TODO add to some queue to re-run
            }
        }
    }
}
