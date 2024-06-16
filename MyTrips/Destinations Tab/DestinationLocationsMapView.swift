//  MyTrips
//
//  Created by Adarsh Singh on 16/06/24.
import SwiftUI
import MapKit
struct DestinationLocationsMapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    var body: some View {
        Map(position: $cameraPosition){
            
        }.onMapCameraChange(frequency: .onEnd) { context in
            visibleRegion = context.region
            
        }
            .onAppear{
                // 28.643926, 77.092980
                let delhi = CLLocationCoordinate2D(latitude: 28.643926, longitude: 77.092980)
                let delhiSpan = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
                let delhiRegion = MKCoordinateRegion(center: delhi, span: delhiSpan)
                cameraPosition = .region(delhiRegion)
            }
    }
}

#Preview {
    DestinationLocationsMapView()
}
