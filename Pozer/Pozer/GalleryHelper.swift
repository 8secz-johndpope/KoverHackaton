import Foundation
import Photos
import UIKit
@objc
class Fetcher: NSObject,  PHPhotoLibraryChangeObserver {
    private var imageManager = PHCachingImageManager()
    private var fetchResult: PHFetchResult<PHAsset>!

    override init() {
        let options = PHFetchOptions()
        options.sortDescriptors = [ NSSortDescriptor(key: "modificationDate", ascending: true) ] // or "creationDate"
        self.fetchResult = PHAsset.fetchAssets(with: .image, options: options)
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Photos may call this method on a background queue; switch to the main queue to update the UI.
        DispatchQueue.main.async { [weak self]  in
            guard let sSelf = self else { return }
            if let changeDetails = changeInstance.changeDetails(for: sSelf.fetchResult) {
                let updateBlock = { () -> Void in
                    self?.fetchResult = changeDetails.fetchResultAfterChanges
                }
            }
        }
    }

    func requestLastCreateImage(targetSize:CGSize,  completion: @escaping (UIImage) -> Void) -> Int32 {
        let asset  = self.fetchResult.lastObject
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        return self.imageManager.requestImage(for: asset!, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, info) in
            if let image = image {
                completion(image)
            }
        }
    }

    func requestPreviewImageAtIndex(index: Int, targetSize: CGSize, completion:@escaping (UIImage) -> Void) -> Int32 {
        assert(index >= 0 && index < self.fetchResult.count, "Index out of bounds")
        let asset = self.fetchResult[index]
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        return self.imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, info) in
            if let image = image {
                completion(image)
            }
        }
    }

    func requestFullImageAtIndex(index: Int, completion:@escaping (UIImage) -> Void) {
        assert(index >= 0 && index < self.fetchResult.count, "Index out of bounds")
        let asset = self.fetchResult[index]
        self.imageManager.requestImageData(for: asset, options: .none) { (data, dataUTI, orientation, info) -> Void in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            }
        }
    }
}
