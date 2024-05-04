//
//  GradientView.swift
//  ProfileSliderUIkit
//
//  Created by ROHIT DAS on 01/05/24.
//

import UIKit

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    func setGradient(colors: [UIColor]) {
        gradientLayer.colors = colors.map { $0.cgColor }
    }
}
