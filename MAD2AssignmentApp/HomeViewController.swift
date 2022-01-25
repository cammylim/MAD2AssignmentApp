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
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    var selectedDate = Date()
    var selectedDay:String?
    var selectedMonth:String?
    var selectedYear:String?
    var totalDays = [String]()
    let diaryDAL:DiaryDataAccessLayer = DiaryDataAccessLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "home-bg.svg")!);
        dayLabel.text = DiaryCalendar().dayText(date: selectedDate) + ","
        dateLabel.text = DiaryCalendar().monthText(date: selectedDate) + " " + String(DiaryCalendar().totalDaysOfMonth(date: selectedDate))
        setGreetingView()
        setCellsView()
        setMonthView()

    }
    @IBAction func moodEntry(_ sender: Any) {
        self.performSegue(withIdentifier: "moodDiaryDetail", sender: self)
        
    }
    func setGreetingView(){
        var greetTime:String = ""
        var greetName:String = ""
        if (DiaryCalendar().hour(date: selectedDate) < 12){
            greetTime = "Good Morning, "
        }
        else if (DiaryCalendar().hour(date: selectedDate) < 17){
            greetTime = "Good Afternoon, "
        }
        else if (DiaryCalendar().hour(date: selectedDate) < 19){
            greetTime = "Good Evening, "
        }
        else{
            greetTime = "Good Night, "
        }
        greetName = diaryDAL.RetrieveUser().name!
        greetingLabel.text = greetTime + greetName
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
        return totalDays.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "diaCell", for: indexPath) as! DiaryCell
        cell.day.text = totalDays[indexPath.item]
        if (totalDays[indexPath.item] != ""){
            cell.layer.cornerRadius = 13.0
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "diaryDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "diaryDetail"){
            let indexPaths = self.collectionView.indexPathsForSelectedItems!
            let indexPath = indexPaths[0]
            guard let dayVC = segue.destination as? DayViewController else{
                return
            }
            dayVC.selectedDay = self.totalDays[indexPath.row]
            dayVC.selectedMonth = DiaryCalendar().monthText(date: selectedDate)
            dayVC.selectedYear = DiaryCalendar().yearText(date: selectedDate)
        }
        else if (segue.identifier == "moodDiaryDetail"){
            guard let dayVC = segue.destination as? DayViewController else{
                return
            }
            dayVC.selectedDay = String(DiaryCalendar().totalDaysOfMonth(date: selectedDate))
            dayVC.selectedMonth = DiaryCalendar().monthText(date: selectedDate)
            dayVC.selectedYear = DiaryCalendar().yearText(date: selectedDate)
        }
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

