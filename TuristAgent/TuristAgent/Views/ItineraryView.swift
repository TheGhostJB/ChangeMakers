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
                        loadingView
                    } else if let itinerary = planner.itinerary {
                        itineraryContentView(itinerary)
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
            // Solo generar si no hay itinerario ya generado
            if planner.itinerary == nil && !isGenerating {
                isGenerating = true
                Task {
                    do {
                        try await planner.generateItinerary()
                    } catch {
                        print("Error generando itinerario: \(error)")
                    }
                    isGenerating = false
                }
            }
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
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
    }
    
    // MARK: - Itinerary Content View
    private func itineraryContentView(_ itinerary: Itinerario.PartiallyGenerated) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            itineraryTitle(itinerary)
            itineraryDescription(itinerary)
            itineraryReason(itinerary)
            itineraryMap(itinerary)
            itineraryPlaces(itinerary)
            itineraryActivity(itinerary)
        }
        .padding(.horizontal)
        .animation(.easeOut, value: itinerary)
    }
    
    // MARK: - Title Section
    @ViewBuilder
    private func itineraryTitle(_ itinerary: Itinerario.PartiallyGenerated) -> some View {
        if let titulo = itinerary.titulo {
            Text(titulo)
                .font(.largeTitle)
                .fontWeight(.bold)
                .contentTransition(.opacity)
        }
    }
    
    // MARK: - Description Section
    @ViewBuilder
    private func itineraryDescription(_ itinerary: Itinerario.PartiallyGenerated) -> some View {
        if let descripcion = itinerary.descripcion {
            Text(descripcion)
                .font(.body)
                .foregroundStyle(.secondary)
                .contentTransition(.opacity)
        }
    }
    
    // MARK: - Reason Section
    @ViewBuilder
    private func itineraryReason(_ itinerary: Itinerario.PartiallyGenerated) -> some View {
        if let razon = itinerary.razon {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                Text(razon)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }
            .padding()
            .background(.red.opacity(0.1))
            .cornerRadius(12)
            .contentTransition(.opacity)
        }
    }
    
    // MARK: - Map Section
    @ViewBuilder
    private func itineraryMap(_ itinerary: Itinerario.PartiallyGenerated) -> some View {
        if let tituloMapa = itinerary.tituloMapa {
            VStack(alignment: .leading, spacing: 8) {
                Text(tituloMapa)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .contentTransition(.opacity)
                
                mapPlaceholder(itinerary)
            }
        }
    }
    
    private func mapPlaceholder(_ itinerary: Itinerario.PartiallyGenerated) -> some View {
        MapView(
            ciudad: csvData.ciudad,
            pais: csvData.pais,
            lugar1: itinerary.lugar1,
            lugar2: itinerary.lugar2,
            actividad: itinerary.actividad
        )
    }
    
    // MARK: - Places Section
    @ViewBuilder
    private func itineraryPlaces(_ itinerary: Itinerario.PartiallyGenerated) -> some View {
        if let lugar1 = itinerary.lugar1,
           let rating1 = itinerary.rating1 {
            VStack(alignment: .leading, spacing: 12) {
                Text("Lugares Recomendados")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                placeCard(lugar1, itinerary.descripcionLugar1, rating1, color: .blue)
                
                if let lugar2 = itinerary.lugar2,
                   let rating2 = itinerary.rating2 {
                    placeCard(lugar2, itinerary.descripcionLugar2, rating2, color: .green)
                }
            }
        }
    }
    
    private func placeCard(_ lugar: String, _ descripcion: String?, _ rating: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "location.fill")
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lugar)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .contentTransition(.opacity)
                
                        if let descripcion = descripcion {
                            Text(descripcion)
                                .font(.caption)
                                .foregroundStyle(.primary)
                                .lineLimit(nil)
                                .contentTransition(.opacity)
                        }
                
                ratingView(rating)
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func ratingView(_ rating: String) -> some View {
        HStack {
            ForEach(0..<5) { index in
                Image(systemName: index < Int(Double(rating) ?? 0) ? "star.fill" : "star")
                    .foregroundColor(.orange)
                    .font(.caption)
            }
            Text("(\(rating))")
                .font(.caption)
                .foregroundStyle(.primary)
        }
        .contentTransition(.opacity)
    }
    
    // MARK: - Activity Section
    @ViewBuilder
    private func itineraryActivity(_ itinerary: Itinerario.PartiallyGenerated) -> some View {
        if let actividad = itinerary.actividad {
            VStack(alignment: .leading, spacing: 8) {
                Text("Actividad Especial")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.purple)
                        .frame(width: 20)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(actividad)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .contentTransition(.opacity)
                        
                        if let descripcionActividad = itinerary.descripcionActividad {
                            Text(descripcionActividad)
                                .font(.caption)
                                .foregroundStyle(.primary)
                                .lineLimit(nil)
                                .contentTransition(.opacity)
                        }
                    }
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}
