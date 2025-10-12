//
//  SimpleItineraryIntent.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 09/10/25.
//

import AppIntents
import Foundation

@available(iOS 26.0, *)
struct SimpleItineraryIntent: AppIntent {
    static var title: LocalizedStringResource = "Itinerario Simple"
    static var description = IntentDescription("Genera un itinerario básico")
    
    @Parameter(title: "Ciudad", description: "Nombre de la ciudad")
    var city: String
    
    static var parameterSummary: some ParameterSummary {
        Summary("Generar itinerario para \(\.$city)")
    }
    
    static var appShortcuts: [AppShortcut] {
        [
            AppShortcut(
                intent: SimpleItineraryIntent(),
                phrases: [
                    "TuristAgent",
                    "Genera itinerario",
                    "Crea itinerario",
                    "Itinerario para"
                ],
                shortTitle: "Itinerario",
                systemImageName: "map"
            )
        ]
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Respuesta muy simple
        let response = "¡Hola! He generado un itinerario para \(city). Te recomiendo visitar los lugares disponibles en nuestra app. ¡Que disfrutes tu viaje!"
        
        return .result(dialog: IntentDialog(stringLiteral: response))
    }
}
