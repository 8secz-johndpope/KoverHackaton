//
//  PostSplashViewController.swift
//  Pozer
//
//  Created by AP Raman Kananovich on 1/30/20.
//  Copyright © 2020 AP Raman Kananovich. All rights reserved.
//

import UIKit
import Lottie

class PostSplashViewController: UIViewController {

    var animationView:AnimationView!
    
    @IBOutlet weak var rootAnimationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let animation = Animation.named("cover")
        animationView = AnimationView(animation: animation)
        
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.trailingAnchor.constraint(equalTo: rootAnimationView.trailingAnchor),
            animationView.leadingAnchor.constraint(equalTo: rootAnimationView.leadingAnchor),
            animationView.topAnchor.constraint(equalTo: rootAnimationView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: rootAnimationView.bottomAnchor)
        ])
        
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.animationSpeed = 0.8
        animationView.play { (comp) in
            self.performSegue(withIdentifier: "start", sender: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
