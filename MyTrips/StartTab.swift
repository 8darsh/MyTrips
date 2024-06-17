//  MyTrips
//
//  Created by Adarsh Singh on 16/06/24.


import SwiftUI

struct StartTab: View {

    var body: some View {
        TabView {
            Group {
                TripMapView()
                    .tabItem {
                    Label("TripMap", systemImage: "map")
                }
                DestinationsListView()
                    .tabItem {
                        Label("Destinations", systemImage: "globe.desk")
                    }
            }
            .toolbarBackground(.pink.opacity(0.8), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
    }
}


#Preview {
    StartTab()
        .modelContainer(Destination.preview)
}
