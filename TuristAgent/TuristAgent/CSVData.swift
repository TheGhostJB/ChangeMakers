//
//  CSVData.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 09/10/25.
//

import Foundation

struct CSVData: Identifiable, Hashable {
    let id: Int
    let estadio: String
    let ciudad: String
    let pais: String
    let lugar1: String
    let descripcionLugar1: String
    let ratingLugar1: String
    let horariosLugar1: String
    let lugar2: String
    let descripcionLugar2: String
    let ratingLugar2: String
    let horariosLugar2: String
    let lugar3: String
    let descripcionLugar3: String
    let ratingLugar3: String
    let horariosLugar3: String
    let lugar4: String
    let descripcionLugar4: String
    let ratingLugar4: String
    let horariosLugar4: String
    let lugar5: String
    let descripcionLugar5: String
    let ratingLugar5: String
    let horariosLugar5: String
    let cosaPorHacer1: String
    let cosaPorHacer2: String
    let clima: String
    
    var descripcionCiudad: String {
        return "\(ciudad) es una ciudad en \(pais) que cuenta con el famoso \(estadio). El clima promedio es de \(clima)°C."
    }
}
