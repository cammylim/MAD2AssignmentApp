//
//  User.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 23/1/22.
//

import Foundation
import UIKit

class User {
    var name:String?
    var dob:Date?
    var act:[String]?
    
    init(name:String, dob:Date, act:[String]) {
        self.name = name
        self.dob = dob
        self.act = act
    }
}
