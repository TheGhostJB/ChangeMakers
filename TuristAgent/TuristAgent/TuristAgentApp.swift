//
//  TuristAgentApp.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI
import AppIntents
import FoundationModels

@main
struct TuristAgentApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        // Los App Intents se registran automáticamente en iOS 26
        // No necesitamos registro manual
    }
}
