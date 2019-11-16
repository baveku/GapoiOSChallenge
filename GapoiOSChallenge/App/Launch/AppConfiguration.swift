//
//  AppConfiguration.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/16/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import Foundation

class AppConfiguration {
    static let share = AppConfiguration()
    private var _cache = [String: Any]()
    enum Keys: String {
        case mapSDKApiKey = "MapsSDKApiKey"
        case placeSDKApiKey = "PlaceSDKApiKey"
    }
    
    func getItem(key: Keys) -> Any {
        if let value = self._cache[key.rawValue] {
            return value
        }
        let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as Any
        self._cache[key.rawValue] = value
        return value
    }
}
