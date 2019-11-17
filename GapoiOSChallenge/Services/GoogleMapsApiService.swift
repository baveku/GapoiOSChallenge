//
//  GoogleMapsApiService.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/14/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import Moya

enum OutputFormat: String {
    case JSON = "json"
}

enum GoogleMapsPath: String {
    case direction = "/directions"
    case search = "/place/textsearch"
    
    func withOutput(_ type: OutputFormat) -> String {
        return "\(self.rawValue)/\(type.rawValue)"
    }
}

enum GoogleMapsApiService {
    case getDirection(GetDirectionRequest)
    case placeSearch(PlaceSearchRequest)
}

extension GoogleMapsApiService: TargetType {
    var baseURL: URL {
        return Endpoints.googleMapAPI.toURL()
    }
    
    var path: String {
        switch self {
        case .getDirection(_):
            return GoogleMapsPath.direction.withOutput(.JSON)
        case .placeSearch(_):
            return GoogleMapsPath.search.withOutput(.JSON)
        }
    }
    
    var method: Method {
        switch self {
        case .getDirection, .placeSearch:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getDirection(let request):
            print(request)
            return .requestJSONEncodable(request)
        case .placeSearch(let request):
            print(request)
            return .requestParameters(parameters: ["query": request.query, "key": request.key], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
