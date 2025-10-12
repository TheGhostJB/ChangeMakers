/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A SwiftUI view for rendering each day's suggested events from a partially generated itinerary.
*/

import FoundationModels
import SwiftUI
import MapKit
import WeatherKit

struct ItineraryView: View {
    let landmark: Landmark
    let itinerary: Itinerary.PartiallyGenerated

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                if let title = itinerary.title {
                    Text(title)
                        .contentTransition(.opacity)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                if let description = itinerary.description {
                    Text(description)
                        .contentTransition(.opacity)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            if let rationale = itinerary.rationale {
                HStack(alignment: .top) {
                    Image(systemName: "sparkles")
                    Text(rationale)
                        .contentTransition(.opacity)
                }
                .rationaleStyle()
            }
            
            if let days = itinerary.days {
                ForEach(days) { plan in
                    DayView(
                        landmark: landmark,
                        plan: plan
                    )
                    .transition(.blurReplace)
                }
            }
        }
        .animation(.easeOut, value: itinerary)
        .itineraryStyle()
    }
}

private struct DayView: View {
    let landmark: Landmark
    let plan: DayPlan.PartiallyGenerated

    @State private var map = LocationLookup()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack(alignment: .bottom) {
                LandmarkDetailMapView(
                    landmark: landmark,
                    landmarkMapItem: map.item
                )
                .onChange(of: plan.destination) { _, newValue in
                    if let destination = newValue, !destination.isEmpty {
                        map.performLookup(location: destination)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(weatherForecast)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if let title = plan.title {
                        Text(title)
                            .contentTransition(.opacity)
                            .font(.headline)
                    }
                    if let subtitle = plan.subtitle {
                        Text(subtitle)
                            .contentTransition(.opacity)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .blurredBackground()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .padding([.horizontal, .top], 4)
            
            ActivityList(activities: plan.activities ?? [])
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
        .padding(.bottom)
        .geometryGroup()
        .card()
        .animation(.easeInOut, value: plan)
    }
    
    var weatherForecast: LocalizedStringKey {
        if let forecast = map.temperatureString {
            "\(Image(systemName: "cloud.fill")) \(forecast)"
        } else {
            " "
        }
    }
}

private struct ActivityList: View {
    let activities: [Activity].PartiallyGenerated
    
    var body: some View {
        ForEach(activities) { activity in
            HStack(alignment: .top, spacing: 12) {
                if let title = activity.title {
                    ActivityIcon(symbolName: activity.type?.symbolName)
                    VStack(alignment: .leading) {
                        Text(title)
                            .contentTransition(.opacity)
                            .font(.headline)
                        if let description = activity.description {
                            Text(description)
                                .contentTransition(.opacity)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ItineraryView(
        landmark: Landmark(
            name: "Monterrey",
            country: "México",
            latitude: 25.6866,
            longitude: -100.3161,
            backgroundImageName: "Monterrey"
        ),
        itinerary: Itinerary.PartiallyGenerated(
            title: "Explorando Monterrey",
            description: "Descubre la cultura y gastronomía de la Sultana del Norte",
            rationale: "Itinerario diseñado para experimentar lo mejor de Monterrey en 3 días",
            days: [
                DayPlan.PartiallyGenerated(
                    title: "Día 1: Centro Histórico",
                    subtitle: "Conoce el corazón de la ciudad",
                    destination: "Centro de Monterrey",
                    activities: [
                        Activity.PartiallyGenerated(
                            title: "Visita al Palacio del Obispado",
                            description: "Museo histórico con vista panorámica",
                            type: .cultural
                        ),
                        Activity.PartiallyGenerated(
                            title: "Paseo por el Barrio Antiguo",
                            description: "Arquitectura colonial y vida nocturna",
                            type: .cultural
                        )
                    ]
                ),
                DayPlan.PartiallyGenerated(
                    title: "Día 2: Naturaleza",
                    subtitle: "Aventura en la Sierra Madre",
                    destination: "Parque Nacional Cumbres de Monterrey",
                    activities: [
                        Activity.PartiallyGenerated(
                            title: "Senderismo en Chipinque",
                            description: "Caminata por senderos naturales",
                            type: .outdoor
                        ),
                        Activity.PartiallyGenerated(
                            title: "Mirador de la Sierra",
                            description: "Vista panorámica de la ciudad",
                            type: .outdoor
                        )
                    ]
                )
            ]
        )
    )
    .padding()
}
