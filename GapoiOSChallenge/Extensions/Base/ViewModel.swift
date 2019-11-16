//
//  File.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/16/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel: NSObject {
    let disposeBag = DisposeBag()
    var error = PublishSubject<String>()
    var loading = PublishSubject<Bool>()
}
