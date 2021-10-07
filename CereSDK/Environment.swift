//
//  Environment.swift
//  CereSDK
//
//  Created by Pavel_Viarkhouski on 9/14/20.
//  Copyright © 2020 CerebellumNetwork. All rights reserved.
//

import Foundation

internal struct Environment {
    internal static let LOCAL: Environment = Environment("local", "http://localhost:8080");
    internal static let DEV: Environment = Environment("dev", "https://sdk.dev.cere.io/common/native.html");
    internal static let STAGE: Environment = Environment("stage", "https://sdk.stg.cere.io/common/native.html");
    internal static let PRODUCTION: Environment = Environment("production", "https://sdk.cere.io/common/native.html");
    
    internal let name: String;
    internal let nativeHtmlUrl: String;
    
    init(_ name: String, _ nativeHtmlUrl: String) {
        self.name = name;
        self.nativeHtmlUrl = nativeHtmlUrl;
    }
}
