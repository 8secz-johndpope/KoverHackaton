//
//  CollectionViewCell.swift
//  Pozer
//
//  Created by AP Raman Kananovich on 1/30/20.
//  Copyright © 2020 AP Raman Kananovich. All rights reserved.
//

import UIKit

enum Availability {
    case avalible
    case paid
}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var paidView: UIImageView!
    
    @IBOutlet weak var poseImage: UIImageView!
    
    func setUP(pose:Pose) {
        poseImage.image = pose.image
        switch pose.paid {
        case true:
            self.shadowView.isHidden = false
            self.paidView.isHidden = false
        case false:
            self.shadowView.isHidden = true
            self.paidView.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 25        
    }
    

}
