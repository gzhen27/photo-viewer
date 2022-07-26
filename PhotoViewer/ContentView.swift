//
//  ContentView.swift
//  PhotoViewer
//
//  Created by G Zhen on 7/25/22.
//

import SwiftUI
import Photos

struct ContentView: View {
    @State private var images: [PHAsset] = []
    
    var body: some View {
        VStack {
            Text("Photo Viewer")
                .padding()
        }
        .onAppear {
            populatePhotos()
        }
    }
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .authorized:
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (imageObject, _, _) in
                    self.images.append(imageObject)
                }
            default:
                break
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
