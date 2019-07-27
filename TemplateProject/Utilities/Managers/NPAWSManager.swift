//
//  NPAWSManager.swift
//  circles
//
//  Created by Mac22 on 22/04/19.
//  Copyright © 2019 NP. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3

class NPAWSManager: NSObject {

    static var shared: NPAWSManager = {
        let instance = NPAWSManager.init()
        return instance
    }()
    
    var cognitoCredentialsProvider: AWSCognitoCredentialsProvider
    var serviceConfiguration: AWSServiceConfiguration
    
    let regionType: AWSRegionType = AWSRegionType.APSouth1
    
    override init() {
        self.cognitoCredentialsProvider = AWSCognitoCredentialsProvider.init(regionType: self.regionType, identityPoolId: AWSConstant.poolID.value)
        self.serviceConfiguration = AWSServiceConfiguration.init(region: self.regionType, credentialsProvider: self.cognitoCredentialsProvider)
        super.init()
    }
    
}

extension NPAWSManager {
    
    enum AWSConstant {
        
        case poolID
        case bucketName
        case accessKey
        
        var value: String {
            switch self {
            case .poolID:           return "ap-south-1:b6e5c1b4-9246-4863-bbfd-f110e12d2995"
            case .bucketName:       return "circle-img-bucket"
            case .accessKey:        return "AKIAYRBBYFATAZSJIONC"
            }
        }
        
    }
    
}

extension NPAWSManager {
    
    /// AWS configuration method call this method from AppDelegate (didFinishLaunchingWithOptions)
    func configureAWS() {
        AWSServiceManager.default()?.defaultServiceConfiguration = self.serviceConfiguration
    }
    
    /// To initialise AWS logs. Call this method from AppDelegate (didFinishLaunchingWithOptions)
    func initLogs() {
        AWSDDLog.sharedInstance.logLevel = .verbose
        let fileLogger: AWSDDFileLogger = AWSDDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        AWSDDLog.add(fileLogger)
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
    }
    
}

extension NPAWSManager {
    
    func uploadMedia(stringFilePath: String?, fileName: String, progressBlock: ((Double)->())? = nil, completion: ((Bool, String)->())? = nil) {
        
        if stringFilePath?.count ?? 0 <= 0 {
            completion?(false, "File not found.")
        }
        let url = URL.init(fileURLWithPath: stringFilePath!)
        do {
            let data = try Data.init(contentsOf: url)
            self.uploadMedia(data: data, fileName: fileName, progressBlock: progressBlock, completion: completion)
        } catch {
            completion?(false, error.localizedDescription)
        }
        
    }
    
    func uploadMedia(image: UIImage?, fileName: String, progressBlock: ((Double)->())? = nil, completion: ((Bool, String)->())? = nil) {
        
        if image == nil {
            completion?(false, "File not found.")
        }
        guard let data = image?.jpegData(compressionQuality: 0.1) else {
            completion?(false, "Cannot convert image to data.")
            return
        }
        self.uploadMedia(data: data, fileName: fileName, progressBlock: progressBlock, completion: completion)
        
    }
    
    func uploadMedia(data: Data?, fileName: String, progressBlock: ((Double)->())? = nil, completion: ((Bool, String)->())? = nil) {
        
        if data == nil {
            completion?(false, "Data not found.")
        }
        
        let transferUtilityMultiPartUploadExpression = AWSS3TransferUtilityMultiPartUploadExpression.init()
        transferUtilityMultiPartUploadExpression.progressBlock = { (transferUtilityMultiPartUploadTask, progress) in
            DispatchQueue.main.async {
                progressBlock?(progress.fractionCompleted)
            }
        }
        
        var transferUtilityMultiPartUploadCompletionHandlerBlock: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock
        transferUtilityMultiPartUploadCompletionHandlerBlock = { (transferUtilityMultiPartUploadTask, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion?(false, error!.localizedDescription)
                } else {
                    completion?(true, "")
                }
            }
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.uploadUsingMultiPart(data: data!, bucket: AWSConstant.bucketName.value, key: fileName, contentType: "text/plain", expression: transferUtilityMultiPartUploadExpression, completionHandler: transferUtilityMultiPartUploadCompletionHandlerBlock).continueWith { (transferUtilityMultiPartUploadTask) -> Any? in
            if transferUtilityMultiPartUploadTask.error != nil {
                print(transferUtilityMultiPartUploadTask.error!.localizedDescription)
            }
            if let result = transferUtilityMultiPartUploadTask.result {
                print(result)
            }
            return nil
        }
        
    }
    
    func downloadData(fileName: String, progressBlock: ((Double)->())? = nil, completion: ((Bool, String, Data?, URL?)->())? = nil) {
        
        let transferUtilityDownloadExpression = AWSS3TransferUtilityDownloadExpression.init()
        transferUtilityDownloadExpression.progressBlock = { (transferUtilityTask, progress) in
            DispatchQueue.main.async {
                progressBlock?(progress.fractionCompleted)
            }
        }
        
        var transferUtilityDownloadCompletionHandlerBlock: AWSS3TransferUtilityDownloadCompletionHandlerBlock
        transferUtilityDownloadCompletionHandlerBlock = { (tTransferUtilityDownloadTask, locationURL, data, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion?(false, error!.localizedDescription, data, locationURL)
                } else {
                    completion?(true, "", data, locationURL)
                }
            }
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.downloadData(fromBucket: AWSConstant.bucketName.value, key: fileName, expression: transferUtilityDownloadExpression, completionHandler: transferUtilityDownloadCompletionHandlerBlock).continueWith { (transferUtilityDownloadTask) -> Any? in
            if transferUtilityDownloadTask.error != nil {
                print(transferUtilityDownloadTask.error!.localizedDescription)
            }
            if let result = transferUtilityDownloadTask.result {
                print(result)
            }
            return nil
        }
        
    }
    
}
