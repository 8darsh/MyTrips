//
//  Destination.swift
//  MyTrips
//
//  Created by Adarsh Singh on 16/06/24.
//

import Foundation
import MapKit
import SwiftData

@Model
class Destination{
    var name: String
    var latitude: Double?
    var longitude: Double?
    var latitudeDelta: Double?
    var longitudeDelta: Double?
    @Relationship(deleteRule: .cascade)
    var placemarks: [MTPlacemark] = []
    
    init(name: String, latitude: Double? = nil, longitude: Double? = nil, latitudeDelta: Double? = nil, longitudeDelta: Double? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
    
    var region: MKCoordinateRegion? {
        if let latitude, let longitude, let latitudeDelta, let longitudeDelta{
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
        }else{
            return nil
        }
    }
}

extension Destination{
    @MainActor
    static var preview: ModelContainer{
        let container = try! ModelContainer(for: Destination.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        // 28.643926, 77.092980

        let delhi = Destination(
            name: "Delhi",
            latitude: 28.643926,
            longitude: 77.092980,
            latitudeDelta: 0.15,
            longitudeDelta: 0.15
        )
        
        container.mainContext.insert(delhi)
        // 28.655779, 77.241011
        //28.612970, 77.229461
        // 28.612536, 77.237331
        // 28.626897, 77.216608
        var placemarks: [MTPlacemark]{
            [
                MTPlacemark(
                    name: "Red Fort",
                    address: "New Delhi",
                    latitude:  28.655779,
                    longitude: 77.241011
                ),
                
                MTPlacemark(
                    name: "India gate",
                    address: "New Delhi",
                    latitude:  28.612970,
                    longitude: 77.229461
                ),
                MTPlacemark(
                    name: "Major dhyan chand national stadium",
                    address: "New Delhi",
                    latitude:  28.612536,
                    longitude: 77.237331
                ),
                MTPlacemark(
                    name: "Jantar Mantar",
                    address: "New Delhi",
                    latitude:  28.626897,
                    longitude: 77.216608
                ),
            
            ]
        }
        
        placemarks.forEach { placemark in
            delhi.placemarks.append(placemark)
        }
        
        return container
    }
}
