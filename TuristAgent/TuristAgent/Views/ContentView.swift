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
    @State private var implosionStarted = false
    @State private var circleScale: CGFloat = 0
    @State private var circleOpacity: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            let maxDimension = max(geometry.size.width, geometry.size.height)
            let circleSize: CGFloat = 100
            let finalScale = (maxDimension / circleSize) * 2.5 // Escala para cubrir toda la pantalla
            
            ZStack {
                // Fondo negro que cubre toda la pantalla
                Color.black
                    .ignoresSafeArea(.all)
                
                ZStack {
                    // Contenido principal
                    VStack {
                        ZStack(alignment: .bottom) {
                            Image("v2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 1.4) : 0)
                                .offset(y: -59)
                                .colorMultiply(Color(red: 0.63, green: 0.79, blue: 0.25))
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0 : 0.5), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                            // Imagen v2 - Capa 1 (más atrás)
                            Image("v2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 1.2) : 0)
                                .offset(y: -30)
                                .colorMultiply(Color(red: 47/255, green: 67/255, blue: 214/255))
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0 : 0.5), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                                
                            // Imagen v2 - Capa 2
                            Image("v2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 1.0) : 0)
                                .clipped()
                                .offset(y: 0)
                                .colorMultiply(Color(red: 145/255, green: 118/255, blue: 220/255))
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0.1 : 0.4), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                                
                            // Imagen v2 - Capa 3
                            Image("v2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 0.8) : 0)
                                .clipped()
                                .offset(y: 32)
                                .colorMultiply(Color(red: 167/255, green: 34/255, blue: 27/255))
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0.2 : 0.3), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                                
                            // Imagen v2 - Capa 4
                            Image("v2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 0.6) : 0)
                                .clipped()
                                .offset(y: 60)
                                .colorMultiply(Color(red: 92/255, green: 27/255, blue: 25/255))
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0.3 : 0.2), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                                
                            // Imagen v2 - Capa 5 (más adelante)
                            Image("v2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 0.4) : 0)
                                .clipped()
                                .offset(y: 90)
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0.4 : 0.1), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                        }
                        
                        ZStack(alignment: .bottom) {
                            
                            Image("v6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 1.4) : 0)
                                .offset(y: 49)
                                .colorMultiply(Color(red: 0.63, green: 0.79, blue: 0.25))
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0 : 0.5), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                            // Imagen v6 - Capa 1 (más atrás)
                            Image("v6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 1.2) : 0)
                                .offset(y: 20)
                                .colorMultiply(Color(red: 47/255, green: 67/255, blue: 214/255))
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0 : 0.5), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                                
                            // Imagen v6 - Capa 2
                            Image("v6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 1.0) : 0)
                                .clipped()
                                .offset(y: -1)
                                .colorMultiply(Color(red: 145/255, green: 118/255, blue: 220/255))
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0.1 : 0.4), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                                
                            // Imagen v6 - Capa 3
                            Image("v6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 0.8) : 0)
                                .clipped()
                                .offset(y: -40)
                                .colorMultiply(Color(red: 167/255, green: 34/255, blue: 27/255))
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0.2 : 0.3), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                                
                            // Imagen v6 - Capa 4
                            Image("v6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 0.6) : 0)
                                .clipped()
                                .offset(y: -70)
                                .colorMultiply(Color(red: 92/255, green: 27/255, blue: 25/255))
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0.3 : 0.2), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                                
                            // Imagen v6 - Capa 5 (más adelante)
                            Image("v6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animationStarted ? (implosionStarted ? 0 : 0.4) : 0)
                                .clipped()
                                .offset(y: -99)
                                .animation(.easeInOut(duration: implosionStarted ? 0.5 : 0.8).delay(implosionStarted ? 0.4 : 0.1), value: animationStarted)
                                .animation(.easeInOut(duration: 0.5), value: implosionStarted)
                        }
                    }
                    .padding(.top, 80)
                    .opacity(showHome ? 0 : 1) // Desvanece el contenido original
                    
                    // MainTabView con máscara circular
                    if implosionStarted {
                        MainTabView()
                            .mask(
                                Circle()
                                    .frame(width: circleSize, height: circleSize)
                                    .scaleEffect(circleScale)
                            )
                            .animation(.easeInOut(duration: 1.2), value: circleScale)
                    }
                }
            }
            .onAppear {
                // Secuencia de animación
                
                // 1. Iniciar expansión
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    animationStarted = true
                }
                
                // 2. Iniciar implosión después de 2 segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    implosionStarted = true
                    
                    // 3. Expandir círculo con MainTabView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 1.2)) {
                            circleScale = finalScale
                        }
                        
                        // 4. Completar transición
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            showHome = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
