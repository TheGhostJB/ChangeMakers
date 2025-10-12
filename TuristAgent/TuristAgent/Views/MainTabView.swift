//
//  MainTabView.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var showItinerary = false
    @State private var selectedCity: CSVData?
    
    var body: some View {
        TabView {
            CountryView()
                .tabItem {
                    Image(systemName: "mappin.circle")
                    Text("Viaje")
                }
            
            GuiaView()
                .tabItem {
                    Image(systemName: "viewfinder")
                    Text("Escanear")
                }
        }
        .accentColor(.blue)
        .environment(ModelData.shared)
        .onAppear {
            checkForSiriItinerary()
        }
        .sheet(isPresented: $showItinerary) {
            if let city = selectedCity {
                NavigationView {
                    if let planner = ModelData.shared.siriGeneratedPlanner {
                        ItineraryView(planner: planner, csvData: city)
                    } else {
                        ItineraryView(planner: ItineraryPlanner(csvData: city), csvData: city)
                    }
                }
            }
        }
    }
    
    private func checkForSiriItinerary() {
        // Verificar si hay una ciudad seleccionada desde Siri
        if let city = ModelData.shared.selectedCity {
            print("🏠 Ciudad seleccionada desde Siri: \(city.ciudad)")
            selectedCity = city
            showItinerary = true
            
            // Limpiar la selección después de mostrar
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                ModelData.shared.selectedCity = nil
                ModelData.shared.siriGeneratedPlanner = nil
            }
        }
    }
}

#Preview {
    MainTabView()
}
