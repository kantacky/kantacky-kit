//
//  CameraView.swift
//  LiveCapture
//
//  Created by Kanta Oikawa on 2025/11/06.
//

import ImageClassification
import SwiftUI

struct CameraView: View {
    @State private var viewModel = CameraViewModel()

    var body: some View {
        content
            .ignoresSafeArea()
            .task {
                await viewModel.onAppear()
            }
    }

    @ViewBuilder
    private var content: some View {
        if let uiImage = viewModel.uiImage {
            VStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                if let vegetable = viewModel.classifiedVegetable,
                   vegetable.confidence > 0.95 {
                    Text(vegetable.identifier)
                        .font(.title)
                        .padding()
                } else {
                    Text("Classifying...")
                        .font(.title)
                        .padding()
                }
            }
        } else {
            Text("No Image")
        }
    }
}

#Preview {
    CameraView()
}
