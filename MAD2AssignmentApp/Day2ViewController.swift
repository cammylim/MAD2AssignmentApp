//
//  Day2ViewController.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 22/1/22.
//

import Foundation
import UIKit

class Day2ViewController:UIViewController, TagListViewDelegate{
    
    var tagList:[String]?
    var tag:String?
    var tagView:TagView?
    @IBOutlet weak var tagListView: TagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
        tagListView.textFont = UIFont(name: "BalsamiqSans-Regular", size: 16)!
        setTags()
    }
    func setTags(){
        tagList = ["Shopping", "Exercise", "Gardening"]
        var i = 0
        while i < tagList!.count {
            i += 1
            tagView = tagListView.addTag(tagList![i])
            tagView!.onTap = {[weak self] tagView in
                self?.tagListView.tagPressed(tagView)
            }
        }
    }
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
            print("Tag pressed: \(title), \(sender)")
        }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
            print("Tag Remove pressed: \(title), \(sender)")
            sender.removeTagView(tagView)
        }
}

