//  MyTrips
//
//  Created by Adarsh Singh on 16/06/24.
import SwiftUI
import MapKit
import SwiftData

struct DestinationLocationsMapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @Query private var destinations: [Destination]
    @State private var destination: Destination?
    
    var body: some View {
        Map(position: $cameraPosition){
            if let destination{
                ForEach(destination.placemarks){
                    placemark in
                    Marker(coordinate: placemark.coordinate) {
                        Label(placemark.name, systemImage: "star")
                    }
                }
            }
            
        }.onMapCameraChange(frequency: .onEnd) { context in
            visibleRegion = context.region
            
        }
            .onAppear{
                destination = destinations.first
                if let region = destination?.region{
                    cameraPosition = .region(region)
                }

            }
    }
}

#Preview {
    DestinationLocationsMapView()
        .modelContainer(Destination.preview)
}
