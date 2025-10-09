//
//  HomeView.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    Text("Destinos Disponibles")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ForEach(modelData.csvData) { city in
                        NavigationLink(destination: CityView(csvData: city)) {
                            CityCardView(csvData: city)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Trip Planner")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CityCardView: View {
    let csvData: CSVData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(csvData.ciudad)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(csvData.pais)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("Estadio: \(csvData.estadio)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack {
                    Text("Clima")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(csvData.clima)°C")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            
            Text(csvData.descripcionCiudad)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
        .environment(ModelData.shared)
}
