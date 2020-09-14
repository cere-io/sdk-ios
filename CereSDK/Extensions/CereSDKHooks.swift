//
//  CereSDKHooks.swift
//  CereSDK
//
//  Created by Pavel_Viarkhouski on 9/14/20.
//  Copyright © 2020 CerebellumNetwork. All rights reserved.
//

import Foundation

extension CereSDK {
    
    public func onInitializationFinished(_ handler: @escaping OnInitializationFinishedHandler) -> CereSDK {
        self.onInitializationFinishedHandler = handler
        return self
    }
    
}
