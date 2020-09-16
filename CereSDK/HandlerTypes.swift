//
//  Handlers.swift
//  CereSDK
//
//  Created by Pavel_Viarkhouski on 9/14/20.
//  Copyright © 2020 CerebellumNetwork. All rights reserved.
//

import Foundation

internal enum SdkScriptHandlers : String {
    case SDK_INITIALIZED = "SDKInitialized"
    case ENGAGEMENT_RECEIVED = "EngagementReceived"
    case SDK_INITIALIZED_ERROR = "SDKInitializedError"
}

/// Type for OnInitializationFinishedHandler event handler.
public typealias OnInitializationFinishedHandler = () -> Void
public typealias OnInitializationErrorHandler = (_ errorMsg: String) -> Void
