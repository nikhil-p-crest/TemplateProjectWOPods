//
//  Constant.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
    
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let appDisplayName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    static let appVersionNumber: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    static let appBuildNumber: String = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""
    
    static let navigationTitleAppName: String = Constant.appDisplayName
    
    struct Device {
        #if targetEnvironment(simulator)
        static let isSimulator = true
        #else
        static let isSimulator = false
        #endif
        static let isIpad = (UIDevice.current.userInterfaceIdiom == .pad) ? true : false
        static let isIphone = (UIDevice.current.userInterfaceIdiom == .phone) ? true : false
    }
    
}

extension Constant {
    
    struct CommonErrorMessage {
        static let invalidEmail = "Please enter valid email."
        static let emptyPassword = "Please enter your password."
        static let profilePicMandatory = "Profile picture is necessary."
        static let allFieldsMandatory = "All fields are mandatory."
        static let agreePrivacyPolicy = "You must agree with privacy policy."
        static let invalidPassword = "Invalid password."
    }
    
}

extension Constant {
    
    struct Color {
        static let primaryBlue: UIColor = UIColor.init(named: "PrimaryBlue")!
        static let gradient1: UIColor = UIColor.init(named: "Gradient1")!
        static let gradient2: UIColor = UIColor.init(named: "Gradient2")!
    }
    
    struct Image {
        static let icBack = UIImage.init(named: "ic_back")!
    }
    
    struct UserDefaultsKey {
        static let loginUserModel = "loginUserModel"
        static let loginToken = "loginToken"
    }
    
}

