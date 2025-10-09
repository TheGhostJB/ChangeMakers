//
//  Itinerario.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 09/10/25.
//

import Foundation
import FoundationModels

@Generable
struct Itinerario: Equatable {
    @Guide(description: "Título emocionante para el itinerario")
    let titulo: String
    
    @Guide(description: "Descripción de lo que va a pasar en el itinerario")
    let descripcion: String
    
    @Guide(description: "Razón por la que le puede gustar este itinerario")
    let razon: String
    
    @Guide(description: "Título para el mapa")
    let tituloMapa: String
    
    @Guide(description: "Primer lugar recomendado para visitar")
    let lugar1: String
    
    @Guide(description: "Rating del primer lugar")
    let rating1: String
    
    @Guide(description: "Segundo lugar recomendado para visitar")
    let lugar2: String
    
    @Guide(description: "Rating del segundo lugar")
    let rating2: String
    
    @Guide(description: "Una cosa por hacer en la ciudad")
    let actividad: String
}
