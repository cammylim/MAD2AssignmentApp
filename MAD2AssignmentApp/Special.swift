//
//  Special.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 26/1/22.
//

import Foundation
import UIKit
class Special{
    var special_caption:String?
    var special_location:String?
    var special_date:Date?
    var special_image:UIImage?
    
    init(special_caption:String, special_location:String?, special_date:Date, special_image:UIImage){
        self.special_caption = special_caption
        self.special_location = special_location
        self.special_date = special_date
        self.special_image = special_image
    }
}
