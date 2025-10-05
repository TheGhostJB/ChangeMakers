//
//  GuiaView.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI

struct GuiaView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo blanco
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "viewfinder")
                        .imageScale(.large)
                        .foregroundStyle(.blue)
                        .font(.system(size: 60))
                    
                    Text("Guía AR")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("Explora lugares con realidad aumentada")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        Text("Funcionalidad de escaneo")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Aquí podrás escanear códigos QR y activar la realidad aumentada para obtener información detallada de lugares turísticos")
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
    NavigationView {
        GuiaView()
    }
}
