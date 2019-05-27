//
//  SocialLoginManager.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import AccountKit

enum SocialMediaLoginType {
    
    case accountKit
    case google
    case facebook
    
    var value: Int {
        switch self {
        case .accountKit:       return 0
        case .google:           return 1
        case .facebook:         return 2
        }
    }
    
}

protocol SocialLoginManagerDelegate {
    func didLoginFinished()
}

class SocialLoginManager: NSObject {
    
    static let sharedManager = SocialLoginManager.init()
    
    fileprivate var accountKit: AccountKit = AccountKit.init(responseType: ResponseType.accessToken)
    fileprivate let fbLoginManager: LoginManager = LoginManager.init()
    fileprivate static let googleClientID = "197826305147-11s502mds38v0hqaipat4rccg09atrnd.apps.googleusercontent.com"
    
    var delegate: SocialLoginManagerDelegate?
    
    var socialUserModel = SocialUserModel.init()
    
    override init() {
        super.init()
    }
    
    var loggedInSocialMediaType: SocialMediaLoginType {
        if ((AccessToken.current) != nil) {
            return SocialMediaLoginType.facebook
        } else if (GIDSignIn.sharedInstance().hasAuthInKeychain() == true) {
            return SocialMediaLoginType.google
        } else {
            return SocialMediaLoginType.accountKit
        }
    }
    
}

extension SocialLoginManager {
    
    class func initGoogleLoginSetup() {
        GIDSignIn.sharedInstance()?.clientID = SocialLoginManager.googleClientID
    }
    
    class func initFacebookLoginSetup(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    class func facebookApplication(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return (ApplicationDelegate.shared.application(app, open: url, options: options))
    }
    
    func initiateGoogleLogin() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func initiateFacebookLogin(withReadPermissions permissions: [String] = ["public_profile", "email"]) {
        if AccessToken.current == nil {
            fbLoginManager.loginBehavior = LoginBehavior.browser
            fbLoginManager.logIn(permissions: permissions, from: UtilityManager.shared.currentViewController) { (loginManagerLoginResult, error) in
                print("FB login completed")
                if loginManagerLoginResult?.isCancelled ?? false != true {
                    self.loadFBProfile()
                }
            }
        } else {
            self.loadFBProfile()
        }
    }
    
    func initiateMobileLogin() {
        let inputState = UUID().uuidString
        let vc = (self.accountKit.viewControllerForPhoneLogin(with: nil, state: inputState))
        vc.isSendToFacebookEnabled = true
        self.prepareSMSLoginViewController(loginViewController: vc)
        UtilityManager.shared.currentViewController?.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    fileprivate func prepareSMSLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
        //UI Theming - Optional
        loginViewController.uiManager = SkinManager(skinType: .classic, primaryColor: Constant.Color.primaryBlue)
    }
    
    func logout() {
        fbLoginManager.logOut()
        GIDSignIn.sharedInstance().signOut()
    }
    
    fileprivate func getAccountKitUserData() {
        self.socialUserModel = SocialUserModel.init()
        self.accountKit.requestAccount {
            (account, error) -> Void in
            if let accountID = account?.accountID {
                self.socialUserModel.account_id = accountID
            }
            
            if let email = account?.emailAddress {
                print(email)
                self.socialUserModel.email = email
            }
            else if let phoneNumber = account?.phoneNumber{
                self.socialUserModel.mobile = phoneNumber.stringRepresentation()
            }
            self.delegate?.didLoginFinished()
        }
    }
    
    fileprivate func loadFBProfile() {
        self.socialUserModel = SocialUserModel.init()
        self.socialUserModel.loginType = .facebook
        /* // Currently not required
         FBSDKProfile.loadCurrentProfile { (fbProfile, error) in
         UtilityManager.shared.endProcessing(completion: {
         let userId = fbProfile?.userID
         let idToken = FBSDKAccessToken.current().tokenString
         let fullName = fbProfile?.name
         let givenName = fbProfile?.firstName
         let familyName = fbProfile?.lastName
         print("Facebook login data:\nuserId: \(userId ?? "")\nidToken: \(idToken ?? "")\nfullName: \(fullName ?? "")\ngivenName: \(givenName ?? "")\nfamilyName: \(familyName ?? "")")
         UtilityManager.shared.showAlert(message: fullName ?? "")
         })
         }
         */
        //        let parameters = ["fields": "id, email, name, first_name, last_name, age_range, link, gender, locale, timezone, picture, updated_time, verified"]
        let parameters = ["fields": "id, email, name, first_name, last_name, link, picture.type(large)"] //["fields": "id, name, first_name, last_name, email, picture.type(large)"] //"small, normal, album, large, square"
        let request = GraphRequest(graphPath: "me", parameters: parameters)
        let _ = request.start(completionHandler: { (graphRequestConnection, data, error) in
            print("Facebook authData:\n\(String(describing: graphRequestConnection))\nFacebook profile:\n\(data ?? error ?? "")")
            if let responseDictionary = data as? [String: Any] {
                self.socialUserModel.account_id = responseDictionary[ServerConstant.WebService.FacebookLogin.id] as? String ?? ""
                self.socialUserModel.first_name = responseDictionary[ServerConstant.WebService.FacebookLogin.first_name] as? String ?? ""
                //                self.socialUserModel.last_name = responseDictionary[ServerConstant.WebService.FacebookLogin.last_name] as? String ?? ""
                self.socialUserModel.email = responseDictionary[ServerConstant.WebService.FacebookLogin.email] as? String ?? ""
                let picture = responseDictionary[ServerConstant.WebService.FacebookLogin.Picture.picture] as? [String: Any]
                let data = picture?[ServerConstant.WebService.FacebookLogin.Picture.Data.data] as? [String: Any]
                self.socialUserModel.profile_image = data?[ServerConstant.WebService.FacebookLogin.Picture.Data.url] as? String ?? ""
            }
            self.delegate?.didLoginFinished()
        })
    }
    
    @discardableResult
    func isUserAlreadyLoggedIn() -> Bool {
        if self.accountKit.currentAccessToken != nil {
            print("Account kit user already logged in.")
            return true
        } else if ((AccessToken.current) != nil) {
            print("Facebook user already logged in.")
            //            self.loadFBProfile()
            return true
        } else if (GIDSignIn.sharedInstance().hasAuthInKeychain() == true) {
            print("Google user already logged in.")
            return true
        }
        return false
    }
    
}

extension SocialLoginManager: AKFViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController & AKFViewController, didCompleteLoginWith code: String, state: String) {
        print(#function)
        self.getAccountKitUserData()
    }
    
