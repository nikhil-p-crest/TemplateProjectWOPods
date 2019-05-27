//
//  ServerCommunicationManager.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Reachability
import ObjectMapper

enum EnumWebService {
    
    case misc
    
    var url: String {
        var apiName = ""
        switch self {
        case .misc:                                             apiName = ""
        }
        return "\(ServerConstant.WebService.apiURL)\(apiName)"
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:                    return JSONEncoding.default
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:                    return HTTPMethod.get
        }
    }
    
    var isMultipart: Bool {
        switch self {
        default:                   return false
        }
    }
    
    var httpHeaders: HTTPHeaders? {
        switch self {
        default:    return nil
        }
    }
    
    var parameters:[String: Any]? {
        
        switch self {
            
        // MARK: default case
        default:
            return nil
            
        }
        
    }
    
}

class ServerCommunicationManager: NSObject {
    
    typealias APICompletion = (Bool, String, Int, Any?, Error?) -> Void
    
    let manager: SessionManager
    
    override init() {
        self.manager = Alamofire.SessionManager.default
    }
    
}

extension ServerCommunicationManager {
    
    @discardableResult
    func apiCall(forWebService webService: EnumWebService, completion:@escaping APICompletion) -> DataRequest? {
        
        if Constant.appDelegate.reachability.connection != .none {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            print("************* Request Parameters: *************\n\(JSON(webService.parameters ?? [:]).rawString() ?? "")\n***********************************************\n")
            
            if webService.isMultipart == true {
                self.multipartFormRequest(webService: webService, completion: completion)
            } else {
                let dataRequest = self.apiCall(withURL: webService.url, method: webService.httpMethod, parameters: webService.parameters, encoding: webService.encoding, headers: webService.httpHeaders, completion: completion, webService: webService)
                return dataRequest
            }
        } else {
            print("Internet connection not available.")
            completion(false, "Please check your network connection", 0, nil, nil)
        }
        return nil
        
    }
    
    fileprivate func apiCall(withURL stringURL: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders? = nil, completion:@escaping APICompletion, webService: EnumWebService = .misc) -> DataRequest {
        
        let dataRequest = self.manager.request(stringURL, method: method, parameters: parameters, encoding: encoding, headers: headers).validate(statusCode: [StatusCode.OK.code]).responseJSON { (dataResponse) in
            
            let tastInterval = (dataResponse.metrics?.taskInterval ?? DateInterval.init())
            
            print("\n************* Task Interval: *************\nRequest URL:\t\(dataResponse.request?.url?.absoluteString ?? "")\nTask Interval:\t\(tastInterval)\nDuration:\t\t\(tastInterval.duration)\n******************************************\n")
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            let statusCode = dataResponse.response?.statusCode ?? 0
            
            switch dataResponse.result {
                
            case .success(let value):
                ServerCommunicationManager.saveToken(dataResponse: dataResponse)
                self.handleSuccess(webService: webService, value: value, completion: { (status, message, response, error) in
                    completion(status, message, statusCode, response, error)
                })
                break
            case .failure(let error):
                self.handleError(dataResponse: dataResponse, error: error, completion: completion)
                break
            }
            
        }
        print("*********** curl request: ***********\n\(dataRequest.debugDescription)\n*************************************")
        return dataRequest
        
    }
    
    func multipartFormRequest(webService: EnumWebService, completion:@escaping APICompletion) {
        
        self.manager.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in webService.parameters ?? [:] {
                if let dataValue = value as? Data {
                    let filename = UtilityManager.shared.getUniqueFilename()
                    multipartFormData.append(dataValue, withName: key, fileName: "\(filename).png", mimeType: "image/png")
                } else if let stringValue = value as? String {
                    multipartFormData.append(stringValue.utf8Encoded(), withName: key)
                } else if let intValue = value as? Int {
                    multipartFormData.append("\(intValue)".utf8Encoded(), withName: key)
                } else {
                    print("Not added key: \(key)")
                }
            }
            
        }, to: webService.url) { (encodingResult) in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                let dataRequest = upload.responseJSON { dataResponse in
                    
                    let statusCode = dataResponse.response?.statusCode ?? 0
                    
                    switch dataResponse.result {
                    case .success(let value):
                        self.handleSuccess(webService: webService, value: value, completion: { (status, message, response, error) in
                            completion(status, message, statusCode, response, error)
                        })
                        break
                    case .failure(let error):
                        self.handleError(dataResponse: dataResponse, error: error, completion: completion)
                        break
                    }
                    
                }
                print("*********** curl request: ***********\n\(dataRequest.debugDescription)\n*************************************")
                
            case .failure(let error):
                self.handleError(error: error)
                completion(false, error.localizedDescription, 0, nil, error)
            }
            
        }
        
    }
    
}

extension ServerCommunicationManager {
    
//    fileprivate func loginUserAPIResponseHandler(responseDictionary: [String: Any]?) {
//        if  responseDictionary?.count ?? 0 > 0 {
//            let userModel = UserModel.mappedObject(responseDictionary!)
//            let data = NSKeyedArchiver.archivedData(withRootObject: userModel)
//            UserDefaults.saveObject(data, forKey: Constant.UserDefaultsKey.loginUserModel)
//        }
//    }
    
}

