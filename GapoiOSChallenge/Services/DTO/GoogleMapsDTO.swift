//
//  GoogleMapsDTO.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/16/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import Foundation
import Moya

// MARK: Define Types

enum DirectionMode: String {
    case transit = "transit"
    case driving = "driving"
    case bicycling = "bicycling"
    case walking = "walking"
}

// MARK: Request

struct GetDirectionRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case origin = "origin"
        case destination = "destination"
        case mode = "mode"
    }
    let origin: String
    let destination: String
    let mode: DirectionMode.RawValue
    let key = AppConfiguration.share.getItem(key: .placeSDKApiKey) as! String
}

struct PlaceSearchRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case query
        case key
    }
    let query: String
    let key = AppConfiguration.share.getItem(key: .placeSDKApiKey) as! String
}

// MARK: Response

struct Routes: Codable {
    enum CodeingKeys: String, CodingKey {
        case overviewPolyline = "overview_polyline"
    }
    
    let overviewPolyline: String
}

struct GetDirectionResponse: Codable {
    enum CodeingKeys: String, CodingKey {
        case routes = "routes"
    }
    
    let routes: Routes
}

struct PlaceSearchResponse: Codable {
    enum CodeingKeys: String, CodingKey {
        case results
    }
    
    let results: [Place]
}


