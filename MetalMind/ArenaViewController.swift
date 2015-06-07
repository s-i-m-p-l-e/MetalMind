//
//  Arena.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/18/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit

class ArenaViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var battleButton: UIButton! {
        didSet {
            battleButton.layer.borderWidth = 2.0
            battleButton.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    // MARK: - IBActions
    @IBAction func practiceActionButton(sender: UIButton) {
        
        var error = NSError()
        var jsonData = NSJSONSerialization.dataWithJSONObject(Builder.toRandomDictionary(), options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)
        println(jsonString!)
    }
}
