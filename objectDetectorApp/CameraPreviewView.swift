//
//  CameraPreviewView.swift
//  objectDetectorApp
//
//  Created by Mark Carey on 25/10/2025.
//

import Foundation
import AVFoundation
import SwiftUI

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
