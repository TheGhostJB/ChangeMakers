//
//  CityDetailView.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 10/10/25.
//

import SwiftUI

struct CityDetailView: View {
    let csvData: CSVData
    @State private var planner: ItineraryPlanner?
    @State private var isGenerating = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Imagen de la ciudad
                Image(cityImageName(for: csvData.ciudad))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(
                        // Overlay gradiente para mejorar legibilidad del texto
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.clear,
                                Color.black.opacity(0.3)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Información de la ciudad
                VStack(alignment: .leading, spacing: 16) {
                    // Nombre de la ciudad
                    Text(csvData.ciudad.uppercased())
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Estadio
                    Text(csvData.estadio)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Descripción
                    Text(csvData.descripcionCiudad)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                    
                    // Información adicional
                    HStack(spacing: 20) {
                        InfoChipView(
                            icon: "thermometer",
                            title: "Clima",
                            value: "\(csvData.clima)°C"
                        )
                        
                        InfoChipView(
                            icon: "flag",
                            title: "País",
                            value: csvData.pais
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    
                    // Botón para generar itinerario con estilo Glass
                    if planner == nil {
                        Button(action: {
                            createItinerary()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 18, weight: .medium))
                                    .symbolEffect(.bounce, value: isGenerating)
                                
                                Text("Generar Itinerario")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background {
                                ZStack {
                                      // Material de fondo con efecto glass más oscuro
                                      RoundedRectangle(cornerRadius: 16)
                                         .fill(.thickMaterial.opacity(1))
                                }
                            }
                            .foregroundStyle(.primary)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            .scaleEffect(isGenerating ? 0.98 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: isGenerating)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                    
                    // Itinerario generado
                    if let planner = planner {
                        ItineraryDetailContentView(
                            planner: planner,
                            csvData: csvData,
                            isGenerating: $isGenerating
                        )
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                    
                    // Espaciador inferior
                    Spacer()
                        .frame(height: 100)
                }
                .padding(.horizontal)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Atrás")
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    private func cityImageName(for cityName: String) -> String {
        // Para el itinerario, usar imágenes de estadios
        switch cityName.lowercased() {
        case "ciudad de méxico", "mexico city":
            return "Estadio Mexico"
        case "monterrey":
            return "Estadio monterrey"
        case "guadalajara":
            return "Estadio guadalajara"
        case "seattle":
            return "estadio de seattle"
        case "san francisco", "santa clara":
            return "Estadio san francisco"
        case "los angeles", "los ángeles":
            return "Estadio de los angeles"
        case "houston":
            return "Estadio houston"
        case "dallas", "arlington":
            return "Estadio dallas"
        case "kansas city":
            return "estadio de kansas"
        case "vancouver":
            return "Estadio de vancouver"
        case "toronto":
            return "Estadio toronto"
        default:
            return "Estadio Mexico" // Imagen por defecto
        }
    }
    
    private func createItinerary() {
        isGenerating = true
        planner = ItineraryPlanner(csvData: csvData)
        planner?.prewarm()
        
        Task {
            do {
                try await planner?.generateItinerary()
            } catch {
                print("Error generando itinerario: \(error)")
            }
            isGenerating = false
        }
    }
    
    struct InfoChipView: View {
        let icon: String
        let title: String
        let value: String
        
        var body: some View {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(.blue)
                    .font(.system(size: 16, weight: .medium))
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                    
                    Text(value)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial.opacity(0.6))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.3),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.8
                            )
                    }
            }
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    struct ItineraryDetailContentView: View {
        let planner: ItineraryPlanner
        let csvData: CSVData
        @Binding var isGenerating: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                // Indicador de progreso
                if isGenerating {
                    VStack(spacing: 12) {
                        HStack {
                            Circle()
                                .fill(.blue)
                                .frame(width: 8, height: 8)
                                .symbolEffect(.breathe, isActive: true)
                            
                            Text("Generando itinerario...")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                        }
                        
                        // Indicadores específicos
                        VStack(spacing: 8) {
                            if !(planner.titulo != nil && planner.descripcion != nil) {
                                SearchStatusView(
                                    title: "Generando título y descripción...",
                                    isCompleted: planner.titulo != nil && planner.descripcion != nil,
                                    isGenerating: planner.titulo == nil && planner.descripcion == nil && isGenerating
                                )
                            }
                            
                            if planner.tituloMapa == nil {
                                SearchStatusView(
                                    title: "Generando información del mapa...",
                                    isCompleted: planner.tituloMapa != nil,
                                    isGenerating: planner.tituloMapa == nil && planner.titulo != nil && isGenerating
                                )
                            }
                            
                            if !(planner.lugar1 != nil && planner.lugar2 != nil && planner.descripcionLugar1 != nil && planner.descripcionLugar2 != nil) {
                                SearchStatusView(
                                    title: "Generando lugares recomendados...",
                                    isCompleted: planner.lugar1 != nil && planner.lugar2 != nil && planner.descripcionLugar1 != nil && planner.descripcionLugar2 != nil,
                                    isGenerating: planner.descripcionLugar1 == nil && planner.tituloMapa != nil && isGenerating
                                )
                            }
                            
                            if !(planner.actividad != nil && planner.descripcionActividad != nil) {
                                SearchStatusView(
                                    title: "Generando actividad especial...",
                                    isCompleted: planner.actividad != nil && planner.descripcionActividad != nil,
                                    isGenerating: planner.descripcionActividad == nil && planner.lugar1 != nil && isGenerating
                                )
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
                
                // Contenido del itinerario
                VStack(alignment: .leading, spacing: 16) {
                    // Título y descripción
                    if let titulo = planner.titulo {
                        Text(titulo)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .contentTransition(.opacity)
                    }
                    
                    if let descripcion = planner.descripcion {
                        Text(descripcion)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                            .contentTransition(.opacity)
                    }
                    
                    // Razón
                    if let razon = planner.razon {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 16))
                            
                            Text(razon)
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                                .lineLimit(nil)
                        }
                        .padding(16)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial.opacity(0.6))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    .white.opacity(0.3),
                                                    .clear
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 0.8
                                        )
                                }
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        .contentTransition(.opacity)
                    }
                    
                    // Mapa
                    if let tituloMapa = planner.tituloMapa {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(tituloMapa)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .contentTransition(.opacity)
                            
                            MapView(
                                ciudad: csvData.ciudad,
                                pais: csvData.pais,
                                lugar1: planner.lugar1,
                                lugar2: planner.lugar2,
                                actividad: planner.actividad
                            )
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    
                    // Lugares recomendados
                    if let lugar1 = planner.lugar1,
                       let rating1 = planner.rating1 {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Lugares Recomendados")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 12) {
                                PlaceCardView(
                                    lugar: lugar1,
                                    descripcion: planner.descripcionLugar1,
                                    rating: rating1,
                                    color: .blue,
                                    icon: "paperplane.fill"
                                )
                                .contentTransition(.opacity)
                                
                                if let lugar2 = planner.lugar2,
                                   let rating2 = planner.rating2 {
                                    PlaceCardView(
                                        lugar: lugar2,
                                        descripcion: planner.descripcionLugar2,
                                        rating: rating2,
                                        color: .green,
                                        icon: "paperplane.fill"
                                    )
                                    .contentTransition(.opacity)
                                }
                            }
                        }
                    }
                    
                    // Actividad especial
                    if let actividad = planner.actividad {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Actividad Especial")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 16))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(actividad)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                    if let descripcionActividad = planner.descripcionActividad {
                                        Text(descripcionActividad)
                                            .font(.system(size: 14))
                                            .foregroundColor(.primary)
                                            .lineLimit(nil)
                                            .contentTransition(.opacity)
                                    }
                                }
                            }
                            .padding(16)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial.opacity(0.6))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        .white.opacity(0.3),
                                                        .clear
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 0.8
                                            )
                                    }
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }
                            .contentTransition(.opacity)
                        }
                    }
                }
                .animation(.easeOut(duration: 0.6), value: planner.titulo)
                .animation(.easeOut(duration: 0.6), value: planner.descripcion)
                .animation(.easeOut(duration: 0.6), value: planner.razon)
                .animation(.easeOut(duration: 0.6), value: planner.tituloMapa)
                .animation(.easeOut(duration: 0.6), value: planner.lugar1)
                .animation(.easeOut(duration: 0.6), value: planner.lugar2)
                .animation(.easeOut(duration: 0.6), value: planner.descripcionLugar1)
                .animation(.easeOut(duration: 0.6), value: planner.descripcionLugar2)
                .animation(.easeOut(duration: 0.6), value: planner.actividad)
                .animation(.easeOut(duration: 0.6), value: planner.descripcionActividad)
            }
        }
    }
    
    struct SearchStatusView: View {
        let title: String
        let isCompleted: Bool
        let isGenerating: Bool
        
        var body: some View {
            HStack(spacing: 12) {
                // Icono de lupa como en las imágenes
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
                
                // Texto del estado de búsqueda
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Indicador de progreso sutil
                if isGenerating {
                    HStack(spacing: 3) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(.blue.opacity(0.6))
                                .frame(width: 3, height: 3)
                                .scaleEffect(isGenerating ? 1.0 : 0.5)
                                .animation(
                                    .easeInOut(duration: 0.8)
                                    .repeatForever()
                                    .delay(Double(index) * 0.3),
                                    value: isGenerating
                                )
                        }
                    }
                } else if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12))
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial.opacity(0.6))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.3),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.8
                            )
                    }
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
            .opacity(isCompleted ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: isCompleted)
            .animation(.easeInOut(duration: 0.3), value: isGenerating)
        }
    }
    
    struct PlaceCardView: View {
        let lugar: String
        let descripcion: String?
        let rating: String
        let color: Color
        let icon: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(lugar)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                    
                    if let descripcion = descripcion {
                        Text(descripcion)
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                            .contentTransition(.opacity)
                    }
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(Double(rating) ?? 0) ? "star.fill" : "star")
                                .foregroundColor(.orange)
                                .font(.system(size: 10))
                        }
                        Text("(\(rating))")
                            .font(.system(size: 10))
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial.opacity(0.6))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.3),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.8
                            )
                    }
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
        }
    }
}

#Preview {
    CityDetailView(csvData: CSVData(
        id: 1,
        estadio: "Estadio Azteca",
        ciudad: "Ciudad de México",
        pais: "México",
        lugar1: "La Casa de Toño",
        descripcionLugar1: "Restaurante tradicional",
        ratingLugar1: "4.5",
        horariosLugar1: "08:00-23:00",
        lugar2: "Bosque de Chapultepec",
        descripcionLugar2: "Parque urbano",
        ratingLugar2: "4.7",
        horariosLugar2: "05:00-18:00",
        lugar3: "",
        descripcionLugar3: "",
        ratingLugar3: "",
        horariosLugar3: "",
        lugar4: "",
        descripcionLugar4: "",
        ratingLugar4: "",
        horariosLugar4: "",
        lugar5: "",
        descripcionLugar5: "",
        ratingLugar5: "",
        horariosLugar5: "",
        cosaPorHacer1: "Visita al centro histórico",
        cosaPorHacer2: "Recorrido gastronómico",
        clima: "22"
    ))
}
