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
                user.name = n
                user.dob = d
                print("Name: \(user.name!); DOB: \(user.dob!);")
            }
        } catch let error as NSError {
          print("Could not retrieve user. \(error), \(error.userInfo)")
        }
        return user
    }
    
    func EditUser(newUser:User) {
        var userList:[NSManagedObject] = []
        let context = appDelegate.persistentContainer.viewContext
                
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataUser")
        do {
            userList = try context.fetch(fetchRequest)
            
            for u in userList {
                u.setValue(newUser.name, forKeyPath: "user_name")
                u.setValue(newUser.dob, forKeyPath: "user_dob")
                // check
                let name = u.value(forKeyPath: "user_name") as? String
                let dob = u.value(forKeyPath: "user_dob") as? Date
                print("Updated: \(name!), \(dob!)")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
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
    
    func deleteDiary(diary_date:Date){
        var diaryList:[NSManagedObject]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataDiary")
        do{
            diaryList = try context.fetch(fetchRequest)
            for d in diaryList{
                let dDate = d.value(forKeyPath: "diary_date") as! Date
                if dDate == diary_date{
                    context.delete(d)
                }
                try context.save()
            }
        } catch let error as NSError{
            print("Could not delete. \(error) \(error.userInfo)")
        }
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
            cdFeelings.feeling_rgb = feelings.feeling_rgb
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
                print("special added")
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
                print("reflect added")
                try context.save()
            } catch let error as NSError{
                print("Could not add. \(error) \(error.userInfo)")
            }
        }
    }
    
    //Retrieve Predicate Functions
    func RetrieveDiaryEntriesinUser(user:User)->[Diary]{
        var diaryList:[Diary] = []
        var managedDiaryList:[NSManagedObject]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataDiary")
        fetchRequest.predicate = NSPredicate(format: "ANY existsIn.user_name = %@", user.name!)
        do{
            managedDiaryList = try context.fetch(fetchRequest)
            for m in managedDiaryList{
                let feeling = m.value(forKeyPath: "diary_feeling") as! String
                let date = m.value(forKeyPath: "diary_date") as! Date
                let diary = Diary(feeling: feeling, date: date)
                diaryList.append(diary)
            }
        } catch let error as NSError{
            print("Could not retrieve diary entries in user. \(error) \(error.userInfo)")
        }
        return diaryList
    }
    
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
            let rgb = managedFeelingList[0].value(forKeyPath: "feeling_rgb") as! String
            print(name)
            feeling = Feelings(feeling_name: name, feeling_rgb: rgb, feeling_image: image, feeling_date: date)
        } catch let error as NSError{
            print("Could not fetch. \(error) \(error.userInfo)")
        }
        return feeling!
    }
    
    func RetrieveSpecialinDiary(diary:Diary)->Special{
        var special:Special?
        var managedSpecialList:[NSManagedObject]=[]
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataSpecial")
        fetchRequest.predicate = NSPredicate(format: "ANY speExistsIn.diary_date = %@", argumentArray: [diary.date!])
        do{
            managedSpecialList = try context.fetch(fetchRequest)
            let caption = managedSpecialList[0].value(forKeyPath: "special_caption") as! String
            let date = managedSpecialList[0].value(forKeyPath: "special_date") as! Date
            let image =  UIImage(data: managedSpecialList[0].value(forKeyPath: "special_image") as! Data)
            let location = managedSpecialList[0].value(forKeyPath: "special_location") as! String
            print(caption)
            special = Special(special_caption: caption, special_location: location, special_date: date, special_image: image!)
        } catch let error as NSError{
            print("Could not fetch special inputs in diary. \(error) \(error.userInfo)")
        }
        return special!
    }
    
    func RetrieveReflectioninDiary(diary:Diary)->Reflection{
        var reflect:Reflection?
        var managedReflectList:[NSManagedObject] = []
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataReflection")
        fetchRequest.predicate = NSPredicate(format: "ANY refExistsIn.diary_date = %@", argumentArray: [diary.date!])
        do{
            managedReflectList = try context.fetch(fetchRequest)
            let title = managedReflectList[0].value(forKeyPath: "ref_title") as! String
            let date = managedReflectList[0].value(forKeyPath: "ref_date") as! Date
            let body = managedReflectList[0].value(forKeyPath: "ref_body") as! String
            print(title)
            reflect = Reflection(ref_title: title, ref_body: body, ref_date: date)
        } catch let error as NSError{
            print("Could not fetch. \(error) \(error.userInfo)")
        }
        return reflect!
    }
}
