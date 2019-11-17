//
//  ColorUtils.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/17/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import UIKit
import Foundation

class ColorHelpers {
    class func fromDirectionMode(_ mode: DirectionMode) -> UIColor {
        switch mode {
        case .transit:
            return UIColor.red
        case .driving:
            return UIColor.green
        case .bicycling:
            return UIColor.blue
        case .walking:
            return UIColor.cyan
        }
    }
}
