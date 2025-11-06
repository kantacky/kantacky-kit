//
//  CameraView.swift
//  LiveCapture
//
//  Created by Kanta Oikawa on 2025/11/06.
//

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
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .clipped()
        } else {
            Text("No Image")
        }
    }
}

#Preview {
    CameraView()
}
