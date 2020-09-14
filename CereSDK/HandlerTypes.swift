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
}

public typealias OnInitializationFinishedHandler = () -> Void
