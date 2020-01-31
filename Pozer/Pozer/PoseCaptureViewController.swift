//
//  ViewController.swift
//  Pozer
//
//  Created by AP Raman Kananovich on 1/29/20.
//  Copyright © 2020 AP Raman Kananovich. All rights reserved.
//

import UIKit
//import SceneKit
import RealityKit
import ARKit
import PhotosUI
import Combine


class PoseCaptureViewController: UIViewController, ARSessionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet var arView: ARView!
    
    @IBOutlet weak var magicButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    var character: BodyTrackedEntity?
    var staticCharacter: ModelEntity?
    let characterOffset: SIMD3<Float> = [0.0, 0, 0] // Offset the character by one meter to the left
    let staticCharacterOffset: SIMD3<Float> = [0, 0, 0]
    let characterAnchor = AnchorEntity()
    let staticCharacterAnchor = AnchorEntity()
    
    var falseMaterial = SimpleMaterial()
    var trueMaterial = SimpleMaterial()
    
    var shouldOutput: Bool = false
    var shouldDebugOutput: Bool = true
    
    let allowedDelta: Float = 0.1
    
    var floatArray:Array<Array<Array<Float>>> = Array<Array<Array<Float>>>.init()
    
    func loadTransformsForPose() -> [Transform] {
        
        var transforms:Array<Transform> = Array<Transform>.init()
        
        let fileUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "pose", ofType: "data")!)
        let matricesArray:Array<Array<Array<Float>>> = NSArray(contentsOf: fileUrl) as! [[[Float]]]
        for matrix in matricesArray {
            if let tranformMatrix = Transform.init(array: matrix) {
                transforms.append(tranformMatrix)
            }
        }
        
        return transforms
    }
    
    var staticTransforms:Array<Transform>! = nil
    
    //    var currentTransform: simd_float4x4 = simd_float4x4()
    
    
    
    func session(_ session: ARSession,didAdd anchors: [ARAnchor]){
        print("added ", anchors)
        //        let body = anchors.last as! ARBodyAnchor
        //        let skeleton =  body.skeleton
        //        skeleton.jointModelTransforms
        
    }
    
    @IBAction func grabAction(_ sender: Any) {
        
        //        shouldOutput = true
        shouldDebugOutput = true
        //        var counter = 0
        //        if let staticTransforms = staticCharacter?.jointTransforms, let currentTransforms = character?.jointTransforms {
        //            for index in 0...(staticTransforms.count - 1) {
        //                let staticTransform = staticTransforms[index]
        //                let currentTransform = currentTransforms[index]
        //                let deltaX = abs(staticTransform.translation.x - currentTransform.translation.x)
        //                let deltaY = abs(staticTransform.translation.y - currentTransform.translation.y)
        //                let deltaZ = abs(staticTransform.translation.z - currentTransform.translation.z)
        //                print(String(format: "Translation: %.6f | %.6f | %.6f", currentTransform.translation.x, staticTransform.translation.x, deltaX))
        //                if deltaX < allowedDelta, deltaY < allowedDelta, deltaZ < allowedDelta {
        ////                    print("Not equal ", index)
        //                    counter += 1
        //                }
        //            }
        //
        //            print("Not eaual ", counter);
        //        }
    }
    
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            characterAnchor.position = bodyPosition + characterOffset
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
            
            if let character = character, character.parent == nil {
                characterAnchor.addChild(character)
            }
            
            if let staticCharacter = staticCharacter, staticCharacter.parent == nil {
                characterAnchor.addChild(staticCharacter)
            }
            
            if let staticCharacter = staticCharacter, staticCharacter.parent != nil, !staticCharacter.jointTransforms.isEmpty {
                if shouldOutput == true {
                    shouldOutput = false
                    if let staticTransforms: [Transform] = staticCharacter.jointTransforms, let currentTransforms: [simd_float4x4] = bodyAnchor.skeleton.jointModelTransforms {
                        for index in 0...(staticTransforms.count - 1) {
                            let staticTransform = staticTransforms[index]
                            let currentTransform = Transform(matrix: currentTransforms[index])
                            let deltaX = abs(staticTransform.translation.x - currentTransform.translation.x)
                            let deltaY = abs(staticTransform.translation.y - currentTransform.translation.y)
                            let deltaZ = abs(staticTransform.translation.z - currentTransform.translation.z)
                            print(String(format: "Translation: %.6f | %.6f | %.6f", currentTransform.translation.x, staticTransform.translation.x, deltaX))
                            if deltaX < allowedDelta, deltaY < allowedDelta, deltaZ < allowedDelta {
                                //                    print("Not equal ", index)
                                //                            counter += 1
                            }
                            
                            let matrix = currentTransforms[index]
                            
                            var matrixArray: Array<Array<Float>> = Array<Array<Float>>.init()
                            var simdArray0: Array<Float> = Array<Float>.init()
                            simdArray0.append(matrix.columns.0.x)
                            simdArray0.append(matrix.columns.0.y)
                            simdArray0.append(matrix.columns.0.z)
                            simdArray0.append(matrix.columns.0.w)
                            matrixArray.append(simdArray0)
                            
                            var simdArray1: Array<Float> = Array<Float>.init()
                            simdArray1.append(matrix.columns.1.x)
                            simdArray1.append(matrix.columns.1.y)
                            simdArray1.append(matrix.columns.1.z)
                            simdArray1.append(matrix.columns.1.w)
                            matrixArray.append(simdArray1)
                            
                            var simdArray2: Array<Float> = Array<Float>.init()
                            simdArray2.append(matrix.columns.2.x)
                            simdArray2.append(matrix.columns.2.y)
                            simdArray2.append(matrix.columns.2.z)
                            simdArray2.append(matrix.columns.2.w)
                            matrixArray.append(simdArray2)
                            
                            var simdArray3: Array<Float> = Array<Float>.init()
                            simdArray3.append(matrix.columns.3.x)
                            simdArray3.append(matrix.columns.3.y)
                            simdArray3.append(matrix.columns.3.z)
                            simdArray3.append(matrix.columns.3.w)
                            matrixArray.append(simdArray3)
                            
                            floatArray.append(matrixArray)
                        }
                        
                        saveArray()
                        
                        let testTransform:Transform = Transform.init(array: floatArray[90])!
                        print(testTransform)
                        let testTransform2 = Transform(matrix: currentTransforms[90])
                        print(testTransform2)
                        //                    print("Not eaual ", counter);
                    }
                } else if shouldDebugOutput {
                    //                    shouldDebugOutput = false
                    var maxDelta:Float = 0.0
                    let currentTransforms: [simd_float4x4] = bodyAnchor.skeleton.jointModelTransforms
                    for index in 0...(staticTransforms.count - 1) {
                        let currentTransform: Transform = Transform(matrix: currentTransforms[index])
                        let deltaX = abs(staticTransforms[index].translation.x - currentTransform.translation.x)
                        maxDelta = max(maxDelta, deltaX)
                        //                        let deltaY = abs(staticTransforms[index].translation.y - currentTransform.translation.y)
                        //                        let deltaZ = abs(staticTransforms[index].translation.z - currentTransform.translation.z)
                        //                        print(String(format: "Translation: %.6f | %.6f | %.6f", currentTransform.translation.x, staticTransforms[index].translation.x, deltaX))
                    }
                    
                    if(maxDelta < 0.08) {
                        self.staticCharacter?.model?.materials = [trueMaterial]
                    } else {
                        self.staticCharacter?.model?.materials = [falseMaterial]
                    }
                    
                    print(maxDelta)
                }
            }
        }
    }
    
    func saveArray() {
        let fUrl = getPoseFileDirectory()
        
        // Save to file
        (floatArray as NSArray).write(to: fUrl, atomically: true)
        
        // Read from file
        let savedArray = NSArray(contentsOf: fUrl) as! [[[Float]]]
        
        print(savedArray)
    }
    
    func getPoseFileDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("pose.data")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
