//
//  UIView+Extensions.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/15/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableLabel: UILabel {}

@IBDesignable
class DesignableButton: UIButton {}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
