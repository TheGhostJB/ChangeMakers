//
//  ContentView.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showHome = false
    
    var body: some View {
        ZStack {
            // Fondo negro que cubre toda la pantalla
            Color.black
                .ignoresSafeArea(.all)
            
            if showHome {
                MainTabView()
            } else {
                // Imagen FFF centrada
                Image("FFF")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showHome = true
            }
        }
    }
}

#Preview {
    ContentView()
}
