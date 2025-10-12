//
//  CityView.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 09/10/25.
//

import SwiftUI

struct CityView: View {
    let csvData: CSVData
    @State private var planner: ItineraryPlanner?
    @State private var isGenerating = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Solo mostrar header si no se está generando ni hay itinerario
                if !isGenerating && planner == nil {
                    // Header con imagen de la ciudad
                    VStack(alignment: .leading, spacing: 8) {
                        Text(csvData.ciudad)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(csvData.pais)
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        
                        Text(csvData.descripcionCiudad)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    
                    // Botón para crear itinerario
                    Button(action: {
                        createItinerary()
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Crear Itinerario")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.glass)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                
                // Mostrar itinerario en la misma vista
                if let planner = planner {
                    ItineraryContentView(planner: planner, csvData: csvData, isGenerating: $isGenerating)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 20)
        }
        .navigationTitle("Destino")
        .navigationBarTitleDisplayMode(.inline)
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
                // Manejar violaciones de guardrail específicamente
                print("Detalles del error: \(error.localizedDescription)")
            }
            isGenerating = false
        }
    }
}

struct ItineraryContentView: View {
    let planner: ItineraryPlanner
    let csvData: CSVData
    @Binding var isGenerating: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Siempre mostrar el itinerario, con indicadores de progreso
            VStack(alignment: .leading, spacing: 24) {
                // Indicador de progreso en la parte superior
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
                        
                        // Indicadores específicos para cada componente
                        VStack(spacing: 8) {
                            // Solo mostrar si no está completado
                            if !(planner.titulo != nil && planner.descripcion != nil) {
                                SearchStatusView(
                                    title: "Buscando título y descripción...",
                                    isCompleted: planner.titulo != nil && planner.descripcion != nil,
                                    isGenerating: planner.titulo == nil && planner.descripcion == nil && isGenerating
                                )
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                            }
                            
                            // Solo mostrar si no está completado
                            if planner.tituloMapa == nil {
                                SearchStatusView(
                                    title: "Buscando información del mapa...",
                                    isCompleted: planner.tituloMapa != nil,
                                    isGenerating: planner.tituloMapa == nil && planner.titulo != nil && isGenerating
                                )
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                            }
                            
                            // Solo mostrar si no está completado
                            if !(planner.lugar1 != nil && planner.lugar2 != nil && planner.descripcionLugar1 != nil && planner.descripcionLugar2 != nil) {
                                SearchStatusView(
                                    title: "Generando descripciones de lugares...",
                                    isCompleted: planner.lugar1 != nil && planner.lugar2 != nil && planner.descripcionLugar1 != nil && planner.descripcionLugar2 != nil,
                                    isGenerating: planner.descripcionLugar1 == nil && planner.tituloMapa != nil && isGenerating
                                )
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                            }
                            
                            // Solo mostrar si no está completado
                            if !(planner.actividad != nil && planner.descripcionActividad != nil) {
                                SearchStatusView(
                                    title: "Generando descripción de actividad...",
                                    isCompleted: planner.actividad != nil && planner.descripcionActividad != nil,
                                    isGenerating: planner.descripcionActividad == nil && planner.lugar1 != nil && isGenerating
                                )
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                            }
                        }
                        .animation(.easeInOut(duration: 0.5), value: planner.titulo)
                        .animation(.easeInOut(duration: 0.5), value: planner.descripcion)
                        .animation(.easeInOut(duration: 0.5), value: planner.tituloMapa)
                        .animation(.easeInOut(duration: 0.5), value: planner.lugar1)
                        .animation(.easeInOut(duration: 0.5), value: planner.lugar2)
                        .animation(.easeInOut(duration: 0.5), value: planner.descripcionLugar1)
                        .animation(.easeInOut(duration: 0.5), value: planner.descripcionLugar2)
                        .animation(.easeInOut(duration: 0.5), value: planner.actividad)
                        .animation(.easeInOut(duration: 0.5), value: planner.descripcionActividad)
                    }
                    .padding(.bottom, 16)
                }
                
                // Header del itinerario - se muestra progresivamente
                VStack(alignment: .leading, spacing: 16) {
                    if let titulo = planner.titulo {
                        Text(titulo)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .contentTransition(.opacity)
                    } else if isGenerating {
                        // Placeholder mientras se genera el título
                        Text("Cargando título...")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .opacity(0.6)
                    }
                    
                    if let descripcion = planner.descripcion {
                        Text(descripcion)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .lineLimit(nil)
                            .contentTransition(.opacity)
                    } else if isGenerating {
                        // Placeholder mientras se genera la descripción
                        Text("Preparando descripción...")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .opacity(0.6)
                    }
                }
                .padding(.bottom, 8)
                
                // Razón destacada con estilo de tarjeta
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
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                    .contentTransition(.opacity)
                }
                
                // Mapa con estilo de tarjeta
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
                
                // Lugares recomendados con estilo de tarjeta
                if let lugar1 = planner.lugar1,
                   let rating1 = planner.rating1 {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Lugares Recomendados")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            // Card Lugar 1
                            PlaceCardView(
                                lugar: lugar1,
                                descripcion: planner.descripcionLugar1,
                                rating: rating1,
                                color: .blue,
                                icon: "paperplane.fill"
                            )
                            .contentTransition(.opacity)
                            
                            // Card Lugar 2
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
                
                // Actividad especial con estilo de tarjeta
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
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        )
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

// Componente para mostrar el estado de búsqueda como en las imágenes
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
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .opacity(isCompleted ? 0.7 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isCompleted)
        .animation(.easeInOut(duration: 0.3), value: isGenerating)
    }
}

// Componente para las cards de lugares
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
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}
