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

// Estructura simple para crear itinerarios sin usar IA
struct SimpleItinerary: Equatable {
    let titulo: String
    let descripcion: String
    let razon: String
    let tituloMapa: String
    let lugar1: String
    let rating1: String
    let lugar2: String
    let rating2: String
    let actividad: String
}

// Estructura para itinerario progresivo
struct ProgressiveItinerary: Equatable {
    var titulo: String?
    var descripcion: String?
    var razon: String?
    var tituloMapa: String?
    var lugar1: String?
    var rating1: String?
    var lugar2: String?
    var rating2: String?
    var actividad: String?
}

// Extensión para convertir SimpleItinerary a Itinerario
extension Itinerario {
    init(_ simple: SimpleItinerary) {
        self.titulo = simple.titulo
        self.descripcion = simple.descripcion
        self.razon = simple.razon
        self.tituloMapa = simple.tituloMapa
        self.lugar1 = simple.lugar1
        self.rating1 = simple.rating1
        self.lugar2 = simple.lugar2
        self.rating2 = simple.rating2
        self.actividad = simple.actividad
    }
}
