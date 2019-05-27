//
//  TextFieldExtension.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    @IBInspectable
    var rightImage: UIImage? {
        get {
            return (self.rightView as? UIImageView)?.image
        }
        set {
            self.setRightImage(newValue)
        }
    }
    
    func setRightImage(_ image: UIImage?) {
        if image == nil {
            return
        }
        
        let size: CGFloat = 14
        let padding: CGFloat = self.bounds.height - size
        
        let imageView = UIImageView.init(frame: CGRect.init(origin: CGPoint.init(x: (padding / 2), y: (padding / 2)), size: CGSize.init(width: size, height: size)))
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        self.rightViewMode = .always
        self.rightView = imageView
    }
    
    @IBInspectable
    var attributedPlaceHolder: String? {
        get {
            return self.placeholder
        }
        set {
            self.setAttributedPlaceHolder(newValue ?? "")
        }
    }
    
    func setAttributedPlaceHolder(_ string: String, color: UIColor = Constant.Color.primaryBlue) {
        self.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func setAttributedPlaceHolder(withColor color: UIColor = Constant.Color.primaryBlue) {
        self.setAttributedPlaceHolder(self.placeholder ?? "", color: color)
    }
    
}
