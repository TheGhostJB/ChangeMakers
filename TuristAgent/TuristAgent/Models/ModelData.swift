//
//  ModelData.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 09/10/25.
//

import Foundation

@Observable
class ModelData {
    @MainActor
    static let shared = ModelData()
    
    var csvData: [CSVData] = []
    var selectedCity: CSVData?
    
    private init() {
        loadCSVData()
    }
    
    func loadCSVData() {
        guard let csvPath = Bundle.main.path(forResource: "data", ofType: "csv") else {
            print("CSV file not found!")
            return
        }
        
        do {
            let content = try String(contentsOfFile: csvPath, encoding: .utf8)
            let rows = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
            
            guard let headerRow = rows.first else { return }
            let headers = parseCSVRow(headerRow)
            
            for (index, row) in rows.dropFirst().enumerated() {
                let columns = parseCSVRow(row)
                guard columns.count == headers.count else { 
                    print("Fila \(index + 1) tiene \(columns.count) columnas, esperaba \(headers.count)")
                    continue 
                }
                
                let data = CSVData(
                    id: index + 1,
                    estadio: columns[1],
                    ciudad: columns[2],
                    pais: columns[3],
                    lugar1: columns[4],
                    descripcionLugar1: columns[5],
                    ratingLugar1: columns[6],
                    horariosLugar1: columns[7],
                    lugar2: columns[8],
                    descripcionLugar2: columns[9],
                    ratingLugar2: columns[10],
                    horariosLugar2: columns[11],
                    lugar3: columns[12],
                    descripcionLugar3: columns[13],
                    ratingLugar3: columns[14],
                    horariosLugar3: columns[15],
                    lugar4: columns[16],
                    descripcionLugar4: columns[17],
                    ratingLugar4: columns[18],
                    horariosLugar4: columns[19],
                    lugar5: columns[20],
                    descripcionLugar5: columns[21],
                    ratingLugar5: columns[22],
                    horariosLugar5: columns[23],
                    cosaPorHacer1: columns[24],
                    cosaPorHacer2: columns[25],
                    clima: columns[26]
                )
                
                csvData.append(data)
            }
        } catch {
            print("Error cargando CSV: \(error)")
        }
    }
    
    private func parseCSVRow(_ row: String) -> [String] {
        var result: [String] = []
        var currentField = ""
        var insideQuotes = false
        var i = row.startIndex
        
        while i < row.endIndex {
            let char = row[i]
            
            if char == "\"" {
                if insideQuotes {
                    // Verificar si es una comilla escapada
                    let nextIndex = row.index(after: i)
                    if nextIndex < row.endIndex && row[nextIndex] == "\"" {
                        currentField += "\""
                        i = row.index(after: nextIndex)
                        continue
                    } else {
                        insideQuotes = false
                    }
                } else {
                    insideQuotes = true
                }
            } else if char == "," && !insideQuotes {
                result.append(currentField.trimmingCharacters(in: .whitespacesAndNewlines))
                currentField = ""
            } else {
                currentField += String(char)
            }
            
            i = row.index(after: i)
        }
        
        // Agregar el último campo
        result.append(currentField.trimmingCharacters(in: .whitespacesAndNewlines))
        
        return result
    }
    
    func selectCity(_ city: CSVData) {
        selectedCity = city
    }
}
