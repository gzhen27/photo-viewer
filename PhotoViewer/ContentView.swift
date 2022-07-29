//
//  ContentView.swift
//  PhotoViewer
//
//  Created by G Zhen on 7/25/22.
//

import SwiftUI

struct ContentView: View {
    @State private var images = [UIImage]()
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(images, id: \.self) { uiImage in
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 160)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .task {
            // request authorization from the Photo LIbrary
            await CustomPhotoManager.shared.getPhotoLibraryAuthorization()
            
            //fetch all photos from the Photo App
            images = CustomPhotoManager.shared.getAllPhoto()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
