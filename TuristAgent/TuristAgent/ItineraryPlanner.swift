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
    private(set) var rating1: String?
    private(set) var lugar2: String?
    private(set) var rating2: String?
    private(set) var actividad: String?
    
    var error: Error?
    let csvData: CSVData

    init(csvData: CSVData) {
        self.csvData = csvData
        var dataStore = CSVDataStore()
        
        // Cargar datos del CSV seleccionado
        do {
            try dataStore.loadCSVData(from: csvData)
        } catch {
            print("Error loading CSV data: \(error)")
        }
        
        self.csvTool = CSVSearchTool(dataStore: dataStore)
        self.session = LanguageModelSession(
            tools: [csvTool],
            instructions: Instructions {
                "Extract information from CSV data about \(csvData.ciudad)."
                
                "Use the search tool to find data about \(csvData.ciudad)."
                
                "Provide:"
                "- Title"
                "- Description"
                "- Reason"
                "- Map title"
                "- Two places with ratings"
                "- One activity"
                
                "Use only CSV data."
                
                "Provide factual information only."
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
        
        try await generateActividad()
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
                "Extract ONLY title and description for \(csvData.ciudad), \(csvData.pais)."
                
                "Include \(csvData.estadio) and \(csvData.lugar1) and \(csvData.lugar2)."
                
                "Use search tool for \(csvData.ciudad)."
                
                "Provide ONLY:"
                "- Title"
                "- Description"
                
                "Use factual data only."
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
                "Extract ONLY map title for \(csvData.ciudad), \(csvData.pais)."
                
                "Use search tool for \(csvData.ciudad)."
                
                "Provide ONLY:"
                "- Map title"
                
                "Use factual data only."
        }

        for try await partialResponse in stream {
            itinerary = partialResponse.content
            
            if let tituloMapa = partialResponse.content.tituloMapa {
                self.tituloMapa = tituloMapa
            }
        }
    }
    
    private func generateLugares() async throws {
        let stream = session.streamResponse(
            generating: Itinerario.self,
            includeSchemaInPrompt: false,
            options: GenerationOptions(
                sampling: .greedy,
                temperature: 0.3
            )
        ) {
                "Extract ONLY recommended places for \(csvData.ciudad), \(csvData.pais)."
                
                "Include \(csvData.lugar1) and \(csvData.lugar2)."
                
                "Use search tool for \(csvData.ciudad)."
                
                "Provide ONLY:"
                "- Two places with names and ratings"
                
                "Use factual data only."
        }

        for try await partialResponse in stream {
            itinerary = partialResponse.content
            
            if let lugar1 = partialResponse.content.lugar1 {
                self.lugar1 = lugar1
            }
            if let rating1 = partialResponse.content.rating1 {
                self.rating1 = rating1
            }
            if let lugar2 = partialResponse.content.lugar2 {
                self.lugar2 = lugar2
            }
            if let rating2 = partialResponse.content.rating2 {
                self.rating2 = rating2
            }
        }
    }
    
    private func generateActividad() async throws {
        let stream = session.streamResponse(
            generating: Itinerario.self,
            includeSchemaInPrompt: false,
            options: GenerationOptions(
                sampling: .greedy,
                temperature: 0.3
            )
        ) {
                "Extract ONLY one special activity for \(csvData.ciudad), \(csvData.pais)."
                
                "Use search tool for \(csvData.ciudad)."
                
                "Provide ONLY:"
                "- One activity"
                
                "Use factual data only."
        }

        for try await partialResponse in stream {
            itinerary = partialResponse.content
            
            if let actividad = partialResponse.content.actividad {
                self.actividad = actividad
            }
        }
    }

    func prewarm() {
        session.prewarm()
    }
}
