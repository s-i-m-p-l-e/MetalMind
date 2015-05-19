//
//  DoubleExtension.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/18/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import Foundation

extension Double {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    */
    static func random() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /**
    Create a random num Double
    :param: lower number Double
    :param: upper number Double
    :return: random number Double
    By DaRkDOG
    */
    static func random(#min: Double, max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}