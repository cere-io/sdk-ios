//
//  CereSDKView.swift
//  CereSDK
//
//  Created by Pavel_Viarkhouski on 9/15/20.
//  Copyright © 2020 CerebellumNetwork. All rights reserved.
//

import Foundation
import UIKit

extension CereSDK {
    
    internal func updateWebViewSize() {
        let s = UIScreen.main.bounds
        
        let frame = CGRect(
            x: s.minX + s.width * self.leftPercentage / 100,
            y: s.minY + s.height * self.topPercentage / 100,
            width: s.width * self.widthPercentage / 100,
            height: s.height * self.heightPercentage / 100)
        
        self.webView.frame = frame
    }
    
    internal func hideWebView() {
        self.webView.frame = .zero
    }
    
}
