//
//  MKPointAnnotation-Codable.swift
//  BucketList
//
//  Created by Matteo Cavallo on 21/07/21.
//

import MapKit

class CodableMKPointAnnotation: MKPointAnnotation, Codable{
    enum CodingKeys: CodingKey{
        case title, subtitle, latitude, longitude
    }
    override init(){
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try title = container.decode(String.self, forKey: .title)
        try subtitle = container.decode(String.self, forKey: .subtitle)
        
        
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}