extension ServerCommunicationManager {
    
    fileprivate class func saveToken(dataResponse: DataResponse<Any>) {
        if let token = dataResponse.response?.allHeaderFields[ServerConstant.WebService.HttpHeader.Key.token] as? String, token.count > 0 {
            UserDefaults.saveString(token, forKey: Constant.UserDefaultsKey.loginToken)
        }
    }
    
    fileprivate class func getAuthorizeTokenHeader() -> HTTPHeaders? {
        if let token = UserDefaults.getString(forKey: Constant.UserDefaultsKey.loginToken) {
            var httpHeaders = HTTPHeaders.init()
            httpHeaders.updateValue("\(ServerConstant.WebService.HttpHeader.Value.token)\(token)", forKey: ServerConstant.WebService.HttpHeader.Key.authorization)
            return httpHeaders
        }
        return nil
    }
    
}

extension ServerCommunicationManager {
    
    func handleSuccess(webService: EnumWebService, value: Any, completion:@escaping (Bool, String, Any?, Error?) -> Void) {
        
        let responseJSON = JSON(value)
        print("************* Response: *************\n\(responseJSON)\n*************************************\n")
        
        let message = self.errorMessage(fromResponse: responseJSON)
        let data = self.dataObject(fromResponse: responseJSON)
        
        if data == nil {
            if responseJSON.dictionaryObject != nil {
                completion(true, message, responseJSON.dictionaryObject, nil)
            } else if responseJSON.arrayObject != nil {
                completion(true, message, responseJSON.arrayObject, nil)
            } else {
                if let errorMessageString = responseJSON.rawString() {
                    completion(false, errorMessageString, responseJSON, nil)
                } else {
                    completion(false, ServerConstant.WebService.defaultErrorMessage, nil, nil)
                }
            }
            return
        }
        
        switch webService {
        default:
            break
        }
        
        completion(true, message, data, nil)
        return
        
    }
    
    func handleError(error: Error?) {
        print("Error: \n\(error?.localizedDescription ?? "")\n")
    }
    
    func handleError(dataResponse: DataResponse<Any>, error: Error, completion:@escaping APICompletion) {
        self.handleError(error: error)
        let statusCode = dataResponse.response?.statusCode ?? 0
        if statusCode == StatusCode.Unauthorized.code {
            self.performLogout()
            return
        }
        if let responseData = dataResponse.data {
            do {
                let responseJSON = try JSON.init(data: responseData)
                print("************* Response: *************\n\(responseJSON)\n*************************************\n")
                let data = self.dataObject(fromResponse: responseJSON)
                let errorMessage = self.errorMessage(fromResponse: responseJSON)
                completion(false, errorMessage, statusCode, data, error)
                return
            } catch {
                completion(false, error.localizedDescription, statusCode, nil, error)
                return
            }
        }
        completion(false, error.localizedDescription, statusCode, nil, error)
        return
    }
    
}

extension ServerCommunicationManager {
    
    func dataDictionary(fromResponse response: JSON) -> [String: Any]? {
        let dataDictionary = response.dictionaryObject?[ServerConstant.WebService.Response.data] as? [String: Any]
        return dataDictionary
    }
    
    func dataArray(fromResponse response: JSON) -> [Any]? {
        let dataArray = response.dictionaryObject?[ServerConstant.WebService.Response.data] as? [Any]
        return dataArray
    }
    
    func dataObject(fromResponse response: JSON) -> Any? {
        if let dataDictionary = self.dataDictionary(fromResponse: response) {
            return dataDictionary
        } else {
            return self.dataArray(fromResponse: response)
        }
    }
    
    func errorMessage(fromResponse response: JSON) -> String {
        
        if let dataDictionary = self.dataDictionary(fromResponse: response) {
            if let arrayMessages = dataDictionary[ServerConstant.WebService.Response.alert] as? [String], arrayMessages.count > 0 {
                let message = arrayMessages.joined(separator: "\n")
                return message
            }
            if let message = dataDictionary[ServerConstant.WebService.Response.alert] as? String, message.count > 0 {
                return message
            }
        }
        return ""
        
    }
    
    func getErrorMessage(fromErrorDictionary errorDictionary: [String: Any]?) -> String? {
        if errorDictionary?.count ?? 0 > 0 {
            var arrayErrorMessages:[String] = []
            let keys = errorDictionary!.keys
            for key in keys {
                if let message = errorDictionary![key] as? String {
                    arrayErrorMessages.append(message)
                } else if let dictionary = errorDictionary![key] as? [String: Any] {
                    let keys = dictionary.keys
                    for key in keys {
                        if let message = dictionary[key] as? String {
                            arrayErrorMessages.append(message)
                        }
                    }
                }
            }
            let errorMessage = arrayErrorMessages.joined(separator: "\n")
            return errorMessage
        }
        return nil
        
    }
    
}

extension ServerCommunicationManager {
    
    func performLogout() {
        UserDefaults.removeObject(forKey: Constant.UserDefaultsKey.loginUserModel)
        SocialLoginManager.sharedManager.logout()
    }
    
}
