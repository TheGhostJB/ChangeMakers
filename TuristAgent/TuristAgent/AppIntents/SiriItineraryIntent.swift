//
//  SiriItineraryIntent.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 12/10/25.
//

import AppIntents
import FoundationModels
import SwiftUI

// MARK: - Entidad Ciudad para AppIntents
struct CiudadEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Ciudad"
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(ciudad)")
    }
    
    let ciudad: String
    
    // Implementar Identifiable con String como ID
    var id: String { ciudad }
    
    static var defaultQuery = CiudadQuery()
}

struct CiudadQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [CiudadEntity] {
        return identifiers.map { CiudadEntity(ciudad: $0) }
    }
    
    func entities(matching string: String) async throws -> [CiudadEntity] {
        // Obtener las ciudades disponibles del ModelData
        let modelData = ModelData.shared
        
        // Verificar que hay datos cargados
        guard !modelData.csvData.isEmpty else {
            print("No hay datos CSV cargados")
            return []
        }
        
        return modelData.csvData
            .filter { $0.ciudad.localizedCaseInsensitiveContains(string) }
            .map { CiudadEntity(ciudad: $0.ciudad) }
    }
    
    func suggestedEntities() async throws -> [CiudadEntity] {
        // Devolver todas las ciudades disponibles
        let modelData = ModelData.shared
        
        // Verificar que hay datos cargados
        guard !modelData.csvData.isEmpty else {
            print("No hay datos CSV cargados")
            return []
        }
        
        let entities = modelData.csvData.map { CiudadEntity(ciudad: $0.ciudad) }
        print("🏙️ Sugiriendo \(entities.count) ciudades:")
        for entity in entities {
            print("  - '\(entity.ciudad)'")
        }
        
        return entities
    }
}

// Protocolo clave para que Siri descubra la intención y la funcionalidad de Apple Intelligence
struct SiriItineraryIntent: AppIntent {
    
    // El título es lo que Siri y Atajos mostrarán
    static var title: LocalizedStringResource = "Generar Itinerario por Voz"
    
    // Se elimina el argumento 'category'
    static var description = IntentDescription(
        "Genera un itinerario de viaje de un día usando Apple Intelligence para la ciudad especificada.",
        searchKeywords: ["viaje", "plan", "turismo", "guía", "itinerario"]
    )
    
    // Asegura que la aplicación se abra para mostrar el itinerario.
    static var openAppWhenRun: Bool = true

    // MARK: - Parámetros
    
    @Parameter(title: "Ciudad de Destino", description: "El nombre de la ciudad para la cual se generará el itinerario.")
    var ciudad: CiudadEntity
    
    // MARK: - Lógica de Ejecución

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // CORRECCIÓN: Acceder a la instancia compartida de ModelData
        let modelData = ModelData.shared
        
        // Verificar que hay datos cargados
        guard !modelData.csvData.isEmpty else {
            return .result(
                dialog: "Lo siento, no hay datos de ciudades disponibles en este momento."
            )
        }
        
        // 1. Validar que la ciudad existe en tus datos.
        // Se busca en la propiedad 'csvData' de ModelData.
        print("🔍 Buscando ciudad: '\(ciudad.ciudad)'")
        print("📋 Ciudades disponibles:")
        for city in modelData.csvData {
            print("  - '\(city.ciudad)'")
        }
        
        guard let selectedCity = modelData.csvData.first(where: { $0.ciudad.localizedCaseInsensitiveContains(ciudad.ciudad) }) else {
            print("❌ Ciudad no encontrada: '\(ciudad.ciudad)'")
            // Si la ciudad no se encuentra, devuelve un error claro.
            return .result(
                dialog: "Lo siento, no tengo información disponible para la ciudad: \(ciudad.ciudad). Por favor, intenta con otra."
            )
        }
        
        print("✅ Ciudad encontrada: '\(selectedCity.ciudad)'")
        
        // 2. Inicializar el planificador con los datos de la ciudad.
        let planner = ItineraryPlanner(csvData: selectedCity)
        
        // 3. Generar el itinerario (usando la lógica asíncrona que ya implementamos).
        do {
            try await planner.generateItinerary()
        } catch {
            print("❌ Error generando itinerario: \(error)")
            return .result(
                dialog: "Lo siento, hubo un problema generando el itinerario para \(ciudad.ciudad). Por favor, intenta de nuevo más tarde."
            )
        }
        
        // 4. Procesar el resultado del itinerario generado
        // CORRECCIÓN FINAL: Acceder directamente a las propiedades del itinerario parcialmente generado
        guard let itinerario = planner.itinerary,
              let titulo = itinerario.titulo else {
            return .result(
                dialog: "Lo siento, la inteligencia artificial no pudo generar un itinerario para \(ciudad.ciudad)."
            )
        }
        
        // 5. Guardar el itinerario generado en ModelData para que la app pueda accederlo
        modelData.selectedCity = selectedCity
        modelData.siriGeneratedPlanner = planner
        
        // 6. Devolver el resultado de voz a Siri
        let firstPlace = selectedCity.lugar1
        return .result(
            dialog: "He generado un itinerario de un día para \(titulo). El primer lugar a visitar es \(firstPlace). Abre la aplicación TuristAgent para ver todos los detalles y el mapa."
        )
    }
}
