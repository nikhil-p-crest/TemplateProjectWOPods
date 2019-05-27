//
//  StoryboardExtension.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class func getViewController(forIdentifier identifier: String) -> UIViewController {
        let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        return viewController
    }
    
}
