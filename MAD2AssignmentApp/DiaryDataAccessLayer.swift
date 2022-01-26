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
            print("Could not fetch user. \(error), \(error.userInfo)")
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
            print("Could not add user. \(error), \(error.userInfo)")
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
                print("Name: \(user.name!); DOB: \(user.dob!);")
            }
        } catch let error as NSError {
          print("Could not retrieve user. \(error), \(error.userInfo)")
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
            print("Could not retrieve all diary entries. \(error), \(error.userInfo)")
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
                print("Could not fetch diary exist in user. \(error), \(error.userInfo)")
            }
        }
        return exist
    }
    
    //TODO: addimage/changeimage (profile pic)
    
    
    //Add Predicate Function - User
    func addDiaryToUser(user:User, diary:Diary){
        var uList:[NSManagedObject]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataUser")
        if(UserExist()){
            fetchRequest.predicate = NSPredicate(format: "user_name == %@", user.name!)
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
                print("Could not add diary to user. \(error), \(error.userInfo)")
            }
        }
    }
    
    //Add Predicate Functions - Diary
    func addActivitiestoDiary(diary:Diary, activity:Activities){
        var dList:[NSManagedObject]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataDiary")
        if(UserExist()){
            fetchRequest.predicate = NSPredicate(format: "diary_date == %@", diary.date! as CVarArg)
            let entity = NSEntityDescription.entity(forEntityName: "CoreDataActivities", in: context)!
            let cdActivity = NSManagedObject(entity: entity, insertInto: context) as! CoreDataActivities
            cdActivity.act_name = activity.act_name
            cdActivity.act_date = activity.act_date
            do{
                dList = try context.fetch(fetchRequest)
                let d = dList[0] as! CoreDataDiary
                d.addToHasActivities(cdActivity)
                try context.save()
            } catch let error as NSError{
                print("Could not add activities to diary. \(error) \(error.userInfo)")
            }
        }
    }
    
    func addFeelingstoDiary(diary:Diary, feelings:Feelings){
        var dList:[NSManagedObject]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataDiary")
        if(UserExist()){
            fetchRequest.predicate = NSPredicate(format: "diary_date == %@", diary.date! as CVarArg)
            let entity = NSEntityDescription.entity(forEntityName: "CoreDataFeelings", in: context)!
            let cdFeelings = NSManagedObject(entity: entity, insertInto: context) as! CoreDataFeelings
            cdFeelings.feeling_name = feelings.feeling_name
            cdFeelings.feeling_date = feelings.feeling_date
            cdFeelings.feeling_image = feelings.feeling_image
            do{
                dList = try context.fetch(fetchRequest)
                let d = dList[0] as! CoreDataDiary
                d.addToHasFeelings(cdFeelings)
                
                try context.save()
            } catch let error as NSError{
                print("Could not add. \(error) \(error.userInfo)")
            }
        }
    }
    
    func addSpecialtoDiary(diary:Diary, special:Special){
        var dList:[NSManagedObject]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataDiary")
        if(UserExist()){
            fetchRequest.predicate = NSPredicate(format: "diary_date == %@", diary.date! as CVarArg)
            let entity = NSEntityDescription.entity(forEntityName: "CoreDataSpecial", in: context)!
            let cdSpecial = NSManagedObject(entity: entity, insertInto: context) as! CoreDataSpecial
            cdSpecial.special_caption = special.special_caption
            cdSpecial.special_location = special.special_location
            cdSpecial.special_date = special.special_date
            cdSpecial.special_image = special.special_image?.pngData()
            do{
                dList = try context.fetch(fetchRequest)
                let d = dList[0] as! CoreDataDiary
                d.addToHasSpecial(cdSpecial)
                
                try context.save()
            } catch let error as NSError{
                print("Could not add. \(error) \(error.userInfo)")
            }
        }
    }
    
    func addReflectiontoDiary(diary:Diary, ref:Reflection){
        var dList:[NSManagedObject]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataDiary")
        if(UserExist()){
            fetchRequest.predicate = NSPredicate(format: "diary_date == %@", diary.date! as CVarArg)
            let entity = NSEntityDescription.entity(forEntityName: "CoreDataReflection", in: context)!
            let cdRef = NSManagedObject(entity: entity, insertInto: context) as! CoreDataReflection
            cdRef.ref_title = ref.ref_title
            cdRef.ref_body = ref.ref_body
            cdRef.ref_date = ref.ref_date
            do{
                dList = try context.fetch(fetchRequest)
                let d = dList[0] as! CoreDataDiary
                d.addToHasReflect(cdRef)
                
                try context.save()
            } catch let error as NSError{
                print("Could not add. \(error) \(error.userInfo)")
            }
        }
    }
    
    //Retrieve Predicate Functions
    
    func RetrieveFeelinginDiary(diary:Diary)->Feelings{
        var feeling:Feelings?
        var managedFeelingList:[NSManagedObject] = []
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataFeelings")
        fetchRequest.predicate = NSPredicate(format: "ANY feelingsExistIn.diary_date = %@", argumentArray: [diary.date!])
        do{
            managedFeelingList = try context.fetch(fetchRequest)
            let name = managedFeelingList[0].value(forKeyPath: "feeling_name") as! String
            let date = managedFeelingList[0].value(forKeyPath: "feeling_date") as! Date
            let image = managedFeelingList[0].value(forKeyPath: "feeling_image") as! String
            print(name)
            feeling = Feelings(feeling_name: name, feeling_image: image, feeling_date: date)
        } catch let error as NSError{
            print("Could not fetch. \(error) \(error.userInfo)")
        }
        return feeling!
    }
    
    //Delete Predicate Functions
    func DeleteDiaryinUser(user:User, diary:Diary){
        var uList:[NSManagedObject]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataUser")
        if(UserExist()){
            fetchRequest.predicate = NSPredicate(format: "user_name = %@", user.name!)
            let entity = NSEntityDescription.entity(forEntityName: "CoreDataDiary", in: context)!
            let cdDiary = NSManagedObject(entity: entity, insertInto: context) as! CoreDataDiary
            cdDiary.diary_date = diary.date
            cdDiary.diary_feeling = diary.feeling
            do{
                uList = try context.fetch(fetchRequest)
                let u = uList[0] as! CoreDataUser
                u.removeFromHas(cdDiary)
                try context.save()
                
            } catch let error as NSError{
                print("Could not delete diary from user. \(error) \(error.userInfo)")
            }
        }
    }
}
