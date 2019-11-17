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
    let key = AppConfiguration.share.getItem(key: .mapSDKApiKey) as! String
}

struct PlaceSearchRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case query
        case key
    }
    let query: String
    let key = AppConfiguration.share.getItem(key: .mapSDKApiKey) as! String
}

// MARK: Response

struct OverviewPolyline: Codable {
    enum CodingKeys: String, CodingKey {
        case points
    }
    
    let points: String
}

struct Route: Codable {
    enum CodingKeys: String, CodingKey {
        case overviewPolyline = "overview_polyline"
    }
    
    let overviewPolyline: OverviewPolyline
}

struct GetDirectionResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case routes = "routes"
    }
    
    let routes: [Route]
}

struct PlaceSearchResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    let results: [Place]
}


