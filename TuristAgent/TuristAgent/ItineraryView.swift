//
//  ItineraryView.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 09/10/25.
//

import SwiftUI
import MapKit

struct ItineraryView: View {
    let planner: ItineraryPlanner
    let csvData: CSVData
    @State private var isGenerating = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
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
                        .padding(.top, 100)
                    } else if let itinerary = planner.itinerary {
                        // Vista del itinerario generado
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
                            VStack(alignment: .leading, spacing: 8) {
                                if let tituloMapa = itinerary.tituloMapa {
                                    Text(tituloMapa)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .contentTransition(.opacity)
                                }
                                
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
                            
                            // Lugares recomendados
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Lugares Recomendados")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                // Lugar 1
                                if let lugar1 = itinerary.lugar1 {
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "location.fill")
                                            .foregroundColor(.blue)
                                            .frame(width: 20)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(lugar1)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .contentTransition(.opacity)
                                            
                                            if let rating1 = itinerary.rating1 {
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
                                    }
                                    .padding()
                                    .background(.blue.opacity(0.1))
                                    .cornerRadius(8)
                                }
                                
                                // Lugar 2
                                if let lugar2 = itinerary.lugar2 {
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "location.fill")
                                            .foregroundColor(.green)
                                            .frame(width: 20)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(lugar2)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .contentTransition(.opacity)
                                            
                                            if let rating2 = itinerary.rating2 {
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
                                    }
                                    .padding()
                                    .background(.green.opacity(0.1))
                                    .cornerRadius(8)
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
                        .padding(.horizontal)
                        .animation(.easeOut, value: itinerary)
                    }
                }
            }
            .navigationTitle("Itinerario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if !isGenerating {
                isGenerating = true
                Task {
                    do {
                        try await planner.generateItinerary()
                    } catch {
                        print("Error generating itinerary: \(error)")
                    }
                    isGenerating = false
                }
            }
        }
    }
}
