//
//  ProjectFilesSummary.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI

struct ProjectFilesSummary: View {
    var body: some View {
        NavigationView {
            List {
                Section("📱 Archivos Principales") {
                    FileRow(name: "ARSymbolView.swift", description: "Vista AR que detecta imagen 'cp' y muestra 'ss'", status: "✅ Creado")
                    FileRow(name: "GuiaView.swift", description: "Vista de escaneo que abre AR al detectar 'MTY'", status: "✅ Actualizado")
                    FileRow(name: "BarcodeScannerView.swift", description: "Escáner de códigos de barras", status: "✅ Existente")
                    FileRow(name: "ScannerCornersOverlay.swift", description: "Overlay visual para el escáner", status: "✅ Creado")
                }
                
                Section("🔧 Archivos de Configuración") {
                    FileRow(name: "ARConfiguration.swift", description: "Configuración y utilidades de ARKit", status: "✅ Creado")
                    FileRow(name: "SetupInstructions.swift", description: "Instrucciones de configuración", status: "✅ Creado")
                }
                
                Section("📋 Archivos Existentes") {
                    FileRow(name: "ContentView.swift", description: "Vista principal con TabView", status: "✅ Existente")
                    FileRow(name: "HomeView.swift", description: "Vista de inicio (Trip)", status: "✅ Existente")
                    FileRow(name: "MainTabView.swift", description: "TabView principal", status: "✅ Existente")
                    FileRow(name: "TuristAgentApp.swift", description: "App principal", status: "✅ Existente")
                }
                
                Section("🎯 Configuración Requerida") {
                    ConfigRow(title: "ARKit.framework", description: "Do Not Embed", status: "⚠️ Requerido")
                    ConfigRow(title: "NSCameraUsageDescription", description: "Permisos de cámara", status: "⚠️ Requerido")
                    ConfigRow(title: "AR Resources", description: "Grupo con imagen 'cp'", status: "⚠️ Requerido")
                    ConfigRow(title: "Imagen 'ss'", description: "En Assets (no AR Resources)", status: "⚠️ Requerido")
                }
            }
            .navigationTitle("Resumen del Proyecto")
        }
    }
}

struct FileRow: View {
    let name: String
    let description: String
    let status: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(status)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(status.contains("✅") ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
}

struct ConfigRow: View {
    let title: String
    let description: String
    let status: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(status)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.2))
                .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProjectFilesSummary()
}
