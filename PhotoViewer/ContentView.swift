//
//  ContentView.swift
//  PhotoViewer
//
//  Created by G Zhen on 7/25/22.
//

import SwiftUI
import Photos

struct ContentView: View {
    @State private var images: [UIImage] = []
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(images, id: \.self) { uiImage in
                    Image(uiImage: uiImage)
                        .resizable()
                        .cornerRadius(10)
                        .frame(width: 300, height: 300, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 8)
                }
            }
        }
        .padding()
        .onAppear {
            populatePhotos()
        }
    }
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .authorized:
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { imageObject, _, _ in
                    if let image = convertImage(imageObject) {
                        self.images.append(image)
                    }
                }
            case .limited:
                let limitedAssets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                limitedAssets.enumerateObjects { imageObject, _, _ in
                    if let image = convertImage(imageObject) {
                        self.images.append(image)
                    }
                }
            default:
                break
            }
        }
    }
    
    private func convertImage(_ image: PHAsset) -> UIImage? {
        var returnedImage: UIImage?
        
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.resizeMode = .none
        option.deliveryMode = .highQualityFormat
        option.isSynchronous = true
        
        imageManager.requestImage(for: image, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option) { image, _ in
            returnedImage = image
        }
        
        return returnedImage
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
