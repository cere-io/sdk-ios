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
    public static let LOCAL: Environment = Environment("local", "http://localhost:8080");
    
    /// Configuration property for Dev1 environment.
    static let DEV: Environment = Environment("dev", "TODO");
    
    /// Configuration property for Stage environment.
    public static let STAGE: Environment = Environment("stage", "TODO");
    
    /// Configuration property for Production environment.
    public static let PRODUCTION: Environment = Environment("production", "TODO");
    
    /// Name of environment.
    public let name: String;
    
    /// Url to widget-ui server.
    public let widgetURL: String;
    
    init(_ name: String, _ widgetURL: String) {
        self.name = name;
        self.widgetURL = widgetURL;
    }
}
