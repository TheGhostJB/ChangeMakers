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
    private(set) var itinerary: ProgressiveItinerary?
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
        // Inicializar con contenido vacío
        itinerary = ProgressiveItinerary()
        
        // Generar contenido progresivamente
        await generateTitle()
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
        
        await generateDescription()
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
        
        await generateReason()
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
        
        await generateMapTitle()
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
        
        await generatePlace1()
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
        
        await generatePlace2()
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
        
        await generateActivity()
    }
    
    private func generateTitle() async {
        itinerary?.titulo = "Aventura en \(csvData.ciudad)"
    }
    
    private func generateDescription() async {
        itinerary?.descripcion = "Descubre lo mejor de \(csvData.ciudad), \(csvData.pais). Un destino lleno de cultura, gastronomía y experiencias únicas que no te puedes perder."
    }
    
    private func generateReason() async {
        itinerary?.razon = "Esta ciudad ofrece una combinación perfecta de historia, cultura moderna y experiencias gastronómicas que harán de tu viaje algo inolvidable."
    }
    
    private func generateMapTitle() async {
        itinerary?.tituloMapa = "Mapa de \(csvData.ciudad) - Lugares Imperdibles"
    }
    
    private func generatePlace1() async {
        itinerary?.lugar1 = csvData.lugar1
        itinerary?.rating1 = csvData.ratingLugar1
    }
    
    private func generatePlace2() async {
        itinerary?.lugar2 = csvData.lugar2
        itinerary?.rating2 = csvData.ratingLugar2
    }
    
    private func generateActivity() async {
        itinerary?.actividad = csvData.cosaPorHacer1
    }

    func prewarm() {
        session.prewarm()
    }
}
