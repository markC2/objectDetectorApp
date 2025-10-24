//
//  CameraManager.swift
//  objectDetectorApp
//
//  Created by Mark Carey on 24/10/2025.
//

import AVFoundation
import Combine

class CameraManager: NSObject, ObservableObject{
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    private let session = AVCaptureSession()
    private let videoOuput = AVCaptureVideoDataOutput()
    private let queue = DispatchQueue(label: "camera-queue")
    
    func setupCamera(){
        session.beginConfiguration()
        session.sessionPreset = .high //qaulity of video captured
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else{
            print("no camera")
            session.commitConfiguration()
            return
        }
        do{
            let input = try AVCaptureDeviceInput(device: device)
            if session.inputs.isEmpty, session.canAddInput(input){
                session.addInput(input)
                
                print("camera input added")
                
            } else{
                print("camera input not added")
            }
            
            if session.outputs.isEmpty, session.canAddOutput(videoOuput) {
                videoOuput.alwaysDiscardsLateVideoFrames = true
                videoOuput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA] // setting camera frame output format
                
                session.addOutput(videoOuput)
                videoOuput.setSampleBufferDelegate(self, queue: queue) // deliver frames to camera queue
                print("camera output added ")
                
            } else{
                print("camera could not add output")
            }
            
            if previewLayer == nil {
                let layer = AVCaptureVideoPreviewLayer(session: session)
                layer.videoGravity = .resizeAspectFill
                previewLayer = layer
                print("[Camera] Preview layer created")
            }
        
            
            session.commitConfiguration()
            print("camera session committed")
            
        } catch{
            session.commitConfiguration()
            print("camera device input error\(error)")
        }
        
    }
    
    func start(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            configureAndStart()
            print("started")
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async{
                    if granted {
                        self.configureAndStart()
                    } else{
                        print("camera acess denied")
                    }
                }
            }
            
        default:
            print("no camera permissions")
        }
    }
    
    private func configureAndStart(){
        setupCamera()
        if !session.isRunning{
            queue.async {
                self.session.startRunning()
            }
        }
    }
}


//extend cameraManager to handle camera video output logic
//extracts raw image from sampleBuffer
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate{
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else{
            return
        }
    }
}
