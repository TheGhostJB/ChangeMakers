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
<<<<<<< Updated upstream
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
                "- Título atractivo"
                "- Descripción concisa de 2-3 oraciones"
                
                "MANTÉN LA DESCRIPCIÓN CONCISA: máximo 3 oraciones, fácil de leer en móvil."
                "Usa solo datos factuales."
        }
=======
        print("🚀 Iniciando generación de itinerario para \(csvData.ciudad)")
        
        do {
            // Generar componentes secuencialmente con delays
            print("📝 Generando título y descripción...")
            try await generateTituloYDescripcion()
            try await Task.sleep(nanoseconds: delayConfig.nanoseconds) // Delay configurable
            
            print("🗺️ Generando mapa...")
            try await generateMapa()
            try await Task.sleep(nanoseconds: delayConfig.nanoseconds) // Delay configurable
            
            print("🏛️ Generando lugares...")
            try await generateLugares()
            try await Task.sleep(nanoseconds: delayConfig.nanoseconds) // Delay configurable
            
            print("🎯 Generando actividades...")
            try await generateActividades()
            
            print("✅ Itinerario generado exitosamente")
        } catch {
            print("❌ Error generando itinerario: \(error)")
            self.error = error
            throw error
        }
    }
    
    private func generateTituloYDescripcion() async throws {
        do {
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
>>>>>>> Stashed changes

            for try await partialResponse in stream {
                itinerary = partialResponse.content
                
                if let titulo = partialResponse.content.titulo {
                    self.titulo = titulo
                    print("📝 Título generado: \(titulo)")
                }
                if let descripcion = partialResponse.content.descripcion {
                    self.descripcion = descripcion
                    print("📝 Descripción generada: \(descripcion)")
                }
            }
        } catch {
            print("❌ Error en generateTituloYDescripcion: \(error)")
            throw error
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
                "Genera descripciones concisas y atractivas para lugares en \(csvData.ciudad), \(csvData.pais)."
                
                "Para \(csvData.lugar1) y \(csvData.lugar2), crea descripciones de 2-3 oraciones que incluyan:"
                "- Una característica principal del lugar"
                "- Una experiencia única que ofrece"
                "- Por qué es recomendado"
                
                "Usa herramienta de búsqueda para \(csvData.ciudad) para obtener información factual."
                
                "IMPORTANTE: Proporciona las descripciones en el orden correcto:"
                "- descripcionLugar1 debe ser para \(csvData.lugar1)"
                "- descripcionLugar2 debe ser para \(csvData.lugar2)"
                
                "MANTÉN LAS DESCRIPCIONES CONCISAS: máximo 3 oraciones, fácil de leer en móvil."
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
                "Genera una descripción concisa para la actividad especial '\(csvData.cosaPorHacer1)' en \(csvData.ciudad), \(csvData.pais)."
                
                "Crea una descripción de 2-3 oraciones que incluya:"
                "- En qué consiste esta actividad"
                "- Qué la hace especial y única"
                "- Por qué es recomendada para turistas"
                
                "Usa herramienta de búsqueda para \(csvData.ciudad) para obtener información factual."
                
                "Proporciona SOLO:"
                "- Descripción concisa de la actividad"
                
                "MANTÉN LA DESCRIPCIÓN CONCISA: máximo 3 oraciones, fácil de leer en móvil."
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
