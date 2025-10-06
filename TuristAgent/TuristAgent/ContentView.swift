//
//  ContentView.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showHome = false
    @State private var animationStarted = false
    
    var body: some View {
        ZStack {
            // Fondo negro que cubre toda la pantalla
            Color.black
                .ignoresSafeArea(.all)
            
            if showHome {
                MainTabView()
            } else {
                GeometryReader { geometry in
                    ZStack {
                        VStack {
                            ZStack(alignment: .bottom) {
                                // Imagen v2 - Capa 1 (más atrás)
                                Image("v2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(animationStarted ? 1.2 : 0)
                                    .offset(y: -30)
                                    .colorMultiply(Color(red: 47/255, green: 67/255, blue: 214/255))
                                    .animation(.easeInOut(duration: 0.8).delay(0.5), value: animationStarted)
                                    
                                // Imagen v2 - Capa 2
                                Image("v2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(animationStarted ? 1.0 : 0)
                                    .clipped()
                                    .offset(y: 0)
                                    .colorMultiply(Color(red: 145/255, green: 118/255, blue: 220/255))
                                    .animation(.easeInOut(duration: 0.8).delay(0.4), value: animationStarted)
                                    
                                // Imagen v2 - Capa 3
                                Image("v2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(animationStarted ? 0.8 : 0)
                                    .clipped()
                                    .offset(y: 32)
                                    .colorMultiply(Color(red: 167/255, green: 34/255, blue: 27/255))
                                    .animation(.easeInOut(duration: 0.8).delay(0.3), value: animationStarted)
                                    
                                // Imagen v2 - Capa 4
                                Image("v2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(animationStarted ? 0.6 : 0)
                                    .clipped()
                                    .offset(y: 60)
                                    .colorMultiply(Color(red: 92/255, green: 27/255, blue: 25/255))
                                    .animation(.easeInOut(duration: 0.8).delay(0.2), value: animationStarted)
                                    
                                // Imagen v2 - Capa 5 (más adelante)
                                Image("v2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(animationStarted ? 0.4 : 0)
                                    .clipped()
                                    .offset(y: 90)
                                    .animation(.easeInOut(duration: 0.8).delay(0.1), value: animationStarted)
                            }
                            
                            ZStack(alignment: .bottom) {
                                // Imagen v6 - Capa 1 (más atrás)
                                Image("v6")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(animationStarted ? 1.2 : 0)
                                    .offset(y: 20)
                                    .colorMultiply(Color(red: 47/255, green: 67/255, blue: 214/255))
                                    .animation(.easeInOut(duration: 0.8).delay(0.5), value: animationStarted)
                                    
                                // Imagen v6 - Capa 2
                                Image("v6")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(animationStarted ? 1.0 : 0)
                                    .clipped()
                                    .offset(y: -1)
                                    .colorMultiply(Color(red: 145/255, green: 118/255, blue: 220/255))
                                    .animation(.easeInOut(duration: 0.8).delay(0.4), value: animationStarted)
                                    
                                // Imagen v6 - Capa 3
                                Image("v6")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(animationStarted ? 0.8 : 0)
                                    .clipped()
                                    .offset(y: -40)
                                    .colorMultiply(Color(red: 167/255, green: 34/255, blue: 27/255))
                                    .animation(.easeInOut(duration: 0.8).delay(0.3), value: animationStarted)
                                    
                                // Imagen v6 - Capa 4
                                Image("v6")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(animationStarted ? 0.6 : 0)
                                    .clipped()
                                    .offset(y: -70)
                                    .colorMultiply(Color(red: 92/255, green: 27/255, blue: 25/255))
                                    .animation(.easeInOut(duration: 0.8).delay(0.2), value: animationStarted)
                                    
                                // Imagen v6 - Capa 5 (más adelante)
                                Image("v6")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(animationStarted ? 0.4 : 0)
                                    .clipped()
                                    .offset(y: -99)
                                    .animation(.easeInOut(duration: 0.8).delay(0.1), value: animationStarted)
                            }
                        }
                    }
                }
                .padding(.top, 80)
            }
        }
        .onAppear {
            // Iniciar animaciones después de un breve delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                animationStarted = true
            }
            
            // Transición al MainTabView después de que terminen las animaciones
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showHome = true
            }
        }
    }
}

#Preview {
    ContentView()
}