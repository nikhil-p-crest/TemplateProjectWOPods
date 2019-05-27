//
//  SocialUserModel.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import UIKit
import ObjectMapper

class SocialUserModel: NSObject, Mappable {
    
    var provider: Int = 0
    var token: String?
    var account_id: String?
    var first_name: String?
    var mobile: String?
    var email: String? {
        didSet {
            if self.email?.count ?? 0 > 0 {
                self.gmail = self.email?.encodedBase64()
            } else {
                self.gmail = nil
            }
        }
    }
    var gmail: String?
    var profile_image: String?
    var loginType: SocialMediaLoginType = .accountKit {
        didSet {
            self.provider = self.loginType.value
        }
    }
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    static func mappedObject(_ dictionary: Dictionary<String, Any>) -> SocialUserModel {
        return Mapper<SocialUserModel>().map(JSON: dictionary)! as SocialUserModel
    }
    
    // MARK: Object Mapper
    func mapping(map: Map) {
        provider        <- map["provider"]
        account_id      <- map["account_id"]
        first_name      <- map["first_name"]
        mobile          <- map["mobile"]
        gmail           <- map["gmail"]
    }
    
}
