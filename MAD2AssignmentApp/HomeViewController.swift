//
//  HomeViewController.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 17/1/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedDate = Date()
    var totalDays = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "home-bg.svg")!);
        setCellsView()
        setMonthView()

    }
    func setCellsView(){
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
        
    }
    func setMonthView(){
        totalDays.removeAll()
        let totalDaysInMonth = DiaryCalendar().totalDaysInMonth(date:selectedDate)
        let firstDayOfMonth = DiaryCalendar().firstDayOfMonth(date:selectedDate)
        let startingDays = DiaryCalendar().weekDay(date: firstDayOfMonth)
        
        var count:Int = 1
        
        while(count <=  42){
            if(count <= startingDays || count - startingDays > totalDaysInMonth){
                totalDays.append("")
            }
            else{
                totalDays.append(String(count-startingDays))
            }
            count+=1
        }
        monthLabel.text = DiaryCalendar().monthText(date: selectedDate)+" "+DiaryCalendar().yearText(date: selectedDate)
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalDays.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "diaCell", for: indexPath) as! DiaryCell
        cell.day.text = totalDays[indexPath.item]
        
        return cell
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = DiaryCalendar().minusMonth(date: selectedDate)
        setMonthView()
    }
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = DiaryCalendar().addMonth(date: selectedDate)
        setMonthView()
    }
    override open var shouldAutorotate: Bool{
        return false
    }
}

