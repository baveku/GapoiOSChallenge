//
//  GoogleMapRepository.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/14/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class GoogleMapRepository {
    private let provider = MoyaProvider<GoogleMapsApiService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    
    func getDirection(origin: String, destination: String, mode: DirectionMode) -> Observable<GetDirectionResponse> {
        return Observable.create { observer -> Disposable in
            let request = GetDirectionRequest(origin: origin, destination: destination, mode: mode.rawValue)
            self.provider.request(.getDirection(request)) { (result) in
                switch result {
                case .success(let response):
                    do {
                        let directionResponse = try JSONDecoder().decode(GetDirectionResponse.self, from: response.data)
                        observer.onNext(directionResponse)
                        observer.onCompleted()
                    } catch let err {
                        print("[DECODE ERROR] cannot decode JSON \(String(describing: String.init(data: response.data, encoding: .utf8)))")
                        observer.onError(err)
                    }
                case .failure(let err):
                    observer.onError(err)
                }
            }
            return Disposables.create()
        }
    }
    
    func searchPlace(text: String) -> Observable<PlaceSearchResponse> {
        return Observable.create { observer -> Disposable in
            let request = PlaceSearchRequest.init(query: text)
            self.provider.request(.placeSearch(request))  { (results) in
                switch results {
                case .success(let response):
                    do {
                        let jsonDecode = try JSONDecoder().decode(PlaceSearchResponse.self, from: response.data)
                        observer.onNext(jsonDecode)
                        observer.onCompleted()
                    } catch let err {
                        print("[DECODE ERROR] cannot decode JSON \(String(describing: String.init(data: response.data, encoding: .utf8)))")
                        observer.onError(err)
                    }
                case .failure(let err):
                    observer.onError(err)
                }
            }
            return Disposables.create()
        }
    }
}
