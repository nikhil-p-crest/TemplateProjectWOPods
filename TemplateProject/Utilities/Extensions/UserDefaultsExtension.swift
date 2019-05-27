//
//  UserDefaultsExtension.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    class func saveObject(_ object: Any?, forKey key: String){
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getObject(forKey key: String) -> Any? {
        let object = UserDefaults.standard.object(forKey: key) as? Data
        if object == nil {
            return nil
        }
        let model = NSKeyedUnarchiver.unarchiveObject(with: object!)
        return model
    }
    
    class func saveString(_ value: String?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getString(forKey key: String) -> String? {
        let value = UserDefaults.standard.string(forKey: key)
        return value
    }
    
    class func saveInt(_ value: Int?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getInt(forKey key: String) -> Int {
        let value = UserDefaults.standard.integer(forKey: key)
        return value
    }
    
    class func saveFloat(_ value: Float?, forKey key: String) {
        UserDefaults.standard.set(value ?? 0, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getFloat(forKey key: String) -> Float {
        let value = UserDefaults.standard.float(forKey: key)
        return value
    }
    
    class func saveDouble(_ value: Double?, forKey key: String) {
        UserDefaults.standard.set(value ?? 0, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getDouble(forKey key: String) -> Double {
        let value = UserDefaults.standard.double(forKey: key)
        return value
    }
    
    class func saveBool(_ value: Bool?, forKey key: String) {
        UserDefaults.standard.set(value ?? false, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getBool(forKey key: String) -> Bool {
        let value = UserDefaults.standard.bool(forKey: key)
        return value
    }
    
    class func saveArray(_ value: [Any]?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getArray(forKey key: String) -> [Any]? {
        let value = UserDefaults.standard.array(forKey: key)
        return value
    }
    
    class func removeObject(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}
