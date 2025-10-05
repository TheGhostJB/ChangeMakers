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
            HomeView()
                .tabItem {
                    Image(systemName: "mappin.circle")
                    Text("Trip")
                }
            
            GuiaView()
                .tabItem {
                    Image(systemName: "viewfinder")
                    Text("Scan")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
