//
//  CountryView.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 10/10/25.
//

import SwiftUI

struct CountryView: View {
    @State private var allCities: [CSVData] = []
    @State private var groupedCities: [String: [CSVData]] = [:]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    ForEach(countryKeys, id: \.self) { country in
                        if let cities = groupedCities[country] {
                            CountrySectionView(country: country, cities: cities)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
        }
        .onAppear {
            loadCities()
        }
    }
    
    private var countryKeys: [String] {
        groupedCities.keys.sorted()
    }
    
    private func loadCities() {
        // Cargar todas las ciudades desde el CSV
        allCities = ModelData.shared.csvData
        groupCitiesByCountry()
    }
    
    private func groupCitiesByCountry() {
        groupedCities = Dictionary(grouping: allCities) { $0.pais }
    }
}

struct CountrySectionView: View {
    let country: String
    let cities: [CSVData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Título del país
            Text(country)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.horizontal, 4)
            
            // Scroll horizontal de ciudades
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(cities) { city in
                        NavigationLink(destination: CityDetailView(csvData: city)) {
                            CountryCityCardView(city: city)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

struct CountryCityCardView: View {
    let city: CSVData
    
    var body: some View {
        VStack(spacing: 12) {
            // Imagen de la ciudad más grande
            Image(cityImageName(for: city.ciudad))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 140)
                .clipped()
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Nombre de la ciudad
            Text(city.ciudad)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 180)
        }
    }
    
    private func cityImageName(for cityName: String) -> String {
        // Para el home, usar imágenes de ciudades (no estadios)
        switch cityName.lowercased() {
        case "ciudad de méxico", "mexico city":
            return "Mexico"
        case "monterrey":
            return "Monterrey"
        case "guadalajara":
            return "Guadalajara"
        case "seattle":
            return "Seattle"
        case "san francisco", "santa clara":
            return "San Francisco"
        case "los angeles", "los ángeles":
            return "Los Angeles"
        case "houston":
            return "Houston"
        case "dallas", "arlington":
            return "Dallas"
        case "kansas city":
            return "KansasCity"
        case "vancouver":
            return "Vancouver"
        case "toronto":
            return "Toronto"
        default:
            return "Mexico" // Imagen por defecto
        }
    }
}

#Preview {
    CountryView()
}
