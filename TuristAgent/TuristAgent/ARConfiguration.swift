//
//  ARConfiguration.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI
import ARKit

struct ARConfiguration {
    
    /// Configuración recomendada para ARKit 2 Image Tracking
    static func getImageTrackingConfiguration() -> ARImageTrackingConfiguration {
        let configuration = ARImageTrackingConfiguration()
        
        // Load reference images from AR Resource Group
        if let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) {
            configuration.trackingImages = referenceImages
            configuration.maximumNumberOfTrackedImages = 1 // Track only one image at a time for stability
            
            print("✅ ARKit 2 - Imágenes de referencia cargadas: \(referenceImages.count)")
            for image in referenceImages {
                let size = image.physicalSize
                print("  - \(image.name ?? "Unknown"): \(String(format: "%.3f", size.width))m x \(String(format: "%.3f", size.height))m")
            }
        } else {
            print("❌ No se pudieron cargar las imágenes de referencia del grupo 'AR Resources'")
        }
        
        return configuration
    }
    
    /// Verifica si ARKit está disponible en el dispositivo
    static func isARKitAvailable() -> Bool {
        return ARImageTrackingConfiguration.isSupported
    }
    
    /// Verifica si las imágenes de referencia están disponibles
    static func areReferenceImagesAvailable() -> Bool {
        return ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) != nil
    }
    
    /// Lista todas las imágenes de referencia disponibles
    static func listReferenceImages() -> [String] {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            return []
        }
        
        return referenceImages.map { $0.name ?? "Unknown" }
    }
}

#Preview {
    VStack {
        Text("ARKit Available: \(ARConfiguration.isARKitAvailable())")
        Text("Reference Images Available: \(ARConfiguration.areReferenceImagesAvailable())")
        Text("Images: \(ARConfiguration.listReferenceImages().joined(separator: ", "))")
    }
    .padding()
}
