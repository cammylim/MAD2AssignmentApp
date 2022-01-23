//
//  User.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 23/1/22.
//

import Foundation

class User {
    var user_id:String?
    var user_name:String?
    var user_dob:Date?
    
    init(user_id:String, user_name:String, user_dob:Date){
        self.user_id = user_id
        self.user_name = user_name
        self.user_dob = user_dob
    }
}
