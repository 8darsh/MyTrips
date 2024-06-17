//  MyTrips
//
//  Created by Adarsh Singh on 16/06/24.
import SwiftUI
import MapKit
import SwiftData

struct DestinationLocationsMapView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    var destination: Destination
    @State private var searchText = ""
    @FocusState private var searchFieldFocus: Bool
    @Query(filter: #Predicate<MTPlacemark> {$0.destination == nil }, animation: .default) private var searchPlacemarks: [MTPlacemark]
    private var listPlacemarks:[MTPlacemark]{
        searchPlacemarks + destination.placemarks
    }
    
    var body: some View {
        @Bindable var destination = destination
        VStack{
            LabeledContent{
                TextField("Enter Destibation name", text: $destination.name)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.primary)
            }label:{
                Text("Name:")
            }
            HStack{
                Text("Adjust the map to set the region for your destination.")
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Set Region"){
                    if let visibleRegion{
                        destination.latitude = visibleRegion.center.latitude
                        destination.longitude = visibleRegion.center.longitude
                        destination.latitudeDelta = visibleRegion.span.latitudeDelta
                        destination.longitudeDelta = visibleRegion.span.longitudeDelta
                    }
                    
                }
                .buttonStyle(.borderedProminent).tint(.pink)
                
            }
        }
        .padding()
        Map(position: $cameraPosition){
            ForEach(listPlacemarks){ placemark in
                if placemark.destination != nil{
                    Marker(coordinate: placemark.coordinate) {
                        Label(placemark.name,systemImage: "star")
                    }
                }
                else{
                    Marker(placemark.name, coordinate: placemark.coordinate)
                }
            }
            
            
        }
        .safeAreaInset(edge: .bottom){
            HStack{
                TextField("Search...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .focused($searchFieldFocus)
                    .overlay(alignment: .trailing){
                        
                        if searchFieldFocus{
                            Button{
                                searchText = ""
                                searchFieldFocus = false
                            }label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                            .offset(x: -5)
                            .foregroundStyle(.pink)
                        }
                    }
                    .onSubmit() {
                        Task {
                            await MapManager.searchPlaces(
                                modelContext,
                                searchText: searchText,
                                visibleRegion: visibleRegion
                            )
                            searchText = ""
                        }
                    }
                if !searchPlacemarks.isEmpty {
                    Button {
                        MapManager.removeSearchResults(modelContext)
                    }label: {
                        Image(systemName: "mappin.slash.circle.fill")
                            .imageScale(.large)
                    }
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(.red)
                    .clipShape(.circle)
                }
            }
            .padding()
                
            
        }
        
        
        .navigationTitle("Destination")
        .navigationBarTitleDisplayMode(.inline)
        
        .onMapCameraChange(frequency: .onEnd) { context in
            visibleRegion = context.region
            
        }
            .onAppear{
                MapManager.removeSearchResults(modelContext)
                if let region = destination.region{
                    cameraPosition = .region(region)
                }

            }
            .onDisappear(perform: {
                MapManager.removeSearchResults(modelContext)
            })
    }
}

#Preview {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor)[0]
    return NavigationStack{
        DestinationLocationsMapView(destination: destination)
    }
    .modelContainer(Destination.preview)
}
