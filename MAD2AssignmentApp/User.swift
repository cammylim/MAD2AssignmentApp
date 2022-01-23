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
    var picture:UIImage?
    
    init(name:String, dob:Date) {
        self.name = name
        self.dob = dob
        self.picture = UIImage(named: "home-profile.svg")
    }
}
