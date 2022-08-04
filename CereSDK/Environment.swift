//
//  Environment.swift
//  CereSDK
//
//  Created by Pavel_Viarkhouski on 9/14/20.
//  Copyright © 2020 CerebellumNetwork. All rights reserved.
//

import Foundation

internal enum Environment: String {
    case local
    case dev
    case stg
    case prod
    
    var nativeHtmlUrl: String{
        switch self {
        case .local:
            return "http://localhost:8080"
        case .dev:
            return "https://sdk.dev.cere.io/common/native.html"
        case .stg:
            return "https://sdk.stg.cere.io/common/native.html"
        case .prod:
            return "https://sdk.dev.cere.io/common/native.html"
        }
    }
}
