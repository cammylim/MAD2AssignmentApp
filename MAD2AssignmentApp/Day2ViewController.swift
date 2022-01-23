//
//  Day2ViewController.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 22/1/22.
//

import Foundation
import UIKit

class Day2ViewController:UIViewController, TagListViewDelegate{
    
    var tagList:[String]!
    var tag:String?
    var tagView:TagView!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var otherTagsField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
        tagListView.delegate = self
        tagListView.textFont = UIFont(name: "BalsamiqSans-Regular", size: 16)!
        setTags()
    }
    
    func setTags(){
        tagList = ["Shopping", "Exercise", "Gardening"]
        var i = 0
        while i < tagList!.count {
            tagView = tagListView.addTag(tagList[i])
            self.tagListView.tagPressed(tagView)
            tagView.isSelected = false
            i += 1
        }
    }
    @IBAction func closeButton(_ sender: Any) {
    }
    @IBAction func backButton(_ sender: Any) {
    }
    @IBAction func addOthersButton(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}

