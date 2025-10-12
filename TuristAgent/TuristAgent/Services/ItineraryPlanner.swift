//
//  ItineraryPlanner.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 09/10/25.
//

import Foundation
import FoundationModels
import Observation

// MARK: - Delay Configuration
enum DelayConfiguration {
    case instant   // 0.01 segundos (solo para testing)
    case fast      // 0.1 segundos
    case optimized // 0.5 segundos  
    case slow      // 1.5 segundos
    
    var nanoseconds: UInt64 {
        switch self {
        case .instant:
            return 10_000_000  // 0.01 segundos
        case .fast:
            return 100_000_000
        case .optimized:
            return 500_000_000
        case .slow:
            return 1_500_000_000
        }
    }
    
    var description: String {
        switch self {
        case .instant:
            return "0.01 segundos"
        case .fast:
            return "0.1 segundos"
        case .optimized:
            return "0.5 segundos"
        case .slow:
            return "1.5 segundos"
        }
    }
}

@Observable
@MainActor
final class ItineraryPlanner {
    private(set) var itinerary: Itinerario.PartiallyGenerated?
    private var session: LanguageModelSession
    private let csvTool: CSVSearchTool
    
    // MARK: - Delay Configuration
    private let delayConfig: DelayConfiguration = .instant
    
    // Estados individuales para cada componente
    private(set) var titulo: String?
    private(set) var descripcion: String?
    private(set) var razon: String?
    private(set) var tituloMapa: String?
    private(set) var lugar1: String?
    private(set) var descripcionLugar1: String?
    private(set) var rating1: String?
    private(set) var lugar2: String?
    private(set) var descripcionLugar2: String?
    private(set) var rating2: String?
    private(set) var actividad: String?
    private(set) var descripcionActividad: String?
    
    var error: Error?
    let csvData: CSVData

    init(csvData: CSVData) {
        self.csvData = csvData
        var dataStore = CSVDataStore()
        
        // Cargar datos del CSV seleccionado
        do {
            try dataStore.loadCSVData(from: csvData)
        } catch {
            print("Error cargando datos CSV: \(error)")
        }
        
        self.csvTool = CSVSearchTool(dataStore: dataStore)
        self.session = LanguageModelSession(
            tools: [csvTool],
            instructions: Instructions {
                "Extrae información de los datos CSV sobre \(csvData.ciudad)."
                
                "Usa la herramienta de búsqueda para encontrar datos sobre \(csvData.ciudad)."
                
                "Proporciona:"
                "- Título"
                "- Descripción"
                "- Razón"
                "- Título del mapa"
                "- Dos lugares con calificaciones"
                "- Una actividad"
                
                "Usa solo datos CSV."
                
                "Proporciona solo información factual."
            }
        )
    }
    
    func generateItinerary() async throws {
        // Generar componentes secuencialmente con delays
        try await generateTituloYDescripcion()
        try await Task.sleep(nanoseconds: delayConfig.nanoseconds) // Delay configurable
        
        try await generateMapa()
        try await Task.sleep(nanoseconds: delayConfig.nanoseconds) // Delay configurable
        
        try await generateLugares()
        try await Task.sleep(nanoseconds: delayConfig.nanoseconds) // Delay configurable
        
        try await generateActividades()
    }
    
    private func generateTituloYDescripcion() async throws {
        let stream = session.streamResponse(
            generating: Itinerario.self,
            includeSchemaInPrompt: false,
            options: GenerationOptions(
                sampling: .greedy,
                temperature: 0.1
            )
        ) {
                "Título y descripción para \(csvData.ciudad), \(csvData.pais)."
                "Incluye \(csvData.lugar1) y \(csvData.lugar2)."
                "Busca información sobre \(csvData.ciudad)."
                "Título atractivo y descripción de 2-3 oraciones."
        }

        for try await partialResponse in stream {
            itinerary = partialResponse.content
            
            if let titulo = partialResponse.content.titulo {
                self.titulo = titulo
            }
            if let descripcion = partialResponse.content.descripcion {
                self.descripcion = descripcion
            }
        }
    }
    
    private func generateMapa() async throws {
        let stream = session.streamResponse(
            generating: Itinerario.self,
            includeSchemaInPrompt: false,
            options: GenerationOptions(
                sampling: .greedy,
                temperature: 0.1
            )
        ) {
                "Título del mapa para \(csvData.ciudad), \(csvData.pais)."
                "Busca información sobre \(csvData.ciudad)."
                "Título descriptivo del mapa."
        }

        for try await partialResponse in stream {
            itinerary = partialResponse.content
            
            if let tituloMapa = partialResponse.content.tituloMapa {
                self.tituloMapa = tituloMapa
            }
        }
    }
    
    private func generateLugares() async throws {
        // Usar datos del CSV para nombres y ratings
        self.lugar1 = csvData.lugar1
        self.rating1 = csvData.ratingLugar1
        self.lugar2 = csvData.lugar2
        self.rating2 = csvData.ratingLugar2
        
        // Generar descripciones usando Apple Intelligence
        try await generateDescripcionesLugares()
    }
    
    private func generateDescripcionesLugares() async throws {
        let stream = session.streamResponse(
            generating: Itinerario.self,
            includeSchemaInPrompt: false,
            options: GenerationOptions(
                sampling: .greedy,
                temperature: 0.1
            )
        ) {
                "Descripciones para \(csvData.lugar1) y \(csvData.lugar2) en \(csvData.ciudad), \(csvData.pais)."
                "Busca información sobre \(csvData.ciudad)."
                "Descripciones de 2-3 oraciones para cada lugar."
                "descripcionLugar1 para \(csvData.lugar1), descripcionLugar2 para \(csvData.lugar2)."
        }

        for try await partialResponse in stream {
            itinerary = partialResponse.content
            
            if let descripcionLugar1 = partialResponse.content.descripcionLugar1 {
                self.descripcionLugar1 = descripcionLugar1
            }
            if let descripcionLugar2 = partialResponse.content.descripcionLugar2 {
                self.descripcionLugar2 = descripcionLugar2
            }
        }
    }
    
    private func generateActividades() async throws {
        // Usar datos del CSV para el nombre de la actividad
        self.actividad = csvData.cosaPorHacer1
        
        // Generar descripción usando Apple Intelligence
        try await generateDescripcionActividad()
    }
    
    private func generateDescripcionActividad() async throws {
        let stream = session.streamResponse(
            generating: Itinerario.self,
            includeSchemaInPrompt: false,
            options: GenerationOptions(
                sampling: .greedy,
                temperature: 0.1
            )
        ) {
                "Descripción para '\(csvData.cosaPorHacer1)' en \(csvData.ciudad), \(csvData.pais)."
                "Busca información sobre \(csvData.ciudad)."
                "Descripción de 2-3 oraciones de la actividad."
        }

        for try await partialResponse in stream {
            itinerary = partialResponse.content
            
            if let descripcionActividad = partialResponse.content.descripcionActividad {
                self.descripcionActividad = descripcionActividad
            }
        }
    }

    func prewarm() {
        session.prewarm()
    }
}
