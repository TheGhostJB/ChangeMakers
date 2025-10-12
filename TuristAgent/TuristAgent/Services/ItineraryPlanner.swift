//
//  ItineraryPlanner.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 09/10/25.
//

import Foundation
import FoundationModels
import Observation

@Observable
@MainActor
final class ItineraryPlanner {
    private(set) var itinerary: Itinerario.PartiallyGenerated?
    private var session: LanguageModelSession
    private let csvTool: CSVSearchTool
    
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
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 segundos
        
        try await generateMapa()
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 segundos
        
        try await generateLugares()
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 segundos
        
        try await generateActividades()
    }
    
    private func generateTituloYDescripcion() async throws {
        let stream = session.streamResponse(
            generating: Itinerario.self,
            includeSchemaInPrompt: false,
            options: GenerationOptions(
                sampling: .greedy,
                temperature: 0.3
            )
        ) {
                "Extrae SOLO título y descripción para \(csvData.ciudad), \(csvData.pais)."
                
                "Incluye \(csvData.lugar1) y \(csvData.lugar2)."
                
                "Usa herramienta de búsqueda para \(csvData.ciudad)."
                
                "Proporciona SOLO:"
                "- Título"
                "- Descripción"
                
                "Usa solo datos factuales."
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
                temperature: 0.3
            )
        ) {
                "Extrae SOLO título del mapa para \(csvData.ciudad), \(csvData.pais)."
                
                "Usa herramienta de búsqueda para \(csvData.ciudad)."
                
                "Proporciona SOLO:"
                "- Título del mapa"
                
                "Usa solo datos factuales."
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
        
        // Simular delay para mantener la experiencia progresiva
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 segundos
    }
    
    private func generateDescripcionesLugares() async throws {
        let stream = session.streamResponse(
            generating: Itinerario.self,
            includeSchemaInPrompt: false,
            options: GenerationOptions(
                sampling: .greedy,
                temperature: 0.3
            )
        ) {
                "Genera descripciones detalladas para lugares recomendados en \(csvData.ciudad), \(csvData.pais)."
                
                "Para \(csvData.lugar1) y \(csvData.lugar2), proporciona descripciones atractivas que expliquen:"
                "- Qué hace especial cada lugar"
                "- Qué pueden esperar experimentar los visitantes"
                "- Por qué es recomendado para turistas"
                
                "Usa herramienta de búsqueda para \(csvData.ciudad) para obtener información factual."
                
                "IMPORTANTE: Proporciona las descripciones en el orden correcto:"
                "- descripcionLugar1 debe ser para \(csvData.lugar1)"
                "- descripcionLugar2 debe ser para \(csvData.lugar2)"
                
                "Haz las descripciones informativas y atractivas para turistas."
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
        
        // Simular delay para mantener la experiencia progresiva
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 segundos
    }
    
    private func generateDescripcionActividad() async throws {
        let stream = session.streamResponse(
            generating: Itinerario.self,
            includeSchemaInPrompt: false,
            options: GenerationOptions(
                sampling: .greedy,
                temperature: 0.3
            )
        ) {
                "Genera una descripción detallada para la actividad especial '\(csvData.cosaPorHacer1)' en \(csvData.ciudad), \(csvData.pais)."
                
                "Proporciona una descripción atractiva que explique:"
                "- En qué consiste esta actividad"
                "- Qué la hace especial y única"
                "- Qué pueden esperar experimentar los visitantes"
                "- Por qué es recomendada para turistas"
                
                "Usa herramienta de búsqueda para \(csvData.ciudad) para obtener información factual."
                
                "Proporciona SOLO:"
                "- Descripción detallada de la actividad"
                
                "Haz la descripción informativa y atractiva para turistas."
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
