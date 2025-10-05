//
//  ARSymbolView.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI
import ARKit
import SceneKit

struct ARSymbolView: View {
    @State private var symbolFound = false
    @State private var isSearching = true
    @State private var showRetryButton = false
    @State private var searchTimer: Timer?
    @State private var debugMode = false
    @State private var referenceImagesLoaded = false
    @State private var sessionStarted = false
    @State private var detectedImageName = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // AR View
            ARViewContainer(
                symbolFound: $symbolFound,
                isSearching: $isSearching,
                debugMode: $debugMode,
                referenceImagesLoaded: $referenceImagesLoaded,
                sessionStarted: $sessionStarted,
                detectedImageName: $detectedImageName
            )
            .ignoresSafeArea()
            
            // UI Overlay
            VStack {
                // Top controls
                HStack {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    Button(debugMode ? "Debug ON" : "Debug OFF") {
                        debugMode.toggle()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
                }
                .padding()
                
                Spacer()
                
                // Status message
                VStack(spacing: 16) {
                    if symbolFound {
                        VStack(spacing: 8) {
                            Text("¡Símbolo Detectado!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            
                            if !detectedImageName.isEmpty {
                                Text("Imagen: \(detectedImageName)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                    } else if isSearching {
                        VStack(spacing: 8) {
                            Text("Buscando símbolo...")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            if !referenceImagesLoaded {
                                Text("❌ Imágenes de referencia no cargadas")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            } else if !sessionStarted {
                                Text("⏳ Iniciando sesión AR...")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            } else {
                                Text("✅ Listo para detectar")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                    }
                    
                    if showRetryButton {
                        Button("Reintentar") {
                            resetSearch()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            startSearchTimer()
        }
        .onDisappear {
            stopSearchTimer()
        }
    }
    
    private func startSearchTimer() {
        searchTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { _ in
            if !symbolFound {
                showRetryButton = true
            }
        }
    }
    
    private func stopSearchTimer() {
        searchTimer?.invalidate()
        searchTimer = nil
    }
    
    private func resetSearch() {
        symbolFound = false
        isSearching = true
        showRetryButton = false
        stopSearchTimer()
        startSearchTimer()
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var symbolFound: Bool
    @Binding var isSearching: Bool
    @Binding var debugMode: Bool
    @Binding var referenceImagesLoaded: Bool
    @Binding var sessionStarted: Bool
    @Binding var detectedImageName: String
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        arView.session.delegate = context.coordinator
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        
        // Add image detection
        if let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) {
            configuration.detectionImages = referenceImages
            configuration.maximumNumberOfTrackedImages = 1
            
            DispatchQueue.main.async {
                self.referenceImagesLoaded = true
            }
            
            // Debug: Print all loaded reference images
            print("🔍 Imágenes de referencia cargadas:")
            for image in referenceImages {
                print("  - Nombre: \(image.name ?? "Sin nombre")")
                print("  - Tamaño físico: \(image.physicalSize)")
            }
        } else {
            DispatchQueue.main.async {
                self.referenceImagesLoaded = false
            }
            
            print("❌ No se pudieron cargar las imágenes de referencia del grupo 'AR Resources'")
            print("🔍 Verificando grupos disponibles...")
            
            // Try to find available resource groups
            if let bundle = Bundle.main.path(forResource: "AR Resources", ofType: "arresourcegroup") {
                print("✅ Grupo 'AR Resources' encontrado en: \(bundle)")
            } else {
                print("❌ Grupo 'AR Resources' no encontrado en el bundle")
            }
        }
        
        arView.session.run(configuration)
        
        // Mark session as started
        DispatchQueue.main.async {
            self.sessionStarted = true
        }
        
        // Add coaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = arView.session
        coachingOverlay.delegate = context.coordinator
        arView.addSubview(coachingOverlay)
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: arView.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: arView.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: arView.heightAnchor)
        ])
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Update debug mode
        uiView.showsStatistics = debugMode
        uiView.debugOptions = debugMode ? [.showFeaturePoints, .showWorldOrigin] : []
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate, ARCoachingOverlayViewDelegate {
        var parent: ARViewContainer
        var detectedAnchors: [ARImageAnchor: SCNNode] = [:]
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        // MARK: - ARSCNViewDelegate
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            DispatchQueue.main.async {
                self.parent.symbolFound = true
                self.parent.isSearching = false
                self.parent.detectedImageName = imageAnchor.referenceImage.name ?? "Unknown"
                
                // Haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }
            
            // Create wireframe perimeter
            let wireframeNode = createWireframe(for: imageAnchor)
            node.addChildNode(wireframeNode)
            detectedAnchors[imageAnchor] = wireframeNode
            
            print("✅ Símbolo detectado: \(imageAnchor.referenceImage.name ?? "Unknown")")
            print("📍 Posición del anchor: \(imageAnchor.transform)")
            print("📏 Tamaño físico: \(imageAnchor.referenceImage.physicalSize)")
            print("🎯 Confianza de tracking: \(imageAnchor.isTracked)")
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            // Update wireframe position if needed
            if let wireframeNode = detectedAnchors[imageAnchor] {
                // The wireframe should automatically follow the anchor
                // This is just for any additional updates if needed
                print("🔄 Símbolo actualizado: \(imageAnchor.referenceImage.name ?? "Unknown") - Tracked: \(imageAnchor.isTracked)")
            }
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            DispatchQueue.main.async {
                self.parent.symbolFound = false
                self.parent.isSearching = true
            }
            
            // Remove wireframe
            detectedAnchors.removeValue(forKey: imageAnchor)
            
            print("❌ Símbolo perdido: \(imageAnchor.referenceImage.name ?? "Unknown")")
        }
        
        // MARK: - ARCoachingOverlayViewDelegate
        func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
            print("🎯 Coaching overlay activado")
        }
        
        func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
            print("✅ Coaching overlay desactivado")
        }
        
        func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
            print("🔄 Reset de sesión solicitado")
        }
        
        // MARK: - Helper Methods
        private func createWireframe(for imageAnchor: ARImageAnchor) -> SCNNode {
            let referenceImage = imageAnchor.referenceImage
            let physicalSize = referenceImage.physicalSize
            
            // Create wireframe box
            let wireframe = SCNBox(
                width: CGFloat(physicalSize.width),
                height: CGFloat(physicalSize.height),
                length: 0.001, // Very thin
                chamferRadius: 0
            )
            
            // Create material
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.clear
            material.emission.contents = UIColor.blue
            material.isDoubleSided = true
            
            // Create wireframe material (only edges visible)
            let wireframeMaterial = SCNMaterial()
            wireframeMaterial.diffuse.contents = UIColor.clear
            wireframeMaterial.emission.contents = UIColor.blue
            wireframeMaterial.fillMode = .lines
            
            wireframe.materials = [wireframeMaterial]
            
            let wireframeNode = SCNNode(geometry: wireframe)
            
            // Position the wireframe to match the image
            wireframeNode.position = SCNVector3(0, 0, 0)
            
            // Add subtle animation
            let pulseAction = SCNAction.sequence([
                SCNAction.scale(to: 1.05, duration: 1.0),
                SCNAction.scale(to: 1.0, duration: 1.0)
            ])
            let repeatAction = SCNAction.repeatForever(pulseAction)
            wireframeNode.runAction(repeatAction)
            
            return wireframeNode
        }
    }
}

#Preview {
    ARSymbolView()
}
