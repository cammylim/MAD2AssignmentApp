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
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    func UserExist() -> Bool {

        var exist: Bool = false
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
    
    //Diary Functions
    func RetrieveAllDiaryEntries()->[Diary]{
        var diaryList:[Diary]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataDiary")
        do{
            let entrylist:[NSManagedObject] = try context.fetch(fetchRequest)
            for e in entrylist{
                let date = e.value(forKeyPath: "diary_date") as! Date
                let feeling = e.value(forKeyPath: "diary_feeling") as! String
                let diary:Diary = Diary(feeling: feeling, date: date)
                diaryList.append(diary)
            }
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return diaryList
    }
    func DiaryExistinUser(user:User, diary:Diary)->Bool{
        var exist:Bool = false
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataDiary")
        if(UserExist()){
            fetchRequest.predicate = NSPredicate(format: "ANY existsIn.diary_date == %@ AND user_name == %@", diary.date! as CVarArg, user.name!)
            do{
                let dList:[NSManagedObject] = try context.fetch(fetchRequest)
                if !(dList.isEmpty){
                    exist = true
                }
            } catch let error as NSError{
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        return exist
    }
    
    //TODO: addimage/changeimage (profile pic)
    
    func addDiaryToUser(user:User, diary:Diary){
        var uList:[NSManagedObject]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataUser")
        if(UserExist()){
            fetchRequest.predicate = NSPredicate(format: "user_id == %@", user.name!)
            let entity = NSEntityDescription.entity(forEntityName: "CoreDataDiary", in: context)!
            let cdDiary = NSManagedObject(entity: entity, insertInto: context) as! CoreDataDiary
            cdDiary.diary_date = diary.date
            cdDiary.diary_feeling = diary.feeling
            do{
                uList = try context.fetch(fetchRequest)
                let u = uList[0] as! CoreDataUser
                u.addToHas(cdDiary)
                try context.save()
            } catch let error as NSError{
                print("Could not add. \(error), \(error.userInfo)")
            }
        }
    }
    
    //Activities Functions
    func RetrieveAllActivities()->[Activities]{
        var actList:[Activities]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"CoreDataActivities")
        do{
            let actlist:[NSManagedObject] = try context.fetch(fetchRequest)
            for a in actlist{
                let name = a.value(forKeyPath: "act_name") as! String
                let act:Activities = Activities(act_name: name)
                actList.append(act)
            }
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return actList
    }
    
    func addActivitiestoUser(user:User, activity:Activities){
        var uList:[NSManagedObject]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataUser")
        if(UserExist()){
            fetchRequest.predicate = NSPredicate(format: "user_name == %@", user.name!)
            let entity = NSEntityDescription.entity(forEntityName: "CoreDataActivities", in: context)!
            let cdActivity = NSManagedObject(entity: entity, insertInto: context) as! CoreDataActivities
            cdActivity.act_name = activity.act_name
            do{
                uList = try context.fetch(fetchRequest)
                let u = uList[0] as! CoreDataUser
                u.addToHasTags(cdActivity)
                try context.save()
            } catch let error as NSError{
                print("Could not add. \(error) \(error.userInfo)")
            }
        }
    }
}
