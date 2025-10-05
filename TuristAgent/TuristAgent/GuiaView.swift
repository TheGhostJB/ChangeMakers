//
//  GuiaView.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI
import AVFoundation
import UIKit

struct GuiaView: View {
    @State private var scannedCode: String?
    @State private var showSuccessMessage = false
    @State private var isScanning = true
    @State private var showingPermissionAlert = false

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
                    
                    Text("SCAN TICKET")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    // Scanning frame
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue, lineWidth: 3)
                            .frame(width: 250, height: 250)
                            .overlay(
                                ScannerCornersOverlay()
                                    .frame(width: 250, height: 250)
                            )
                    }
                    .padding(.bottom, 50)

                    if showSuccessMessage {
                        Text("¡Todo bien!")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
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
