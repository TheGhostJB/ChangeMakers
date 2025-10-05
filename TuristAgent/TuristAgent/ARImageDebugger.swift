//
//  ARImageDebugger.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI
import ARKit

struct ARImageDebugger: View {
    @State private var referenceImages: [ARReferenceImage] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            List {
                Section("Imágenes de Referencia Cargadas") {
                    if isLoading {
                        HStack {
                            ProgressView()
                            Text("Cargando imágenes...")
                        }
                    } else if referenceImages.isEmpty {
                        Text("❌ No se encontraron imágenes de referencia")
                            .foregroundColor(.red)
                    } else {
                        ForEach(Array(referenceImages.enumerated()), id: \.offset) { index, image in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Imagen \(index + 1)")
                                    .font(.headline)
                                
                                Text("Nombre: \(image.name ?? "Sin nombre")")
                                    .font(.subheadline)
                                
                                Text("Tamaño físico: \(image.physicalSize.width, specifier: "%.3f")m x \(image.physicalSize.height, specifier: "%.3f")m")
                                    .font(.caption)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Section("Configuración Recomendada") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Para mejor detección:")
                            .font(.headline)
                        
                        Text("• Physical Width: 0.1 - 0.5 metros")
                        Text("• Resolución: Mínimo 100x100 píxeles")
                        Text("• Contraste alto entre objeto y fondo")
                        Text("• Imagen nítida y bien iluminada")
                        Text("• Evitar imágenes simétricas o repetitivas")
                    }
                    .font(.caption)
                }
            }
            .navigationTitle("Debug AR Images")
            .onAppear {
                loadReferenceImages()
            }
        }
    }
    
    private func loadReferenceImages() {
        if let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) {
            referenceImages = Array(images)
        }
        isLoading = false
    }
}

#Preview {
    ARImageDebugger()
}
