//
//  Feelings.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 20/1/22.
//

import Foundation
import UIKit

class Feelings {
    var feelings_name:String?
    var feelings_image:String?
    var feelings_date:Date?
    
    init(feelings_name:String, feelings_image:String, feelings_date:Date){
        self.feelings_name = feelings_name
        self.feelings_image = feelings_image
        self.feelings_date = feelings_date
    }
}
