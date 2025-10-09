//
//  CityView.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 09/10/25.
//

import SwiftUI

struct CityView: View {
    let csvData: CSVData
    @State private var showItinerary = false
    @State private var planner: ItineraryPlanner?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                    showItinerary = true
                    planner = ItineraryPlanner(csvData: csvData)
                    planner?.prewarm()
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
            .padding(.top, 20)
        }
        .navigationTitle("Destino")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showItinerary) {
            if let planner = planner {
                ItineraryView(planner: planner, csvData: csvData)
            }
        }
    }
}
