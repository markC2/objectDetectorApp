//
//  BoundingBoxView.swift
//  objectDetectorApp
//
//  Created by Mark Carey on 25/10/2025.
//

import Foundation
import SwiftUI

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
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .offset(y: -object.boundingBox.height/2 - 12)
                    .font(.caption)
            )
    }
}
