//
//  NSManagedObjectContextExtension.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func insert(intoEntity entity: String) -> NSManagedObject {
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entity, into: self)
        return managedObject
    }
    
    func insert(intoEntity entity: String, condition:String, _ args: CVarArg...) -> NSManagedObject {
        let array = self.getData(forEntity: entity, condition: condition, args: args)
        let managedObject = array.first ?? self.insert(intoEntity: entity)
        return managedObject
    }
    
    func getAllData(forEntity entity: String) -> [NSManagedObject] {
        let array = self.getData(forEntity: entity, condition: "")
        return array
    }
    
    func getData(forEntity entity: String, condition:String, _ args: CVarArg...) -> [NSManagedObject] {
        let array = self.getData(forEntity: entity, condition: condition, args: args)
        return array
    }
    
    fileprivate func getData(forEntity entity: String, condition:String, args: [CVarArg]) -> [NSManagedObject] {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.entity = entityDescription
        
        if condition.count > 0 {
            let predicate = NSPredicate.init(format: condition, arguments: getVaList(args))
            fetchRequest.predicate = predicate
        }
        
        var array = [NSManagedObject].init()
        do {
            array = try self.fetch(fetchRequest) as? [NSManagedObject] ?? []
        } catch {
            print(error)
        }
        
        return array
        
    }
    
    @discardableResult
    func deleteAllData(forEntity entity: String) -> Bool {
        let array = self.getAllData(forEntity: entity)
        for managedObject in array {
            self.delete(managedObject)
        }
        return self.commit()
    }
    
    @discardableResult
    func deleteData(forEntity entity: String, condition: String, _ args: CVarArg...) -> Bool {
        let array = self.getData(forEntity: entity, condition: condition, args: args)
        for managedObject in array {
            self.delete(managedObject)
        }
        return self.commit()
    }
    
    @discardableResult
    func commit() -> Bool {
        do {
            try self.save()
            return true
        } catch {
            print(error)
            return false
        }
    }
    
}
