//
//  GlobalHelpers.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/16/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import Foundation
import UIKit

enum LogLevel: String {
    case Debug      = "DEBUG"
    case Warning    = "WARNING"
    case Error      = "ERROR"
}

/* Log message to the console */
func log(level: LogLevel = .Debug, message: String, fileName: String = __FILE__, functionName: String = __FUNCTION__, lineNumber: Int = __LINE__) {
    let levelString = "[\(level.rawValue)]"
    let lineString  = "(line: \(lineNumber))"
    let messageSeparator = ":"
    
    let printableComponents  = [levelString, fileName, functionName, lineString, messageSeparator, message]
    let printableInformation = join(" ", printableComponents)
    
    println(printableInformation)
}

/* Checking iOS version */
enum iOSVersion: String {
    case iOS7 = "7.1"
    case iOS8 = "8.0"
}

func osVersion(version: iOSVersion, block: (()->Void)) {
    osVersion(version, true, block)
}

func osVersion(version: iOSVersion, allowLaterVersions: Bool, block: (()->Void)) {
    switch UIDevice.currentDevice().systemVersion.compare(version.rawValue, options: NSStringCompareOptions.NumericSearch) {
    case .OrderedDescending:
        //iOS version > version
        if allowLaterVersions { block() }
    case .OrderedSame:
        //iOS version = version
        block()
    case .OrderedAscending:
        //iOS version < version
        break
    }
}