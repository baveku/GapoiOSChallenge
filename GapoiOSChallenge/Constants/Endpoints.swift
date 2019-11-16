//
//  Endpoints.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/14/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import Foundation

enum Endpoints: String {
    case googleMapAPI = "https://maps.googleapis.com/maps/api"
}

extension Endpoints {
    func toURL() -> URL {
        return URL.init(string: self.rawValue)!
    }
}
