//
//  Reflection.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 26/1/22.
//

import Foundation

class Reflection{
    var ref_title:String?
    var ref_body:String?
    var ref_date:Date?
    
    init(ref_title:String, ref_body:String?, ref_date:Date){
        self.ref_title = ref_title
        self.ref_body = ref_body
        self.ref_date = ref_date
    }
}
