//
//  ContentView.swift
//  BucketList
//
//  Created by Matteo Cavallo on 19/07/21.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var centerCoordinates = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedLocation: MKPointAnnotation?
    @State private var showPlaceDetails = false
    @State private var showEditView = false
    
    var body: some View {

        ZStack{
            MapView(centerCoordinates: $centerCoordinates,
                    selectedLocation: $selectedLocation,
                    showPlaceDetails: $showPlaceDetails,
                    annotations: locations)
                .ignoresSafeArea()
            Circle()
                .fill(Color.blue)
                .opacity(0.4)
                .frame(width:32)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: addLocation){
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .padding(.trailing, 32)
                }
            }
        }
        .alert(isPresented: $showPlaceDetails){
            Alert(title: Text(selectedLocation?.title ?? "Unknown"), message: Text(selectedLocation?.subtitle ?? "Unknown details"), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")){
                self.showEditView = true
            })
        }
        .sheet(isPresented: $showEditView, onDismiss: saveData){
            if selectedLocation != nil {
                EditView(placemark: selectedLocation!)
            }
        }
        .onAppear(perform: loadData)
    }
    
    func addLocation(){
        let location = CodableMKPointAnnotation()
        location.coordinate = centerCoordinates
        location.title = "Nuova Posizione"
        location.subtitle = "Descrizione"
        locations.append(location)
        
        selectedLocation = location
        showEditView = true
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData(){
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
        
        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Error loading data.")
        }
    }
    
    func saveData(){
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Error saving data.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
