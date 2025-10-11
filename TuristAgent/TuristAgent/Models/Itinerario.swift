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
    @Guide(description: "Título simple para el itinerario")
    let titulo: String
    
    @Guide(description: "Descripción básica de actividades")
    let descripcion: String
    
    @Guide(description: "Información básica sobre visitar")
    let razon: String
    
    @Guide(description: "Título para el mapa")
    let tituloMapa: String
    
    @Guide(description: "Primer lugar recomendado para visitar")
    let lugar1: String
    
    @Guide(description: "Descripción detallada del primer lugar")
    let descripcionLugar1: String
    
    @Guide(description: "Rating del primer lugar")
    let rating1: String
    
    @Guide(description: "Segundo lugar recomendado para visitar")
    let lugar2: String
    
    @Guide(description: "Descripción detallada del segundo lugar")
    let descripcionLugar2: String
    
    @Guide(description: "Rating del segundo lugar")
    let rating2: String
    
    @Guide(description: "Una actividad especial de la ciudad")
    let actividad: String
    
    @Guide(description: "Descripción detallada de la actividad especial")
    let descripcionActividad: String
}
