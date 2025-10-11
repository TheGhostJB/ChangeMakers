//
//  MapView.swift
//  TuristAgent
//
//  Created by Diego Saldaña on 09/10/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    let ciudad: String
    let pais: String
    let lugar1: String?
    let lugar2: String?
    let actividad: String?
    
    // Coordenadas por defecto (Monterrey)
    @State private var latitud: Double = 25.67507
    @State private var longitud: Double = -100.31847
    @State private var latZoom: Double = 0.05
    @State private var lonZoom: Double = 0.05
    
    // Marcadores personalizados
    @State private var customMark: [Marcador] = []
    @State private var isLoading = true
    
    // Posición de la cámara del mapa
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.67507, longitude: -100.31847),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    
    var body: some View {
        ZStack {
            if isLoading {
                // Placeholder mientras carga
                RoundedRectangle(cornerRadius: 12)
                    .fill(.blue.opacity(0.1))
                    .frame(height: 200)
                    .overlay {
                        VStack(spacing: 8) {
                            ProgressView()
                                .scaleEffect(1.2)
                            Text("Cargando mapa...")
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
            } else {
                Map(position: $cameraPosition) {
                    // Mostrar marcadores personalizados
                    ForEach(customMark) { location in
                        Marker(location.nombre, coordinate: CLLocationCoordinate2D(
                            latitude: location.coordinate.latitude, 
                            longitude: location.coordinate.longitude
                        ))
                        .tint(location.colorMark)
                    }
                }
                .mapControls {
                    MapScaleView()
                }
                .frame(height: 200)
                .cornerRadius(12)
            }
        }
        .onAppear {
            loadMapData()
        }
    }
    
    private func loadMapData() {
        // Crear marcadores con coordenadas de ejemplo para testing
        var newMarkers: [Marcador] = []
        
        // Agregar ciudad principal
        let cityMarker = Marcador(
            nombre: ciudad,
            coordinate: CLLocationCoordinate2D(latitude: 25.67507, longitude: -100.31847),
            colorMark: .blue
        )
        newMarkers.append(cityMarker)
        
        // Agregar lugares con coordenadas cercanas para testing
        if let lugar1 = lugar1 {
            let lugar1Marker = Marcador(
                nombre: lugar1,
                coordinate: CLLocationCoordinate2D(latitude: 25.6800, longitude: -100.3200),
                colorMark: .green
            )
            newMarkers.append(lugar1Marker)
        }
        
        if let lugar2 = lugar2 {
            let lugar2Marker = Marcador(
                nombre: lugar2,
                coordinate: CLLocationCoordinate2D(latitude: 25.6700, longitude: -100.3150),
                colorMark: .red
            )
            newMarkers.append(lugar2Marker)
        }
        
        if let actividad = actividad {
            let actividadMarker = Marcador(
                nombre: actividad,
                coordinate: CLLocationCoordinate2D(latitude: 25.6650, longitude: -100.3250),
                colorMark: .orange
            )
            newMarkers.append(actividadMarker)
        }
        
        // Mostrar marcadores inmediatamente
        customMark = newMarkers
        isLoading = false
        
        // Ajustar posición de la cámara
        cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitud, longitude: longitud),
            span: MKCoordinateSpan(latitudeDelta: latZoom, longitudeDelta: lonZoom)
        ))
        
        print("MapView: Agregados \(newMarkers.count) marcadores")
        for marker in newMarkers {
            print("MapView: Marcador - \(marker.nombre) en \(marker.coordinate)")
        }
        
        // Intentar geocodificación real en segundo plano
        Task {
            await performRealGeocoding()
        }
    }
    
    private func performRealGeocoding() async {
        let geocoder = CLGeocoder()
        
        // Geocodificar la ciudad principal
        let cityAddress = "\(ciudad), \(pais)"
        
        do {
            let cityPlacemarks = try await geocoder.geocodeAddressString(cityAddress)
            
            if let cityPlacemark = cityPlacemarks.first,
               let cityLocation = cityPlacemark.location {
                
                // Actualizar coordenadas de la ciudad
                await MainActor.run {
                    latitud = cityLocation.coordinate.latitude
                    longitud = cityLocation.coordinate.longitude
                    
                    // Actualizar posición de la cámara
                    cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
                        center: cityLocation.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: latZoom, longitudeDelta: lonZoom)
                    ))
                    
                    // Actualizar marcador de la ciudad
                    if let cityIndex = customMark.firstIndex(where: { $0.nombre == ciudad }) {
                        customMark[cityIndex] = Marcador(
                            nombre: ciudad,
                            coordinate: cityLocation.coordinate,
                            colorMark: .blue
                        )
                    }
                }
                
                // Geocodificar lugares específicos
                if let lugar1 = lugar1 {
                    await addLocationMarker(geocoder: geocoder, locationName: lugar1, color: .green)
                }
                
                if let lugar2 = lugar2 {
                    await addLocationMarker(geocoder: geocoder, locationName: lugar2, color: .red)
                }
                
                if let actividad = actividad {
                    await addLocationMarker(geocoder: geocoder, locationName: actividad, color: .orange)
                }
                
                print("MapView: Geocodificación real completada con \(customMark.count) marcadores")
            }
        } catch {
            print("MapView: Error geocodificando ciudad: \(error)")
        }
    }
    
    private func addLocationMarker(
        geocoder: CLGeocoder,
        locationName: String,
        color: Color
    ) async {
        do {
            let placemarks = try await geocoder.geocodeAddressString("\(locationName), \(ciudad), \(pais)")
            
            if let placemark = placemarks.first,
               let location = placemark.location {
                
                let marker = Marcador(
                    nombre: locationName,
                    coordinate: location.coordinate,
                    colorMark: color
                )
                
                // Reemplazar marcador existente o agregar nuevo
                await MainActor.run {
                    if let existingIndex = customMark.firstIndex(where: { $0.nombre == locationName }) {
                        customMark[existingIndex] = marker
                    } else {
                        customMark.append(marker)
                    }
                }
                
                print("MapView: Geocodificación exitosa de \(locationName) en \(location.coordinate)")
            } else {
                print("MapView: No se encontró ubicación para \(locationName)")
            }
        } catch {
            print("MapView: Error geocodificando ubicación \(locationName): \(error)")
        }
    }
}

struct Marcador: Identifiable {
    let id = UUID()
    let nombre: String
    let coordinate: CLLocationCoordinate2D
    let colorMark: Color
}

#Preview {
    MapView(
        ciudad: "Monterrey",
        pais: "México",
        lugar1: "La Nacional",
        lugar2: "El Gran Pastor",
        actividad: "Recorrido por Parque Fundidora"
    )
    .padding()
}
