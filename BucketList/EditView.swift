//
//  EditView.swift
//  BucketList
//
//  Created by Matteo Cavallo on 20/07/21.
//

import SwiftUI
import MapKit

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No informations"
    }
}

struct EditView: View {
    enum LoadingState {
        case loading, loaded, error
    }
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placemark: MKPointAnnotation
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationView{
            Form{
                TextField("Title", text: $placemark.wrappedTitle)
                TextField("Description", text: $placemark.wrappedSubtitle)
                
                Section(header: Text("Nearby...")){
                    if loadingState == .loaded {
                        List(pages, id: \.pageid){ page in
                            Text(page.title)
                                .font(.headline) +
                            Text(": ") +
                                Text(page.description)
                                .italic()
                        }
                    }
                    else if loadingState == .loading {
                        Text("Loading...")
                    }
                    else if loadingState == .error {
                        Text("Please try again later.")
                    }
                }

            }
            .navigationTitle("Edit location")
            .navigationBarItems(trailing: Button("Done"){
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear{
                loadLocations()
            }
        }
    }
    
    func loadLocations(){
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placemark.coordinate.latitude)%7C\(placemark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    // we got some data back!
                    let decoder = JSONDecoder()

                    if let items = try? decoder.decode(Result.self, from: data) {
                        // success – convert the array values to our pages array
                        self.pages = Array(items.query.pages.values).sorted()
                        self.loadingState = .loaded
                        return
                    }
                }

                // if we're still here it means the request failed somehow
                self.loadingState = .error
            }.resume()
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(placemark: MKPointAnnotation.example)
    }
}
