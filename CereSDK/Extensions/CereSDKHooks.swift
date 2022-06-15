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
    
    /// Sets handler that is called when widget is failed to initialize.
    public func onInitializationError(_ handler: @escaping OnInitializationErrorHandler) -> CereSDK {
        self.onInitializationErrorHandler = handler
        return self
    }
    
    /// Sets handler that is called when widget is recieved an event.
    public func onEventReceived(_ handler: @escaping OnEventReceivedHandler) -> CereSDK {
        self.onEventReceivedHandler = handler
        return self
    }
    
    /// Sets handler that is called when widget is recieved js event.
    public func onJavascriptEventReceivedHandler(_ handler: @escaping OnEventReceivedHandler) -> CereSDK {
        self.onJavascriptEventReceivedHandler = handler
        return self
    }

    /// Sets handler that is called when widget is recieved js event.
    public func onHasNftsEventReceivedHandler(_ handler: @escaping OnEventReceivedHandler) -> CereSDK {
        self.onHasNftsEventReceivedHandler = handler
        return self
    }

    
}
