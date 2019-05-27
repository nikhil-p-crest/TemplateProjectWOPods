//
//  NPCommonLoaderView.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum NPCommonLoaderViewBehaviour {
    case hideNavigationBar
    case inactiveNavigationBar
    case none
}

class NPCommonLoaderView: UIView {
    
    @IBOutlet var viewMainContent: UIView!
    @IBOutlet weak var viewMainContainer: UIView!
    @IBOutlet weak var viewCenterDataContainer: UIView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var viewLabelTitleContainer: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBInspectable
    var backgroundViewColor: UIColor? = Constant.Color.primaryBlue {
        didSet {
            self.viewMainContent.backgroundColor = self.backgroundViewColor
        }
    }
    
    @IBInspectable
    var loaderColor: UIColor = Constant.Color.primaryBlue {
        didSet {
            self.activityIndicatorView.color = self.loaderColor
        }
    }
    
    @IBInspectable
    var titleTextColor: UIColor = Constant.Color.primaryBlue {
        didSet {
            self.labelTitle.textColor = self.titleTextColor
        }
    }
    
    @IBInspectable
    var titleText: String? = nil {
        didSet {
            self.labelTitle.text = self.titleText
        }
    }
    
    var nvActivityIndicatorType: NVActivityIndicatorType = NVActivityIndicatorType.ballTrianglePath {
        didSet {
            self.activityIndicatorView.type = nvActivityIndicatorType
        }
    }
    
    var behaviour: NPCommonLoaderViewBehaviour = .none /*{
     didSet {
     self.updateViewAttributes(withLoaderVisible: !self.isHidden)
     }
     }*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed(String(describing: NPCommonLoaderView.self), owner: self, options: nil)
        self.addSubview(self.viewMainContent)
        self.viewMainContent.frame = self.bounds
        self.viewMainContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}

extension NPCommonLoaderView {
    
    func showProcessing(withFrame frame: CGRect = Constant.appDelegate.window!.bounds, title: String? = nil) {
        self.frame = frame
        if title?.count ?? 0 > 0 {
            self.viewLabelTitleContainer.isHidden = false
        } else {
            self.viewLabelTitleContainer.isHidden = true
        }
        self.labelTitle.text = title
        UtilityManager.shared.currentViewController?.view.addSubview(self)
        self.updateViewAttributes(withLoaderVisible: true)
        self.activityIndicatorView.startAnimating()
    }
    
    func endProcessing(_ completion: (()->())? = nil) {
        self.activityIndicatorView.stopAnimating()
        self.updateViewAttributes(withLoaderVisible: false)
        self.removeFromSuperview()
        completion?()
    }
    
    fileprivate func updateViewAttributes(withLoaderVisible isLoaderVisible: Bool) {
        self.isHidden = !isLoaderVisible
        let navigationController = UtilityManager.shared.currentViewController?.navigationController
        switch self.behaviour {
        case .hideNavigationBar:
            // Code to hide/unhide navigation bar while loader is added/removed
            navigationController?.setNavigationBarHidden(isLoaderVisible, animated: false)
        case .inactiveNavigationBar:
            // Code to prevent/allow interaction with navigation bar while loader is added/removed
            navigationController?.navigationBar.isUserInteractionEnabled = !isLoaderVisible
        case .none:
            break
        }
    }
    
}
