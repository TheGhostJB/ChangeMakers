//
//  AppleIntelligenceShortcuts.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 12/10/25.
//

import AppIntents

struct AppShortcuts: AppShortcutsProvider {
    // Definir el color de la baldosa del atajo en la app Atajos.
    static var shortcutTileColor: ShortcutTileColor = .blue
    
    // CORRECCIÓN: Devolver un array de AppShortcut correctamente
    static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: SiriItineraryIntent(), // Conecta con la Intención definida
                phrases: [
                    "Crear un itinerario para la ciudad en \(.applicationName)",
                    "Crear un itinerario de viaje en \(.applicationName)",
                    "Dime un itinerario para \(\.$ciudad) en \(.applicationName)",
                    "Planifica un viaje a \(\.$ciudad) con \(.applicationName)",
                    "Genera un plan de viaje para \(\.$ciudad) en \(.applicationName)",
                    "Crea un itinerario turístico para \(\.$ciudad) con \(.applicationName)",
                    "Ayúdame a planificar mi viaje a \(\.$ciudad) en \(.applicationName)",
                    "Necesito un itinerario para \(\.$ciudad) en \(.applicationName)",
                    "Dame recomendaciones de viaje para \(\.$ciudad) en \(.applicationName)",
                    "Quiero visitar \(\.$ciudad) con \(.applicationName)",
                    "Organiza mi día en \(\.$ciudad) con \(.applicationName)",
                    "Sugiere lugares para visitar en \(\.$ciudad) con \(.applicationName)",
                    "Hazme un plan de turismo para \(\.$ciudad) en \(.applicationName)",
                    "Dime qué hacer en \(\.$ciudad) con \(.applicationName)",
                    "Crea mi agenda de viaje para \(\.$ciudad) en \(.applicationName)"
                ]
            )
            
            // Si tienes otros atajos, deben ir aquí, uno debajo del otro:
            /*
            AppShortcut(
                intent: SimpleItineraryIntent(),
                phrases: [
                    // ...
                ]
            )
            */
        ]
    }
}
