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
                "Tu trabajo es crear un itinerario basado en los datos del CSV."
                
                "Usa la herramienta de búsqueda para encontrar información sobre \(csvData.ciudad)."
                
                "Genera un itinerario emocionante con:"
                "- Un título atractivo"
                "- Descripción de las actividades"
                "- Razón por la que será divertido"
                "- Título para el mapa"
                "- Dos lugares recomendados con sus ratings"
                "- Una actividad especial"
                
                "Usa SOLO la información proporcionada por la herramienta de búsqueda."
            }
        )
    }

    func generateItinerary() async throws {
        let stream = session.streamResponse(
            generating: Itinerario.self,
            includeSchemaInPrompt: false,
            options: GenerationOptions(sampling: .greedy)
        ) {
            "Genera un itinerario emocionante para \(csvData.ciudad), \(csvData.pais)."
            
            "Incluye información sobre el \(csvData.estadio) y los lugares recomendados."
            
            "Haz que sea atractivo y divertido para visitar."
        }

        for try await partialResponse in stream {
            itinerary = partialResponse.content
        }
    }

    func prewarm() {
        session.prewarm()
    }
}
