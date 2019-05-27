//
//  ServiceManager.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import UIKit

class ServiceManager: NSObject {
    
    static let shared = ServiceManager.init()
    
    let serverCommunicationManager: ServerCommunicationManager
    
    override init() {
        self.serverCommunicationManager = ServerCommunicationManager.init()
    }
    
}
