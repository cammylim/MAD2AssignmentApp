//
//  FeelingsCell.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 20/1/22.
//

import Foundation
import UIKit

class FeelingsCell:UICollectionViewCell{
    
    @IBOutlet weak var feelingsLabel: UILabel!
    @IBOutlet weak var feelingsImage: UIImageView!
    
    func setup(with feelings:Feelings){
        feelingsLabel.text = feelings.feelings_name
        feelingsImage.image = feelings.feelings_image
    }
}
