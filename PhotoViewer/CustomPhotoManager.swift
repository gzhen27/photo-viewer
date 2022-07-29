//
//  CustomPhotoManager.swift
//  PhotoViewer
//
//  Created by G Zhen on 7/28/22.
//

import Foundation
import UIKit
import Photos

class CustomPhotoManager {
    static let shared = CustomPhotoManager()
    
    private let imageManger = PHImageManager.default()
    
    func getPhotoLibraryAuthorization() async {
        await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }
    
    func getAllPhoto() -> [UIImage] {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            return getPhotosFromAssets()
        default:
            return []
        }
    }
    
    private func getPhotosFromAssets() -> [UIImage] {
        var uiImages = [UIImage]()
        
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        assets.enumerateObjects { asset, _, _ in
            if let uiImage = self.getUiImageFrom(asset: asset) {
                uiImages.append(uiImage)
            }
        }
        
        return uiImages
    }
    
    private func getUiImageFrom(asset: PHAsset) -> UIImage? {
        var uiImage: UIImage?
        
        let option = PHImageRequestOptions()
        option.resizeMode = .none
        option.deliveryMode = .highQualityFormat
        option.isSynchronous = true
        
        imageManger.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option) { image, _ in
            uiImage = image
        }
        
        return uiImage
    }
}
