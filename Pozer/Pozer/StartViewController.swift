//
//  StartViewController.swift
//  Pozer
//
//  Created by AP Raman Kananovich on 1/30/20.
//  Copyright © 2020 AP Raman Kananovich. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let dataSource = Pose.dataSource()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let celll = cell as? CollectionViewCell{
            celll.setUP(pose: dataSource[indexPath.row])
            return celll
        }
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "seq", sender: self)
        } else {
            self.performSegue(withIdentifier: "subs", sender: self)
            
        }
    }
    

}
