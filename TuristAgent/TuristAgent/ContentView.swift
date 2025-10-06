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
                // Imagen v2 posicionada para que el borde inferior llegue a la mitad de la pantalla
                GeometryReader { geometry in
                    ZStack {
                        
                        VStack {
                            ZStack(alignment: .bottom) {
                                Image("v2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(1.2)
                                    // recorta fuera del frame visible
                                    .offset(y: -30)
                                    .colorMultiply(Color(red: 47/255, green: 67/255, blue: 214/255))
                                    
                                Image("v2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(1)
                                    .clipped() // recorta fuera del frame visible
                                    .offset(y: 0)
                                    .colorMultiply(Color(red: 145/255, green: 118/255, blue: 220/255))
                                    
                                Image("v2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(0.8)
                                    .clipped() // recorta fuera del frame visible
                                    .offset(y: 32)
                                    .colorMultiply(Color(red: 167/255, green: 34/255, blue: 27/255))
                                    
                                Image("v2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(0.6)
                                    .clipped() // recorta fuera del frame visible
                                    .offset(y: 60)
                                    .colorMultiply(Color(red: 92/255, green: 27/255, blue: 25/255))
                                    
                                Image("v2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(0.4)
                                    .clipped() // recorta fuera del frame visible
                                    .offset(y: 90)
                                    
                                    
                                
                                
                            }
                            ZStack(alignment: .bottom) {
                                Image("v6")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(1.2)
                                    // recorta fuera del frame visible
                                    .offset(y: 20)
                                    
                                    .colorMultiply(Color(red: 47/255, green: 67/255, blue: 214/255))
                                Image("v6")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(1)
                                    .clipped() // recorta fuera del frame visible
                                    .offset(y: -1)
                                    
                                    .colorMultiply(Color(red: 145/255, green: 118/255, blue: 220/255))
                                Image("v6")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(0.8)
                                    .clipped() // recorta fuera del frame visible
                                    .offset(y: -40)
                                    
                                    .colorMultiply(Color(red: 167/255, green: 34/255, blue: 27/255))
                                Image("v6")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(0.6)
                                    .clipped() // recorta fuera del frame visible
                                    .offset(y: -70)
                                    
                                    .colorMultiply(Color(red: 92/255, green: 27/255, blue: 25/255))
                                Image("v6")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(0.4)
                                    .clipped() // recorta fuera del frame visible
                                    .offset(y: -99)
                                
 
                                    
                                
                                
                            }
                        }
                        
                    }
                }.padding(.top,80)
            }
        }
        // .onAppear {
        //     DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //         showHome = true
        //     }
        // }
    }
}

#Preview {
    ContentView()
}
