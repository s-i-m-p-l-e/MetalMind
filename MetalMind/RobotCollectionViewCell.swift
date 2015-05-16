//
//  RobotCollectionCellController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/14/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import SpriteKit

class RobotCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var robotLevelLabel: UILabel!
    @IBOutlet weak var robotHealthLabel: UILabel!
    @IBOutlet weak var robotEnergyLabel: UILabel!
    @IBOutlet weak var robotDefenceLabel: UILabel!
    @IBOutlet weak var robotDamageLabel: UILabel!
    @IBOutlet weak var robotAttackSpeedLabel: UILabel!
    @IBOutlet weak var robotWinsLabel: UILabel!
    @IBOutlet weak var robotLoosesLabel: UILabel!
    
    @IBOutlet weak var animationView: SKView!
    // MARK: - UICollectionViewCell Life-Cycle
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        println("here")
//    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        
//        self.contentView.setNeedsLayout()
//        self.contentView.layoutIfNeeded()
//    }
    
    // MARK: - Public helpers
    // Custom view from the XIB file
//    var view: UIView!
//    
//    func xibSetup() {
//        view = loadViewFromNib()
//        
        // use bounds not frame or it'll be offset
//        view.frame = bounds
//        
        // Make the view stretch with containing view
//        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
//        addSubview(view)
//    }
//    
//    func loadViewFromNib() -> UIView {
//        let bundle = NSBundle(forClass: self.dynamicType)
//        let nib = UINib(nibName: "RobotCollectionViewCell", bundle: bundle)
//        
        // Assumes UIView is top level and only object in CustomView.xib file
//        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
//        return view
//    }
}
