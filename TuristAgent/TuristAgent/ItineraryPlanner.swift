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
                "Create a travel itinerary based on the CSV data."
                
                "Use the search tool to find information about \(csvData.ciudad)."
                
                "Generate an exciting itinerary with:"
                "- An attractive title"
                "- Description of activities"
                "- Reason why it will be fun"
                "- Title for the map"
                "- Two recommended places with their ratings"
                "- A special activity"
                
                "Use ONLY the information provided by the search tool."
                
                "Respond with direct content, not conversational AI responses."
            }
        )
    }
    
    func generateItinerary() async throws {
        let stream = session.streamResponse(
            generating: Itinerario.self,
            includeSchemaInPrompt: false,
            options: GenerationOptions(sampling: .greedy)
        ) {
            "Generate a travel itinerary for \(csvData.ciudad), \(csvData.pais)."
            
            "Include information about \(csvData.estadio) and the recommended places: \(csvData.lugar1) and \(csvData.lugar2)."
            
            "Make it attractive and fun to visit."
            
            "Use the search tool to get specific information about \(csvData.ciudad)."
            
            "Create:"
            "- An exciting title"
            "- Description of what the itinerary includes"
            "- Reason why they will love this itinerary"
            "- Map title"
            "- Two recommended places with descriptions"
            "- A special activity to do in the city"
        }

        for try await partialResponse in stream {
            itinerary = partialResponse.content
        }
    }

    func prewarm() {
        session.prewarm()
    }
}
