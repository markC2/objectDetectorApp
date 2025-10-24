//
//  ViewModel.swift
//  objectDetectorApp
//
//  Created by Mark Carey on 24/10/2025.
//

import Foundation
import Combine
import AVFoundation

class ViewModel: ObservableObject{
    
    @Published var detectedObjects = [DetectedObject]()
    var previewLayer: AVCaptureVideoPreviewLayer? { camera.previewLayer }
    
    private let camera = CameraManager()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        subscribeToDetections()
    }
    
    func onAppear(){
        camera.start()
    }
    
    private func subscribeToDetections(){
        NotificationCenter.default.publisher(for: .detectedObjectsUpdated)
            .compactMap{$0.object as? [DetectedObject]}
            .receive(on: RunLoop.main)
            .sink{[weak self] objects in
                self?.mapToScreenAndPublish(objects)
            }
            .store(in: &cancellables)
    }
    
    private func mapToScreenAndPublish(_ objects: [DetectedObject]){
        guard let layer = camera.previewLayer else{
                return
        }
        
        let mapped = objects.map { obj -> DetectedObject in
            var r = obj.boundingBox
            r.origin.y = 1 - r.origin.y - r.size.height
            let rect = layer.layerRectConverted(fromMetadataOutputRect: r)
            
            return DetectedObject(label: obj.label, confidence: obj.confidence, boundingBox: rect)
            
        }
        
        self.detectedObjects = mapped
    }
    
    
    
    
}