    func viewController(_ viewController: UIViewController & AKFViewController, didFailWithError error: Error) {
        print(#function)
    }
    
    func viewControllerDidCancel(_ viewController: UIViewController & AKFViewController) {
        print(#function)
    }
    
}

extension SocialLoginManager: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        self.socialUserModel = SocialUserModel.init()
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let imageURL = user.profile.imageURL(withDimension: 500)
            // ...
            
            self.socialUserModel.loginType = .google
            self.socialUserModel.account_id = user.userID
            self.socialUserModel.first_name = user.profile.givenName
            //            self.socialUserModel.last_name = user.profile.familyName
            self.socialUserModel.email = user.profile.email
            self.socialUserModel.profile_image = imageURL?.absoluteString ?? ""
            
            print("Google login data:\nuserId: \(userId ?? "")\nidToken: \(idToken ?? "")\nfullName: \(fullName ?? "")\ngivenName: \(givenName ?? "")\nfamilyName: \(familyName ?? "")\nemail: \(email ?? "")\nimageURL: \(imageURL?.absoluteString ?? "")")
            
            self.delegate?.didLoginFinished()
            
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        // Perform any operations when the user disconnects from app here.
        // ...
        print("didDisconnectWithUser: \(user.profile.email ?? "")")
        
    }
    
}

extension SocialLoginManager: GIDSignInUIDelegate {
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("inWillDispatch")
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        UtilityManager.shared.currentViewController?.present(viewController, animated: true) {
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        UtilityManager.shared.currentViewController?.dismiss(animated: true) {
        }
    }
    
}

