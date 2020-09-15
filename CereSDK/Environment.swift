//
//  Environment.swift
//  CereSDK
//
//  Created by Pavel_Viarkhouski on 9/14/20.
//  Copyright © 2020 CerebellumNetwork. All rights reserved.
//

import Foundation

/// Struct to set the widget running environment. It contains settings to work in specified environments.
public struct Environment {
    /// Configuration property for Local environment.
    internal static let LOCAL: Environment = Environment("local", "http://localhost:8080");
    
    /// Configuration property for Dev environment.
    internal static let DEV: Environment = Environment("dev", "TODO");
    
    /// Configuration property for Stage environment.
    internal static let STAGE: Environment = Environment("stage", "TODO");
    
    /// Configuration property for Production environment.
    internal static let PRODUCTION: Environment = Environment("production", "https://s3-us-west-2.amazonaws.com/sdk-common.cere.io/native.html");
    
    /// Name of environment.
    internal let name: String;
    
    /// Url to native html.
    internal let nativeHtmlUrl: String;
    
    init(_ name: String, _ nativeHtmlUrl: String) {
        self.name = name;
        self.nativeHtmlUrl = nativeHtmlUrl;
    }
}
