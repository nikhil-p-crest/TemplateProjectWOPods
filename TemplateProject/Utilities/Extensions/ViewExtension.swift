//
//  ViewExtension.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension UIView {
    
    enum GradientLocation {
        case topBottom
        case bottomTop
        case leftRight
        case rightLeft
        
        var locations:[NSNumber] {
            switch self {
            case .topBottom:
                return [0.0, 1.0]
            case .bottomTop:
                return [0.0, 1.0]
            case .leftRight:
                return [0.0, 1.0]
            case .rightLeft:
                return [0.0, 1.0]
            }
        }
        
        var position:(startPosition: CGPoint, endPosition: CGPoint) {
            switch self {
            case .topBottom:
                return (startPosition: CGPoint.init(x: 0, y: 0), endPosition: CGPoint.init(x: 0, y: 1))
            case .bottomTop:
                return (startPosition: CGPoint.init(x: 0, y: 1), endPosition: CGPoint.init(x: 0, y: 0))
            case .leftRight:
                return (startPosition: CGPoint.init(x: 0, y: 1), endPosition: CGPoint.init(x: 1, y: 1))
            case .rightLeft:
                return (startPosition: CGPoint.init(x: 1, y: 1), endPosition: CGPoint.init(x: 0, y: 1))
            }
        }
        
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.applyCornerRadius(radius: newValue)
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return (self.layer.borderColor != nil) ? UIColor.init(cgColor: self.layer.borderColor!) : nil
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    func applyCornerRadius(radius: CGFloat = 8) {
        if radius > 0 {
            self.clipsToBounds = true
        }
        self.layer.cornerRadius = radius
    }
    
    func removeCornerRadius() {
        self.layer.cornerRadius = 0
        self.clipsToBounds = false
    }
    
    func applyBorder(_ borderWidth: CGFloat = 1, borderColor: UIColor = UIColor.black) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func applyShadow(withColor color: UIColor, offSetSize: CGSize = CGSize.zero, opacity: Float = 1, radius: CGFloat = 4) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offSetSize
        self.layer.masksToBounds = false
    }
    
    func applyShadowWithCornerRadius(_ cornerRadius: CGFloat = 8, color: UIColor, offSetSize: CGSize = CGSize.zero, opacity: Float = 1, radius: CGFloat = 8) {
        self.clipsToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offSetSize
    }
    
    func applyShadowWithBounds(_ bounds: CGRect, color: UIColor, offSetSize: CGSize = CGSize.zero, opacity: Float = 1, radius: CGFloat = 4) {
        self.clipsToBounds = false
        let shadowPath = UIBezierPath.init(rect: bounds).cgPath
        self.layer.shadowPath = shadowPath
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offSetSize
        self.layer.masksToBounds = false
    }
    
    func applyGradient(colors: [UIColor], forGradientLocation gradientLocation: GradientLocation) {
        if colors.count <= 0 {
            return
        }
        if let gradientLayer = self.layer.sublayers?.filter({$0.accessibilityLabel == "gradientLayer"}).first {
            gradientLayer.removeAllAnimations()
            gradientLayer.removeFromSuperlayer()
        }
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = self.bounds
        gradientLayer.accessibilityLabel = "gradientLayer"
        gradientLayer.colors = colors.map({$0.cgColor})
        gradientLayer.startPoint = gradientLocation.position.startPosition
        gradientLayer.endPoint = gradientLocation.position.endPosition
        self.layer.addSublayer(gradientLayer)
    }
    
    func applyDashedBorder(_ borderWidth: CGFloat = 1, borderColor: UIColor = UIColor.black, cornerRadius: CGFloat = 0) {
        
        self.layoutIfNeeded()
        if self.layer.sublayers?.count ?? 0 > 0 {
            let dashedBorderLayer = self.layer.sublayers!.filter({$0 is CAShapeLayer && $0.accessibilityHint == "dashedBorderLayer"}).first
            dashedBorderLayer?.removeFromSuperlayer()
        }
        
        let dashedBorderLayer = CAShapeLayer()
        dashedBorderLayer.accessibilityHint = "dashedBorderLayer"
        dashedBorderLayer.strokeColor = borderColor.cgColor
        dashedBorderLayer.lineDashPattern = [6, 2]
        dashedBorderLayer.frame = self.bounds
        dashedBorderLayer.fillColor = nil
        if cornerRadius > 0 {
            dashedBorderLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashedBorderLayer.path = UIBezierPath(rect: self.bounds).cgPath
        }
        self.layer.addSublayer(dashedBorderLayer)
        
    }
    
    func applyBottomRightLeftCornerWithShadow(_ cornerRadius: CGFloat = 10, color: UIColor) {
        
        self.layoutIfNeeded()
        if self.layer.sublayers?.count ?? 0 > 0 {
            let shadowLayer = self.layer.sublayers!.filter({$0 is CAShapeLayer && $0.accessibilityHint == "shadowLayer"}).first
            shadowLayer?.removeFromSuperlayer()
        }
        
        self.clipsToBounds = false
        
        let shadowLayer = CAShapeLayer()
        let shadowBounds = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let shadowPath = UIBezierPath(roundedRect: shadowBounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        shadowLayer.accessibilityHint = "shadowLayer"
        shadowLayer.path = shadowPath.cgPath
        shadowLayer.fillColor = self.backgroundColor?.cgColor
        
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        
        let shadowRadius = cornerRadius / 4
        
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: shadowRadius + 2)
        shadowLayer.shadowOpacity = 1.0
        shadowLayer.shadowRadius = shadowRadius
        
        self.layer.insertSublayer(shadowLayer, at: 0)
        
    }
    
    func setEnable(_ isEnable: Bool, withPrimaryColor primaryColor: UIColor = Constant.Color.primaryBlue) {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = isEnable
            self.backgroundColor = isEnable ? primaryColor : UIColor.gray
        }
    }
    
}

extension UISegmentedControl {
    
    @IBInspectable
    var fontSize: CGFloat {
        get {
            let titleTextAttributes = self.titleTextAttributes(for: .normal)
            let font = titleTextAttributes?[NSAttributedString.Key.font] as? UIFont
            return font?.pointSize ?? 17
        }
        set {
            let font = UIFont.font(UIFont.Font.SanFranciscoDisplayRegular, fontSize: newValue) ?? UIFont.systemFont(ofSize: newValue)
            self.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
    }
    
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
