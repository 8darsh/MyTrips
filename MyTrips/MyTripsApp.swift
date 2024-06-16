//  MyTrips
//
//  Created by Adarsh Singh on 16/06/24.

import SwiftUI
import SwiftData
@main
struct MyTripsApp: App {
    var body: some Scene {
        WindowGroup {
            StartTab()
        }
        .modelContainer(for: Destination.self)
    }
}
