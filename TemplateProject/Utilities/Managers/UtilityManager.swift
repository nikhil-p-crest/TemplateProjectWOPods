//
//  UtilityManager.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import UIKit
import MobileCoreServices
import SafariServices

class UtilityManager: NSObject {
    
    static let shared: UtilityManager = {
        let instance = UtilityManager.init()
        return instance
    }()
    
    private lazy var npCommonLoaderView: NPCommonLoaderView = {
        let instance = NPCommonLoaderView.init(frame: Constant.appDelegate.window!.bounds)
        instance.behaviour = NPCommonLoaderViewBehaviour.inactiveNavigationBar
        return instance
    }()
    
    var currentViewController: UIViewController? {
        var currentVC: UIViewController?
        let rootVC = Constant.appDelegate.window?.rootViewController
        if let navController = rootVC as? UINavigationController  {
            currentVC = navController.topViewController
        } else {
            currentVC = rootVC
        }
        return currentVC
    }
    
    typealias MediaPickingCompletionBlock = (([UIImagePickerController.InfoKey : Any])->())
    typealias MediaPickingCancelBlock = (()->())
    
    fileprivate var didFinishPickingMedia: MediaPickingCompletionBlock?
    fileprivate var didCancelPickingMedia: MediaPickingCancelBlock?
    
}

extension UtilityManager {
    
    func showProcessing(withFrame frame: CGRect = Constant.appDelegate.window!.bounds, message:String? = nil) {
        DispatchQueue.main.async {
            self.npCommonLoaderView.showProcessing(withFrame: frame, title: message)
        }
    }
    
    func endProcessing(completion: (()->())? = nil) {
        DispatchQueue.main.async {
            self.npCommonLoaderView.endProcessing({
                completion?()
            })
        }
    }
    
}

extension UtilityManager {
    
    func showAlert(withTitle title: String = Constant.appDisplayName, message: String, actions:[UIAlertAction] = [], defaultButtonAction:(()->())? = nil) {
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if actions.count > 0 {
            for action in actions {
                alertController.addAction(action)
            }
        } else {
            let action = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (alertAction) in
                defaultButtonAction?()
            }
            alertController.addAction(action)
        }
        self.currentViewController?.present(alertController, animated: true) {
        }
        
    }
    
}

extension UtilityManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @discardableResult
    func presentUIImagePickerController(withSourceType sourceType: UIImagePickerController.SourceType = .camera, allowsEditing: Bool = false, mediaTypes: [CFString] = [kUTTypeImage], cancelPicking: MediaPickingCancelBlock? = nil, finishPicking: MediaPickingCompletionBlock?) -> Bool {
        
        if ((sourceType == .camera && UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) || (sourceType == .photoLibrary && UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary))) {
            let imagePickerController = UIImagePickerController.init()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = allowsEditing
            imagePickerController.videoQuality = .typeHigh
            imagePickerController.sourceType = sourceType
            imagePickerController.mediaTypes = mediaTypes.map({$0 as String})//[kUTTypeMovie as String, kUTTypeImage as String]
            self.didCancelPickingMedia = cancelPicking
            self.didFinishPickingMedia = finishPicking
            self.currentViewController?.present(imagePickerController, animated: true, completion: {
            })
            return true
        } else {
            return false
        }
        
    }
    
    func presentUIImagePickerControllerSourceTypeActionSheet(allowsEditing: Bool = false, mediaTypes: [CFString] = [kUTTypeImage], cancelPicking: MediaPickingCancelBlock? = nil, finishPicking: MediaPickingCompletionBlock?) {
        
        let alertController = UIAlertController.init(title: "Choose source type", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let actionCamera = UIAlertAction.init(title: "Camera", style: UIAlertAction.Style.default) { (alertAction) in
            self.presentUIImagePickerController(withSourceType: UIImagePickerController.SourceType.camera, allowsEditing: allowsEditing, mediaTypes: mediaTypes, cancelPicking: cancelPicking, finishPicking: finishPicking)
        }
        let actionPhotoLibrary = UIAlertAction.init(title: "Photo library", style: UIAlertAction.Style.default) { (alertAction) in
            self.presentUIImagePickerController(withSourceType: UIImagePickerController.SourceType.photoLibrary, allowsEditing: allowsEditing, mediaTypes: mediaTypes, cancelPicking: cancelPicking, finishPicking: finishPicking)
        }
        let actionCancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { (alertAction) in
        }
        
        alertController.addAction(actionCamera)
        alertController.addAction(actionPhotoLibrary)
        alertController.addAction(actionCancel)
        
        self.currentViewController?.present(alertController, animated: true, completion: {
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            self.didFinishPickingMedia?(info)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.didCancelPickingMedia?()
        }
    }
    
}

extension UtilityManager {
    
    func documentDirectoryPath() -> String {
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        return documentDirectory!
        
    }
    
    func downloadDirectoryPath() -> String {
        
        let fileManager = FileManager.default
        let documentDirectory = UtilityManager.shared.documentDirectoryPath()
        let downloadDirectory = documentDirectory.appending("/Downloads")
        if !(fileManager.fileExists(atPath: downloadDirectory)) {
            do {
                try fileManager.createDirectory(atPath: downloadDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory: \(error)")
            }
        }
        return downloadDirectory
        
    }
    
    func getUniqueFilename() -> String {
        let uniqueName = Date.stringDate(fromDate: Date.init(), dateFormat: DateFormat.uniqueString)
        return uniqueName!
    }
    
}

extension UtilityManager {
    
    func isNonEmptyString(_ text: String?) -> Bool {
        return (text?.count ?? 0) > 0
    }
    
    func isValidEmail(_ email: String?) -> Bool {
        if (email?.count ?? 0) > 0 {
            let regexPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            do {
                let regex = try NSRegularExpression.init(pattern: regexPattern, options: NSRegularExpression.Options.caseInsensitive)
                let regexMatches = regex.numberOfMatches(in: email!, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: email!.count))
                if regexMatches == 0 {
                    return false
                } else {
                    return true
                }
            } catch {
                print(error)
            }
        }
        return false
    }
    
}

extension UtilityManager {
    
    func openMail(withSenderEmail to: String, subject: String?, body: String?) {
        let stringURL = "mailto:\(to)?subject=\(subject ?? "")&body=\(body ?? "")"
        if let url = URL.init(string: stringURL.encodedURLQuery()) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { (_) in
                }
            }
        }
    }
    
    func shareURL(_ stringURL: String?, sourceView: UIView?) {
        
        if stringURL?.count ?? 0 > 0 {
            let activityViewController = UIActivityViewController.init(activityItems: [stringURL ?? ""], applicationActivities: nil)
            activityViewController.excludedActivityTypes = nil
            activityViewController.popoverPresentationController?.sourceView = sourceView ?? self.currentViewController?.view
            if sourceView != nil {
                activityViewController.popoverPresentationController?.sourceRect = sourceView!.bounds
            }
            activityViewController.popoverPresentationController?.permittedArrowDirections = [.up, .down]
            self.currentViewController?.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    
}

extension UtilityManager: SFSafariViewControllerDelegate {
    
    func presentSafariViewController(withURL stringURL: String?) {
        if let url = URL.init(string: stringURL ?? "") {
            let safariVC = SFSafariViewController.init(url: url)
            safariVC.delegate = self.currentViewController as? SFSafariViewControllerDelegate
            self.currentViewController?.present(safariVC, animated: true) {
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
        }
    }
    
}
