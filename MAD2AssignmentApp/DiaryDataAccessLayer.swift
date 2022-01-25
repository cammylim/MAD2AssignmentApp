//
//  UserDataAccessLayer.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 23/1/22.
//

import Foundation
import CoreData
import UIKit

class DiaryDataAccessLayer {
    func UserExist() -> Bool {

        var exist: Bool = false

        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataUser")
        do {
            let userlist:[NSManagedObject] = try context.fetch(fetchRequest)

            if (!userlist.isEmpty) {
                exist = true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        print("Any exisitng users? \(exist)")

        return exist
    }

    func AddUser(user:User) {
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: "CoreDataUser", in: context)!
        let cduser:NSManagedObject = NSManagedObject(entity: entity, insertInto: context)

        cduser.setValue(user.name, forKeyPath:"user_name")
        cduser.setValue(user.dob, forKeyPath:"user_dob")
        

        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func RetrieveUser() -> User {
        let user:User = User(name: "", dob: Date())
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataUser")
        do {
            let userlist:[NSManagedObject] = try context.fetch(fetchRequest)
            
            for u in userlist {
                let n = u.value(forKeyPath: "user_name") as! String
                let d = u.value(forKeyPath: "user_dob") as! Date
                // TODO: get profile pic
                user.name = n
                user.dob = d
                //TODO: set profile pic
                print("Name: \(user.name!); DOB: \(user.dob!); Picture: \(user.picture!)")
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        return user
    }
    
    //TODO: addimage/changeimage (profile pic)
    
    
}
