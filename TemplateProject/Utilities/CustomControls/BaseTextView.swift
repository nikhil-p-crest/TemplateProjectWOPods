//
//  BaseTextView.swift
//  circles
//
//  Created by Mac22 on 10/04/19.
//  Copyright © 2019 NP. All rights reserved.
//

import UIKit

protocol BaseTextViewDelegate {
    func textViewDidBeginEditing(_ baseTextView: BaseTextView)
    func textViewDidEndEditing(_ baseTextView: BaseTextView)
    func textViewDidChange(_ baseTextView: BaseTextView)
    func textView(_ baseTextView: BaseTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

//@IBDesignable
class BaseTextView: UITextView {
    
    fileprivate var placeholderLabel: UILabel!
    fileprivate let placeholderLabelTag: Int = 100
    
    @IBInspectable
    var placeholderText: String? {
        didSet {
            if self.placeholderLabel != nil {
                self.placeholderLabel.text = self.placeholderText
            }
            self.setupPlaceholder()
        }
    }
    
    @IBInspectable
    var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            self.setupPlaceholder()
        }
    }
    
    override var textColor: UIColor? {
        didSet {
            self.tintColor = self.textColor
        }
    }
    
    var placeholderAlignment : NSTextAlignment = .left {
        didSet {
            self.setupPlaceholder()
        }
    }
    
    var baseDelegate: BaseTextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.tintColor = self.textColor
    }
    
    fileprivate func commonInit() {
        self.setupPlaceholder()
    }
    
}

extension BaseTextView {
    
    func setupPlaceholder() {
        
        if let label = self.subviews.filter({($0 as? UILabel)?.tag == self.placeholderLabelTag}).first as? UILabel {
            label.removeFromSuperview()
        }
        
        self.delegate = self
        self.placeholderLabel = UILabel()
        self.placeholderLabel.tag = self.placeholderLabelTag
        self.placeholderLabel.text = self.placeholderText
        self.placeholderLabel.font = self.font
        self.placeholderLabel.numberOfLines = 0
        self.placeholderLabel.textAlignment = self.placeholderAlignment
        self.addSubview(self.placeholderLabel)
        
        self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        let superViewMargins = self.layoutMarginsGuide
        
        let constant = (self.font!.pointSize/2) - 5
        
        self.placeholderLabel.leadingAnchor.constraint(equalTo: superViewMargins.leadingAnchor, constant: (0 - constant)).isActive = true
        self.placeholderLabel.trailingAnchor.constraint(equalTo: superViewMargins.trailingAnchor, constant: constant).isActive = true
        self.placeholderLabel.topAnchor.constraint(equalTo: superViewMargins.topAnchor, constant: 0).isActive = true
        self.placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: superViewMargins.bottomAnchor, constant: 0).isActive = true
        
        self.placeholderLabel.textColor = self.placeholderColor
        self.updatePlaceholderLabelHiddenAttribute(self.text)
        
    }
    
    func updatePlaceholderLabelHiddenAttribute(_ text: String) {
        DispatchQueue.main.async {
            self.placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    func applyBold() {
        self.font = self.font?.bold()
    }
    
    func removeBold() {
        self.font = UIFont.font(UIFont.Font.SanFranciscoDisplayRegular, fontSize: self.font?.pointSize ?? 14)
    }
    
    func applyItalic() {
        self.font = UIFont.italicSystemFont(ofSize: self.font?.pointSize ?? 14)
    }
    
    func removeItalic() {
        self.font = UIFont.font(UIFont.Font.SanFranciscoDisplayRegular, fontSize: self.font?.pointSize ?? 14)
    }
    
    func applyUnderline() {
        var defaultAttributes = self.defaultAttributes()
        let attributes = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        defaultAttributes.merge(attributes, uniquingKeysWith: {(_, new) in new})
        let attributedString = NSAttributedString.init(string: self.text, attributes: defaultAttributes)
        self.attributedText = attributedString
    }
    
    func removeUnderline() {
        self.attributedText = NSAttributedString.init(string: self.text, attributes: self.defaultAttributes())
    }
    
    fileprivate func defaultAttributes() -> [NSAttributedString.Key : Any] {
        let attributes = [NSAttributedString.Key.foregroundColor : self.textColor,
                          NSAttributedString.Key.font: self.font]
        return attributes as [NSAttributedString.Key : Any]
    }
    
}

extension BaseTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let color = textView.textColor
        textView.tintColor = .clear
        textView.tintColor = color
        self.baseDelegate?.textViewDidBeginEditing(self)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updatePlaceholderLabelHiddenAttribute(textView.text)
        self.baseDelegate?.textViewDidChange(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return self.baseDelegate?.textView(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.baseDelegate?.textViewDidEndEditing(self)
    }
    
}