//        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        
        staticTransforms = loadTransformsForPose()
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        
        //        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentation) else {
        //            fatalError("People occlusion is not supported on this device.")
        //        }
        
        falseMaterial.baseColor = MaterialColorParameter.color(.red)
        falseMaterial.metallic = MaterialScalarParameter(floatLiteral: 0.9)
        falseMaterial.roughness = MaterialScalarParameter(floatLiteral: 0.1)
        falseMaterial.tintColor = .red
        
        trueMaterial.baseColor = MaterialColorParameter.color(.green)
        trueMaterial.metallic = MaterialScalarParameter(floatLiteral: 0.9)
        trueMaterial.roughness = MaterialScalarParameter(floatLiteral: 0.1)
        trueMaterial.tintColor = .green
        
        
        let configuration = ARBodyTrackingConfiguration()
        
        arView.session.run(configuration)
        
        arView.scene.addAnchor(characterAnchor)
        //        arView.scene.addAnchor(staticCharacterAnchor)
        
        // Asynchronously load the 3D character.
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                character.scale = [1.0, 1.0, 1.0]
                self.character = character
                //                self.character?.model?.materials = [self.falseMaterial]
                self.character?.isEnabled = false
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
        
        var cancellable2: AnyCancellable? = nil
        cancellable2 = Entity.loadModelAsync(named: "character/robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load static model: \(error.localizedDescription)")
                }
                cancellable2?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? ModelEntity {
                character.scale = [1.0, 1.0, 1.0]
                self.staticCharacter = character
                self.staticCharacter?.isEnabled = true
                self.staticCharacter?.model?.materials = [self.falseMaterial]
                cancellable2?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
        
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    

    
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
