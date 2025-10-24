//
//  DetectedObject.swift
//  objectDetectorApp
//
//  Created by Mark Carey on 24/10/2025.
//

import Foundation

import Foundation

struct DetectedObject: Identifiable {
    let id = UUID()
    let label : String
    let confidence: Float
    let boundingBox: CGRect
    
}

