//
//  DiaryDAL.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 23/1/22.
//

import Foundation
import UIKit
import CoreData

class DiaryDAL{
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    init(){}
    
    //user exists
    func UserExist(user_id:String)->Bool{
        var exist:Bool = false
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataUser")
        do{
            let userlist:[NSManagedObject] = try context.fetch(fetchRequest)
            let id = userlist[0].value(forKeyPath: "user_id") as! String
            if (user_id==id){
                exist = true
            }
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return exist
    }
    
    //create user
    func createUser(user:User){
        let context = appDelegate.persistentContainer.viewContext
        if !(UserExist(user_id: user.user_id!)){
            let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: "CoreDataUser", in: context)!
            let cdUser:NSManagedObject = NSManagedObject(entity: entity, insertInto: context)
            cdUser.setValue(user.user_id, forKeyPath: "user_id")
            cdUser.setValue(user.user_name, forKeyPath: "user_name")
            cdUser.setValue(user.user_dob, forKeyPath: "user_dob")
            
            do{try context.save()} catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    //retrieve user
    func RetrieveUser()->User{
        var user:User!
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataUser")
        do{
            let userlist:[NSManagedObject] = try context.fetch(fetchRequest)
            let id = userlist[0].value(forKeyPath: "user_id") as! String
            let name = userlist[0].value(forKeyPath: "user_name") as! String
            let dob = userlist[0].value(forKeyPath: "user_dob") as! Date
            user = User(user_id: id, user_name: name, user_dob: dob)
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return user
    }
}
