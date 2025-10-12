//
//  GuiaView.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI
import AVFoundation

struct GuiaView: View {
    @State private var scannedCode: String?
    @State private var showSuccessMessage = false
    @State private var isScanning = true
    @State private var showingPermissionAlert = false
    @State private var showARSymbolView = false

    var body: some View {
        NavigationView {
            ZStack {
                // Camera feed
                if isScanning {
                    BarcodeScannerView { code in
                        self.scannedCode = code
                        if code == "MTY" {
                            self.showSuccessMessage = true
                            self.isScanning = false // Stop scanning on success
                            // Present AR view after a short delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.showARSymbolView = true
                            }
                        } else {
                            self.showSuccessMessage = false
                        }
                    }
                    .ignoresSafeArea(.all)
                } else {
                    Color.black.ignoresSafeArea(.all)
                }

                VStack {
                    Spacer()
                    
                    Text("ESCANEAR BOLETO")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    // Scanning frame
                    Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 220, height: 415)
                    .background(Color(red: 0.04, green: 0, blue: 0))
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                        .inset(by: -2.5)
                        .stroke(.white, lineWidth: 5)
                    )
                    .opacity(0.25)
                    .padding(.bottom, 50)

                    if showSuccessMessage {
                        VStack(spacing: 8) {
                            Text("¡Todo bien!")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                            
                            Text("Abriendo vista AR...")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Capsule().fill(Color.green.opacity(0.2)))
                        .transition(.opacity)
                        .animation(.easeIn, value: showSuccessMessage)
                    } else if let code = scannedCode {
                        Text("Código escaneado: \(code)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            requestCameraPermission()
        }
        .alert(isPresented: $showingPermissionAlert) {
            Alert(
                title: Text("Permiso de Cámara Denegado"),
                message: Text("Por favor, habilita el acceso a la cámara en la configuración de tu dispositivo para usar esta función."),
                primaryButton: .default(Text("Configuración"), action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }),
                secondaryButton: .cancel(Text("Cancelar"))
            )
        }
        .fullScreenCover(isPresented: $showARSymbolView) {
            ARSymbolView()
        }
    }

    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if !granted {
                    self.isScanning = false
                    self.showingPermissionAlert = true
                } else {
                    self.isScanning = true
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        GuiaView()
    }
}