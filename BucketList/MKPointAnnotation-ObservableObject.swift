//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Matteo Cavallo on 20/07/21.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            title ?? "Unknown"
        }
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            subtitle ?? "Unknown"
        }
        set {
            subtitle = newValue
        }
    }
    
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.wrappedTitle = "New Location"
        annotation.wrappedSubtitle = "Description"
        annotation.coordinate = CLLocationCoordinate2D()
        return annotation
    }
}
