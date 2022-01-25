//
//  Feelings.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 20/1/22.
//

import Foundation
import UIKit

class Feelings {
    var feeling_name:String?
    var feeling_image:String?
    var feeling_date:Date?
    
    init(feeling_name:String, feeling_image:String, feeling_date:Date){
        self.feeling_name = feeling_name
        self.feeling_image = feeling_image
        self.feeling_date = feeling_date
    }
}
