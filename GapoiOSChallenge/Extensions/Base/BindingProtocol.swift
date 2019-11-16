//
//  BindingProtocol.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/16/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import Foundation
import UIKit

protocol ViewBindingable where Self: UIViewController {
    func bindingData()
    func bindingUI()
}
