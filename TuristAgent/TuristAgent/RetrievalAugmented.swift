//
//  RetrievalAugmented.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 09/10/25.
//

import Foundation
import FoundationModels

// MARK: - 1. Simple CSV Data Store

struct CSVDataStore {
    var items: [(text: String, metadata: [String: String])] = []
    
    /// Load data from a CSV file
    mutating func loadCSV(from path: String) throws {
        let content = try String(contentsOfFile: path, encoding: .utf8)
        let rows = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        guard let headerRow = rows.first else { return }
        
        let headers = headerRow.components(separatedBy: ",")
        
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ",")
            guard columns.count == headers.count else { continue }
            
            // Combine all columns into searchable text
            let text = columns.joined(separator: " ")
            
            // Store metadata
            var metadata: [String: String] = [:]
            for (header, value) in zip(headers, columns) {
                metadata[header] = value
            }
            
            items.append((text: text, metadata: metadata))
        }
    }
    
    /// Load specific CSV data
    mutating func loadCSVData(from csvData: CSVData) throws {
        // Create metadata from CSVData
        var metadata: [String: String] = [:]
        metadata["ID del estadio"] = "\(csvData.id)"
        metadata["Estadio"] = csvData.estadio
        metadata["Ciudad"] = csvData.ciudad
        metadata["País"] = csvData.pais
        metadata["Lugar 1"] = csvData.lugar1
        metadata["Descripción lugar 1"] = csvData.descripcionLugar1
        metadata["Rating lugar 1"] = csvData.ratingLugar1
        metadata["Horarios lugar 1"] = csvData.horariosLugar1
        metadata["Lugar 2"] = csvData.lugar2
        metadata["Descripción lugar 2"] = csvData.descripcionLugar2
        metadata["Rating lugar 2"] = csvData.ratingLugar2
        metadata["Horarios lugar 2"] = csvData.horariosLugar2
        metadata["Lugar 3"] = csvData.lugar3
        metadata["Descripción lugar 3"] = csvData.descripcionLugar3
        metadata["Rating lugar 3"] = csvData.ratingLugar3
        metadata["Horarios lugar 3"] = csvData.horariosLugar3
        metadata["Lugar 4"] = csvData.lugar4
        metadata["Descripción lugar 4"] = csvData.descripcionLugar4
        metadata["Rating lugar 4"] = csvData.ratingLugar4
        metadata["Horarios lugar 4"] = csvData.horariosLugar4
        metadata["Lugar 5"] = csvData.lugar5
        metadata["Descripción lugar 5"] = csvData.descripcionLugar5
        metadata["Rating lugar 5"] = csvData.ratingLugar5
        metadata["Horarios lugar 5"] = csvData.horariosLugar5
        metadata["Cosa por hacer 1"] = csvData.cosaPorHacer1
        metadata["Cosa por hacer 2"] = csvData.cosaPorHacer2
        metadata["Clima de la cuidad(°C)"] = csvData.clima
        
        // Create searchable text
        let text = [
            csvData.estadio, csvData.ciudad, csvData.pais,
            csvData.lugar1, csvData.descripcionLugar1,
            csvData.lugar2, csvData.descripcionLugar2,
            csvData.lugar3, csvData.descripcionLugar3,
            csvData.lugar4, csvData.descripcionLugar4,
            csvData.lugar5, csvData.descripcionLugar5,
            csvData.cosaPorHacer1, csvData.cosaPorHacer2
        ].joined(separator: " ")
        
        items.append((text: text, metadata: metadata))
    }
    
    /// Simple keyword search - finds items that contain the query words
    func search(query: String) -> [String] {
        let queryWords = query.lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { $0.count > 2 } // Skip tiny words like "is", "a"
        
        let matches = items.filter { item in
            let itemText = item.text.lowercased()
            // Check if item contains any of the query words
            return queryWords.contains { word in
                itemText.contains(word)
            }
        }
        
        return matches.map { $0.text }
    }
}

// MARK: - 2. Search Tool with CSV Data

struct CSVSearchTool: Tool {
    let name = "search"
    let description = "Search the CSV data for relevant information"
    
    let dataStore: CSVDataStore
    
    @Generable
    struct Arguments {
        var query: String
    }
    
    func call(arguments: Arguments) async throws -> String {
        let results = dataStore.search(query: arguments.query)
        
        if results.isEmpty {
            return "No relevant information found."
        }
        
        // Return formatted results for the model to understand
        let formattedResults = results.prefix(3).map { result in
            // Find the matching item in dataStore to get metadata
            guard let item = dataStore.items.first(where: { $0.text == result }) else { return result }
            
            return """
            Ciudad: \(item.metadata["Ciudad"] ?? "")
            País: \(item.metadata["País"] ?? "")
            Estadio: \(item.metadata["Estadio"] ?? "")
            Lugar 1: \(item.metadata["Lugar 1"] ?? "") - Rating: \(item.metadata["Rating lugar 1"] ?? "")
            Descripción Lugar 1: \(item.metadata["Descripción lugar 1"] ?? "")
            Lugar 2: \(item.metadata["Lugar 2"] ?? "") - Rating: \(item.metadata["Rating lugar 2"] ?? "")
            Descripción Lugar 2: \(item.metadata["Descripción lugar 2"] ?? "")
            Cosa por hacer 1: \(item.metadata["Cosa por hacer 1"] ?? "")
            Cosa por hacer 2: \(item.metadata["Cosa por hacer 2"] ?? "")
            Clima: \(item.metadata["Clima de la cuidad(°C)"] ?? "")
            """
        }.joined(separator: "\n\n")
        
        return formattedResults
    }
}
