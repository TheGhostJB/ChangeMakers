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
                print("Error generating itinerary: \(error)")
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
        VStack(alignment: .leading, spacing: 16) {
            if isGenerating {
                // Vista de carga
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.largeTitle)
                        .symbolEffect(.breathe, isActive: true)
                    
                    Text("Generando tu itinerario...")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Estamos creando el plan perfecto para \(csvData.ciudad)")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            } else if let itinerary = planner.itinerary {
                // Vista del itinerario generado progresivamente
                VStack(alignment: .leading, spacing: 16) {
                    // Título del itinerario
                    if let titulo = itinerary.titulo {
                        Text(titulo)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .contentTransition(.opacity)
                    }
                    
                    // Descripción
                    if let descripcion = itinerary.descripcion {
                        Text(descripcion)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .contentTransition(.opacity)
                    }
                    
                    // Razón
                    if let razon = itinerary.razon {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text(razon)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(12)
                        .contentTransition(.opacity)
                    }
                    
                    // Mapa con título y clima
                    if let tituloMapa = itinerary.tituloMapa {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(tituloMapa)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .contentTransition(.opacity)
                            
                            // Mapa placeholder
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray.opacity(0.2))
                                .frame(height: 200)
                                .overlay {
                                    VStack {
                                        Image(systemName: "map.fill")
                                            .font(.largeTitle)
                                            .foregroundStyle(.secondary)
                                        Text("Mapa de \(csvData.ciudad)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text("Clima: \(csvData.clima)°C")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                        }
                    }
                    
                    // Lugares recomendados
                    if let lugar1 = itinerary.lugar1,
                       let rating1 = itinerary.rating1 {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Lugares Recomendados")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            // Lugar 1
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(lugar1)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .contentTransition(.opacity)
                                    
                                    HStack {
                                        ForEach(0..<5) { index in
                                            Image(systemName: index < Int(Double(rating1) ?? 0) ? "star.fill" : "star")
                                                .foregroundColor(.yellow)
                                                .font(.caption)
                                        }
                                        Text("(\(rating1))")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .contentTransition(.opacity)
                                }
                            }
                            .padding()
                            .background(.blue.opacity(0.1))
                            .cornerRadius(8)
                            
                            // Lugar 2
                            if let lugar2 = itinerary.lugar2,
                               let rating2 = itinerary.rating2 {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.green)
                                        .frame(width: 20)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(lugar2)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .contentTransition(.opacity)
                                        
                                        HStack {
                                            ForEach(0..<5) { index in
                                                Image(systemName: index < Int(Double(rating2) ?? 0) ? "star.fill" : "star")
                                                    .foregroundColor(.yellow)
                                                    .font(.caption)
                                            }
                                            Text("(\(rating2))")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        .contentTransition(.opacity)
                                    }
                                }
                                .padding()
                                .background(.green.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    // Actividad
                    if let actividad = itinerary.actividad {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Actividad Especial")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                                    .frame(width: 20)
                                
                                Text(actividad)
                                    .font(.subheadline)
                                    .contentTransition(.opacity)
                            }
                            .padding()
                            .background(.orange.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                .animation(.easeOut, value: itinerary)
            }
        }
    }
}
