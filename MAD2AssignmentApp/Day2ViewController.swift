//
//  Day2ViewController.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 22/1/22.
//

import Foundation
import UIKit

class Day2ViewController:UIViewController{
    
    var tagView:UIButton?
    @IBOutlet weak var tagListView: TagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
        tagListView.textFont = UIFont(name: "BalsamiqSans-Regular", size: 16)!
        tagView = tagListView.addTag("Shopping")
        tagView = tagListView.addTag("Exercise")
        tagView = tagListView.addTag("Gardening")
    }
}
