//
//  ViewController.swift
//  Pozer
//
//  Created by AP Raman Kananovich on 1/29/20.
//  Copyright © 2020 AP Raman Kananovich. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import RealityKit
import PhotosUI
import Lottie

class PoseCaptureViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var magicButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //        let scene = SCNScene()
        //        // Create a new scene
        //        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //
        //        // Set the scene to the view
        //        sceneView.scene = scene
        
        imgV.layer.cornerRadius = 10
        
        let status =  PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status{
                case.authorized:
                    self.getLastImage()
                default: break
                }
            }
        case .authorized:
            self.getLastImage()
        default: break
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARBodyTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func session(_ session: ARSession,didAdd anchors: [ARAnchor]){
        print("added")
        let body = anchors.last as! ARBodyAnchor
        let skeleton =  body.skeleton
        skeleton.jointModelTransforms
        
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        let body = anchors.last as! ARBodyAnchor
        let skeleton =  body.skeleton
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @IBAction func magicButtonPushed(_ sender: Any) {
        
        switch self.magicButton.isSelected {
        case true:
            self.magicButton.isSelected = false
        case false:
            self.magicButton.isSelected = true
        }
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func showGallery(_ sender: Any) {
        self.photoLibrary()
    }
    
    func getLastImage(){
        let allPhotosOptions = PHFetchOptions()
        var images: PHFetchResult<PHAsset>!
        
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        images = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotosOptions)
        
        let asset = images.firstObject
        
        PHCachingImageManager().requestImage(for: asset!, targetSize: CGSize(width: 60, height: 75), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            DispatchQueue.main.async {
                self.imgV.image = image
                self.view.layoutIfNeeded()
            }
        })
    }
    
    @IBAction func voiceBtnBushed(_ sender: Any) {
        switch self.voiceBtn.isSelected {
        case true:
            self.voiceBtn.isSelected = false
        case false:
            self.voiceBtn.isSelected = true


        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension Transform {
    init?(array:[[Float]]){
        guard array.count == 4 else {
            return nil
        }
        let first = array[0]
        let second = array[1]
        let third = array[2]
        let fourth = array[3]
        
        guard (first.count == 4 && second.count == 4 && third.count == 4 && fourth.count == 4) else {
            return nil
        }
        
        let column1 = simd_float4(first[0], first[1], first[2], first[3])
        let column2 = simd_float4(second[0], second[1], second[2], second[3])
        let column3 = simd_float4(third[0], third[1], third[2], third[3])
        let column4 = simd_float4(fourth[0], fourth[1], fourth[2], fourth[3])

        let matrix = simd_float4x4(column1, column2, column3, column4)
        self.init(matrix: matrix)
        
    }
}

