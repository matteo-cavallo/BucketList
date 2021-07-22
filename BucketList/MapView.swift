//
//  MapView.swift
//  BucketList
//
//  Created by Matteo Cavallo on 19/07/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinates: CLLocationCoordinate2D
    @Binding var selectedLocation: MKPointAnnotation?
    @Binding var showPlaceDetails: Bool
    
    var annotations: [MKPointAnnotation]
    
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if uiView.annotations.count != annotations.count {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate{
        let parent: MapView
        
        init(_ parent: MapView){
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinates = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Choose a unique identifier
            let identifier = "Placemark"
            
            // Attempt to find a reusable annotation
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                // reusable not found
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                // allows to show info
                annotationView?.canShowCallout = true
                
                // attach annotation button to the view
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                // we have a view to reuse, give it the new annotation
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let annotation = view.annotation as? MKPointAnnotation else {
                return
            }
            
            parent.selectedLocation = annotation
            parent.showPlaceDetails = true
        }
    }
}
