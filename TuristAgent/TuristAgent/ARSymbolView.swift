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
        
        /// Creates a 3D arrow node - proper arrow shape with triangular head and rectangular shaft
        private func createArrowNode() -> SCNNode {
            let arrowNode = SCNNode()
            
            // Create arrow shaft (rectangular box) - scale x12 (doubled from x6)
            let shaftGeometry = SCNBox(width: 0.4, height: 8.0, length: 0.2, chamferRadius: 0)
            shaftGeometry.firstMaterial?.diffuse.contents = UIColor.white
            shaftGeometry.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant // Make it more visible
            shaftGeometry.firstMaterial?.emission.contents = UIColor.white // Add emission for better visibility
            let shaftNode = SCNNode(geometry: shaftGeometry)
            shaftNode.position = SCNVector3(0, -1.7, 0) // Position shaft towards the back (doubled)
            arrowNode.addChildNode(shaftNode)
            
            // Create arrow head (triangular pyramid) - scale x12 (doubled from x6)
            let headGeometry = SCNPyramid(width: 1.2, height: 3.4, length: 0.2)
            headGeometry.firstMaterial?.diffuse.contents = UIColor.white
            headGeometry.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant // Make it more visible
            headGeometry.firstMaterial?.emission.contents = UIColor.white // Add emission for better visibility
            let headNode = SCNNode(geometry: headGeometry)
            headNode.position = SCNVector3(0, 1.7, 0) // Position head at the front (doubled)
            arrowNode.addChildNode(headNode)
            
            
            // Rotate arrow 90 degrees on X axis
            arrowNode.eulerAngles.x = Float.pi // Rotate 90 degrees on X axis
            
            // Start the back and forth animation
            startArrowAnimation(arrowNode: arrowNode)
            
            return arrowNode
        }
        
        /// Animates the arrow to move back and forth continuously on Y axis and up/down
        private func startArrowAnimation(arrowNode: SCNNode) {
            // Define the animation distances
            let horizontalDistance: CGFloat = 2.0  // Back and forth movement
            let verticalDistance: CGFloat = 1.0    // Up and down movement
            
            // Create the forward animation (from back to front on Y axis)
            let moveForward = SCNAction.moveBy(x: 0, y: horizontalDistance, z: 0, duration: 0.8)
            moveForward.timingMode = SCNActionTimingMode.easeInEaseOut
            
            // Create the backward animation (from front to back on Y axis)
            let moveBackward = SCNAction.moveBy(x: 0, y: -horizontalDistance, z: 0, duration: 0.8)
            moveBackward.timingMode = SCNActionTimingMode.easeInEaseOut
            
            // Create the up animation (vertical movement)
            let moveUp = SCNAction.moveBy(x: 0, y: 0, z: verticalDistance, duration: 1.6) // Half speed (double duration)
            moveUp.timingMode = SCNActionTimingMode.easeInEaseOut
            
            // Create the down animation (vertical movement)
            let moveDown = SCNAction.moveBy(x: 0, y: 0, z: -verticalDistance, duration: 1.6) // Half speed (double duration)
            moveDown.timingMode = SCNActionTimingMode.easeInEaseOut
            
            // Create sequences for both animations
            let backAndForth = SCNAction.sequence([moveForward, moveBackward])
            let upAndDown = SCNAction.sequence([moveUp, moveDown])
            
            // Repeat both sequences forever
            let repeatHorizontal = SCNAction.repeatForever(backAndForth)
            let repeatVertical = SCNAction.repeatForever(upAndDown)
            
            // Run both animations simultaneously
            let group = SCNAction.group([repeatHorizontal, repeatVertical])
            arrowNode.runAction(group)
        }
        
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
                // Create and position the arrow where the "ss" image was
                let arrowNode = createArrowNode()
                // Position the arrow where the image was (same position as before)
                let slideOffset = Float(physicalSize.width)
                arrowNode.position = SCNVector3(-slideOffset, 0.001, 0)
                node.addChildNode(arrowNode)
                print("✅ Mostrando flecha en lugar de imagen 'ss' sobre 'cp' detectada")
            } else {
                // For other images, show a simple overlay
                plane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.7)
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi
                planeNode.position = SCNVector3(0, 0.001, 0)
                node.addChildNode(planeNode)
                print("✅ Mostrando overlay verde para imagen: \(referenceImage.name ?? "Unknown")")
            }
            
            return node
        }
    }
}

#Preview {
    ARSymbolView()
}