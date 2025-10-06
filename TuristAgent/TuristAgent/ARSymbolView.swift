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
                            Text("¡Imagen FIFA Detectada!")
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
                            Text("Buscando imagen FIFA...")
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
        
        // ARKit 2 Configuration - ARImageTrackingConfiguration for better image tracking performance
        let configuration = ARImageTrackingConfiguration()
        
        // Load reference images from AR Resource Group
        if let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) {
            configuration.trackingImages = referenceImages
            configuration.maximumNumberOfTrackedImages = 1 // Track only one image at a time for stability
            
            DispatchQueue.main.async {
                self.referenceImagesLoaded = true
            }
            
            print("✅ ARKit 2 - Imágenes de referencia cargadas: \(referenceImages.count)")
            for image in referenceImages {
                let size = image.physicalSize
                print("  - \(image.name ?? "Unknown"): \(String(format: "%.3f", size.width))m x \(String(format: "%.3f", size.height))m")
            }
        } else {
            DispatchQueue.main.async {
                self.referenceImagesLoaded = false
            }
            print("❌ No se pudieron cargar las imágenes de referencia del grupo 'AR Resources'")
        }
        
        // Start AR session
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        // Mark session as started
        DispatchQueue.main.async {
            self.sessionStarted = true
        }
        
        // Optimize AR view settings for 60fps
        arView.antialiasingMode = .multisampling2X
        arView.preferredFramesPerSecond = 60
        
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
    
    class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        var parent: ARViewContainer
        var detectedAnchors: [ARImageAnchor: SCNNode] = [:]
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        // MARK: - ARSCNViewDelegate - Image Detection
        
        /// Called when an ARImageAnchor is detected and added to the scene
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            // Update UI on main thread
            DispatchQueue.main.async {
                self.parent.symbolFound = true
                self.parent.isSearching = false
                self.parent.detectedImageName = imageAnchor.referenceImage.name ?? "Unknown"
                
                // Light haptic feedback on first detection
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }
            
            // Create content node based on detected image
            let contentNode = createContentNode(for: imageAnchor)
            node.addChildNode(contentNode)
            detectedAnchors[imageAnchor] = contentNode
            
            print("✅ ARKit 2 - Imagen detectada: \(imageAnchor.referenceImage.name ?? "Unknown")")
            print("📍 Posición: \(imageAnchor.transform)")
            print("📏 Tamaño físico: \(imageAnchor.referenceImage.physicalSize)")
        }
        
        /// Called when an ARImageAnchor is updated (position, rotation, etc.)
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            // The content automatically follows the anchor
            if detectedAnchors[imageAnchor] != nil {
                print("🔄 ARKit 2 - Imagen actualizada: \(imageAnchor.referenceImage.name ?? "Unknown") - Tracked: \(imageAnchor.isTracked)")
            }
        }
        
        /// Called when an ARImageAnchor is lost/removed from the scene
        func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            // Update UI on main thread
            DispatchQueue.main.async {
                self.parent.symbolFound = false
                self.parent.isSearching = true
            }
            
            // Remove content
            detectedAnchors.removeValue(forKey: imageAnchor)
            
            print("❌ ARKit 2 - Imagen perdida: \(imageAnchor.referenceImage.name ?? "Unknown")")
        }
        
        // MARK: - Helper Methods
        
        /// Creates content node based on the detected image
        /// When "cp" image is detected, show "ss" image overlay
        private func createContentNode(for imageAnchor: ARImageAnchor) -> SCNNode {
            let referenceImage = imageAnchor.referenceImage
            let physicalSize = referenceImage.physicalSize
            let node = SCNNode()
            
            // Create a plane that matches the image dimensions
            let plane = SCNPlane(
                width: CGFloat(physicalSize.width),
                height: CGFloat(physicalSize.height)
            )
            
            // Check if this is the "cp" image (FIFA image)
            if referenceImage.name == "cp" {
                // Load and display the "ss" image when "cp" is detected
                if let ssImage = UIImage(named: "ss") {
                    plane.firstMaterial?.diffuse.contents = ssImage
                    print("✅ Mostrando imagen 'ss' sobre 'cp' detectada")
                } else {
                    // Fallback: show a blue overlay if "ss" image is not found
                    plane.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.7)
                    print("⚠️ Imagen 'ss' no encontrada, mostrando overlay azul")
                }
            } else {
                // For other images, show a simple overlay
                plane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.7)
                print("✅ Mostrando overlay verde para imagen: \(referenceImage.name ?? "Unknown")")
            }
            
            let planeNode = SCNNode(geometry: plane)
            
            // Rotate the plane to match the anchor (lay flat on the image)
            planeNode.eulerAngles.x = -.pi
            
            // Position slightly above the image to avoid z-fighting
            planeNode.position = SCNVector3(0, 0.001, 0)
            
            // Add plane node to parent
            node.addChildNode(planeNode)
            
            return node
        }
    }
}

#Preview {
    ARSymbolView()
}