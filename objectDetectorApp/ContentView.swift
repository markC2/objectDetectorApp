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
    @State private var detectedObjects = [DetectedObject]()
    
    var body: some View {
        ZStack {
            CameraPreviewView(previewLayer: cameraManager.previewLayer)
                .ignoresSafeArea(.all)
        }
        .onAppear{
            cameraManager.start()
        }
        
        .onReceive(NotificationCenter.default.publisher(for: .detectedObjectsUpdated)) { note in
            guard let objects = note.object as? [DetectedObject] else { return
            }
            guard let layer = cameraManager.previewLayer else{
                return
            }
            
            let mapped = objects.map { obj -> DetectedObject in
                var r = obj.boundingBox
                r.origin.y = 1 - r.origin.y - r.size.height
                let layerRect = layer.layerRectConverted(fromMetadataOutputRect: r)
                
                return DetectedObject(label: obj.label, confidence: obj.confidence, boundingBox: layerRect)
            }
            
            self.detectedObjects = mapped
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
