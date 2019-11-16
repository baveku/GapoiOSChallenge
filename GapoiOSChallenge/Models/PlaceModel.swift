//
//  PlaceModel.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/15/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Codable {
    enum CodeingKeys: String, CodingKey {
        case lat
        case lng
    }
    
    let lat: Double
    let lng: Double
    
    init(coordinate: CLLocationCoordinate2D) {
        self.lat = coordinate.latitude
        self.lng = coordinate.longitude
    }
    
    func toCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
    }
}

struct Geometry: Codable {
    enum CodeingKeys: String, CodingKey {
        case location = "location"
    }
    
    let location: Location
}

struct Place: Codable {
    enum CodeingKeys: String, CodingKey {
        case geometry
        case icon
        case name
        case vincity
    }
    let geometry: Geometry
    let icon: String
    let name: String
    let vincity: String
}
