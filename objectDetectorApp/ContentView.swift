//
//  ContentView.swift
//  objectDetectorApp
//
//  Created by Mark Carey on 24/10/2025.
//

import SwiftUI
import AVFoundation
struct ContentView: View {
      @StateObject private var vm = DetectionViewModel()
    
    var body: some View {
        ZStack {
            CameraPreviewView(previewLayer: vm.previewLayer)
                .ignoresSafeArea()
            
            ForEach(vm.detectedObjects) { object in
                BoundingBoxView(object: object)
            }
        }
        .onAppear{
            vm.onAppear()
        }
    }
}

#Preview {
    ContentView()
}
