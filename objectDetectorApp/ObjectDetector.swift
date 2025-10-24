//
//  ObjectDetector.swift
//  objectDetectorApp
//
//  Created by Mark Carey on 24/10/2025.
//

import Foundation
import Vision
import CoreML

class ObjectDetector{
    
    private var requests = [VNRequest]()
    
    init(){
        setupVision()
    }
    
    private func setupVision(){
        guard let modelURL = Bundle.main.url(forResource: "YOLOv8s", withExtension: "mlmodelc") else{
            return
        }
        
        do{
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecogition = VNCoreMLRequest(model: visionModel) { request, error in
                guard let results = request.results as? [VNRecognizedObjectObservation] else{
                    return
                }
                
                self.processResults(results)
            }
            
            requests = [objectRecogition]
        } catch{
            print("vision setup error: \(error.localizedDescription)")
        }
        
    }
    
    func detectObjects(in pixelBuffer: CVPixelBuffer) {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right)
        
        do {
            try handler.perform(requests)
        } catch{
            print("detection error\(error.localizedDescription)")
        }
    }
    
    func processResults(_ results: [VNRecognizedObjectObservation]){
        let detectedObjects = results.map{ observation -> DetectedObject in
            let label = observation.labels.first?.identifier ?? "Unknown"
            let confidence = observation.confidence
            let boundingBox = observation.boundingBox
            
            return DetectedObject(label: label, confidence: confidence, boundingBox: boundingBox)
            
            
            
        }
        
        //after processing update ui via notification
        DispatchQueue.main.async{
            NotificationCenter.default.post(name: .detectedObjectsUpdated, object: detectedObjects)
        }
    }
    
   
}
