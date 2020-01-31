//
//  Pose.swift
//  Pozer
//
//  Created by AP Raman Kananovich on 1/30/20.
//  Copyright © 2020 AP Raman Kananovich. All rights reserved.
//

import UIKit



struct Pose {
    let image: UIImage
    var paid:Bool = true
    

    
    static func dataSource() -> ([Pose]){
        var poses = [Pose]()
        for i in 0...9{
            var pose = Pose(image: UIImage(named: "\(i)")!)
            if i == 0 {
                pose.paid = false
            }
            poses.append( pose)
        }
        return poses
    }
}
