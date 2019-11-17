//
//  CrashlysticNetwork.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/17/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import Foundation
import Moya
import FirebaseAnalytics

class CrashlyticsNetwork: PluginType {
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .failure(let err):
            let desc = err.errorDescription ?? ""
            let response = err.response?.description ?? ""
            let requestURLString = "\(target.baseURL)\(target.path)"
            Analytics.logEvent("[NETWORKER]", parameters: ["description": desc, "api_response": response, "url": requestURLString])
        default:
            break
        }
    }
}
