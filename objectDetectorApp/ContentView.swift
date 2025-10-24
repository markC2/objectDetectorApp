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

struct BoundingBoxView: View{
    let object: DetectedObject
    
    var body: some View{
        Rectangle()
            .stroke(Color.green, lineWidth: 2)
            .frame(width: object.boundingBox.width,
                   height: object.boundingBox.height)
            .position(x:object.boundingBox.midX, y: object.boundingBox.midY)
            .overlay(
                Text("\(object.label) (\(Int(object.confidence*100))%")
                    .padding(4)
                    .background(Color.green.opacity(0.5))
                    .foregroundColor(.white)
                    .font(.caption)
            )
    }
}

#Preview {
    ContentView()
}
