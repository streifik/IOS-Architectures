//
//  CustomButton.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 13.09.23.
//
import Foundation
import UIKit

class GradientBackgroundButton: UIButton {

    let startColor = UIColor(red: 197/255, green: 140/255, blue: 197/255, alpha: 1.0)
    let endColor = UIColor(red: 123/255, green: 198/255, blue: 204/255, alpha: 1.0)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 16
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }()
}
