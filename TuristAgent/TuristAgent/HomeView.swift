//
//  HomeView.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo blanco
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "mappin.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.blue)
                        .font(.system(size: 60))
                    
                    Text("¡Bienvenido a TuristAgent!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("Tu agente de viajes personal")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        Text("Explora lugares increíbles")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Usa la pestaña 'Scan' para activar la realidad aumentada")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeView()
}
