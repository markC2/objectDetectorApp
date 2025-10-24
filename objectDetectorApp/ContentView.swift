//
//  ContentView.swift
//  objectDetectorApp
//
//  Created by Mark Carey on 24/10/2025.
//

import SwiftUI
import AVFoundation
struct ContentView: View {
    @StateObject private var cameraManager = CameraManager()
    var body: some View {
        
        ZStack {
            
            CameraPreviewView(previewLayer: cameraManager.previewLayer)
                .ignoresSafeArea(.all)
            
        
        }
        .padding()
        .onAppear{
            cameraManager.start()
        }
       
    }
        
    
}

struct CameraPreviewView: UIViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer?
    
    func makeUIView(context: Context) -> UIView {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let layer = previewLayer else {
            
            return
        }
        if layer.superlayer !== uiView.layer {
            uiView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            uiView.layer.addSublayer(layer)
            
        }
        layer.frame = uiView.bounds
    }
}

#Preview {
    ContentView()
}
