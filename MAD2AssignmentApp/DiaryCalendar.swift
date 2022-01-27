//
//  DiaryCalendar.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 17/1/22.
//

import Foundation
import UIKit

class DiaryCalendar{
    let diary = Calendar.current
    
    //add month
    func addMonth(date:Date) -> Date{
        return diary.date(byAdding: .month, value: 1, to: date)!
    }
    
    //minus month
    func minusMonth(date:Date) -> Date{
        return diary.date(byAdding: .month, value: -1, to: date)!
    }
    
    //return hour
    func hour(date:Date)->Int{
        return diary.component(.hour, from: date)
    }
    
    //return day text (e.g. Tuesday)
    func dayText(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    //return month text (e.g. January)
    func monthText(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    //return year text (e.g. 2022)
    func yearText(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    //convert string to date via dd/MMMM/yyyy format (e.g. 01/January/2022)
    func StringtoDate(string:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MMMM/yyyy"
        return dateFormatter.date(from: string)!
    }
    
    //return total days in month
    func totalDaysInMonth(date:Date)->Int{
        let range = diary.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    //return the day of the date (e.g. 1)
    func dayOfMonth(date:Date)->Int{
        let components = diary.dateComponents([.day], from: date)
        return components.day!
    }
    
    //return the first day of the month
    func firstDayOfMonth(date:Date)->Date{
        let components = diary.dateComponents([.year, .month], from: date)
        return diary.date(from: components)!
    }
    
    //return the day of the week
    func weekDay(date:Date)->Int{
        let components = diary.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
}
