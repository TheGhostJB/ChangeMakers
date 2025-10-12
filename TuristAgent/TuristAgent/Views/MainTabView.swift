//
//  MainTabView.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI

struct MainTabView: View {
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
    }
}

#Preview {
    MainTabView()
}
