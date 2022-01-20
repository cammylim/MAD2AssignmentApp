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
    
    func addMonth(date:Date) -> Date{
        return diary.date(byAdding: .month, value: 1, to: date)!
    }
    func minusMonth(date:Date) -> Date{
        return diary.date(byAdding: .month, value: -1, to: date)!
    }
    func dayText(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    func monthText(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    func yearText(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    func totalDaysInMonth(date:Date)->Int{
        let range = diary.range(of: .day, in: .month, for: date)!
        return range.count
    }
    func totalDaysOfMonth(date:Date)->Int{
        let components = diary.dateComponents([.day], from: date)
        return components.day!
    }
    func firstDayOfMonth(date:Date)->Date{
        let components = diary.dateComponents([.year, .month], from: date)
        return diary.date(from: components)!
    }
    func weekDay(date:Date)->Int{
        let components = diary.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
}
