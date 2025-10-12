//
//  SetupInstructions.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI

struct SetupInstructions: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Project Setup
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🔧 Configuración del Proyecto")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1. Agregar archivos al proyecto Xcode:")
                            Text("   • ARSymbolView.swift")
                            Text("   • ARConfiguration.swift")
                            Text("   • BarcodeScannerView.swift")
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("2. Configurar ARKit.framework:")
                            Text("   • Target → Frameworks, Libraries and Embedded Content")
                            Text("   • Agregar ARKit.framework")
                            Text("   • Configurar como 'Do Not Embed'")
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("3. Configurar permisos de cámara:")
                            Text("   • Target → Info → Custom iOS Target Properties")
                            Text("   • Agregar: NSCameraUsageDescription")
                            Text("   • Valor: 'Esta app necesita acceso a la cámara para escanear códigos y AR'")
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // AR Resources Setup
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📸 Configuración de AR Resources")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1. Imagen de referencia 'cp':")
                            Text("   • Assets.xcassets → AR Resources")
                            Text("   • Agregar imagen 'cp' como AR Reference Image")
                            Text("   • Configurar Physical Width (tamaño real en metros)")
                            Text("   • Ejemplo: 0.1m x 0.1m")
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("2. Imagen overlay 'ss':")
                            Text("   • Assets.xcassets → Agregar imagen 'ss'")
                            Text("   • NO en AR Resources, solo como imagen normal")
                            Text("   • Esta se mostrará cuando se detecte 'cp'")
                        }
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Testing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🧪 Pruebas")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1. Escanear código 'MTY':")
                            Text("   • Usar app de códigos QR para generar 'MTY'")
                            Text("   • Escanear con la app")
                            Text("   • Debe mostrar '¡Todo bien!' y abrir AR")
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("2. Detectar imagen 'cp':")
                            Text("   • Imprimir imagen 'cp' en tamaño real")
                            Text("   • Apuntar cámara hacia la imagen")
                            Text("   • Debe mostrar imagen 'ss' como overlay")
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Troubleshooting
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🔍 Solución de Problemas")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Si no detecta 'cp':")
                            Text("  - Verificar Physical Width en Xcode")
                            Text("  - Asegurar buena iluminación")
                            Text("  - Imagen debe estar nítida y estable")
                            
                            Text("• Si no muestra 'ss':")
                            Text("  - Verificar que 'ss' esté en Assets")
                            Text("  - NO en AR Resources")
                            Text("  - Revisar logs de consola")
                            
                            Text("• Si crashea:")
                            Text("  - Verificar permisos de cámara")
                            Text("  - ARKit.framework configurado correctamente")
                            Text("  - Dispositivo compatible (A9+)")
                        }
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Instrucciones de Configuración")
        }
    }
}

#Preview {
    SetupInstructions()
}
