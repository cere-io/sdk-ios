//
//  CereSDKHooks.swift
//  CereSDK
//
//  Created by Pavel_Viarkhouski on 9/14/20.
//  Copyright © 2020 CerebellumNetwork. All rights reserved.
//

import Foundation

extension CereSDK {
    
    /// Sets handler that is called when widget is finished initialization.
    public func onInitializationFinished(_ handler: @escaping OnInitializationFinishedHandler) -> CereSDK {
        self.onInitializationFinishedHandler = handler
        return self
    }
    
}
