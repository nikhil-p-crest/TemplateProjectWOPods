//
//  GradientButtonView.swift
//  circles
//
//  Created by Mac22 on 10/04/19.
//  Copyright © 2019 NP. All rights reserved.
//

import UIKit

//@IBDesignable
class GradientButtonView: UIView {
    
    @IBOutlet var viewMainContent: UIView!
    @IBOutlet weak var viewMainContainer: UIView!
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var button: UIButton!
    
    @IBInspectable
    var firstColor: UIColor = UIColor.gray {
        didSet {
            self.updateViewAppearance()
        }
    }
    
    @IBInspectable
    var secondColor: UIColor = UIColor.black {
        didSet {
            self.updateViewAppearance()
        }
    }
    
    @IBInspectable
    var buttonTitle: String? {
        didSet {
            self.button.setTitle(self.buttonTitle, for: UIControl.State.normal)
        }
    }
    
    @IBInspectable
    var buttonFontSize: CGFloat = 14 {
        didSet {
            self.button.titleLabel?.font = UIFont.font(UIFont.Font.SanFranciscoDisplayRegular, fontSize: self.buttonFontSize)
        }
    }
    
    @IBInspectable
    var buttonImage: UIImage? {
        didSet {
            self.updateButtonImage()
        }
    }
    
    var buttonTapped: ((UIButton)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.viewMainContent.applyCornerRadius(radius: self.bounds.height / 2)
        self.updateViewAppearance()
        self.updateButtonImage()
    }
    
    fileprivate func commonInit() {
        let bundle = Bundle(for: GradientButtonView.self)
        bundle.loadNibNamed(String(describing: GradientButtonView.self), owner: self, options: nil)
        self.addSubview(self.viewMainContent)
        self.viewMainContent.frame = self.bounds
        self.viewMainContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.button.imageView?.contentMode = .scaleAspectFit
    }

    @IBAction func didTapButton(_ sender: UIButton) {
        self.buttonTapped?(sender)
    }
    
}

extension GradientButtonView {
    
    func updateViewAppearance() {
        self.viewGradient.applyGradient(colors: [self.firstColor, self.secondColor], forGradientLocation: UIView.GradientLocation.leftRight)
    }
    
    func updateButtonImage() {
        if self.buttonImage == nil {
            self.button.imageEdgeInsets = UIEdgeInsets.zero
            self.button.contentHorizontalAlignment = .center
        } else {
            self.button.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 2, bottom: 8, right: 14)
            self.button.contentHorizontalAlignment = .left
        }
        self.button.setImage(self.buttonImage, for: UIControl.State.normal)
    }
    
}
