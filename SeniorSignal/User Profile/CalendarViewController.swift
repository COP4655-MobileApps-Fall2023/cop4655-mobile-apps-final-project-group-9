//
//  CalendarViewController.swift
//  SeniorSignal
//
//  Created by Christopher Anastasis on 12/1/23.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellsView()
        setMonthView()
    }
    
    // Functions for UICollectionViewDelegate/DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        return cell
    }
    
    
    func setCellsView() {
        
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setMonthView() {
        
        totalSquares.removeAll()
        
        let daysInMonth = CalendarAssistant().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarAssistant().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarAssistant().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while (count <= 42) {
            
            if(count <= startingSpaces || count - startingSpaces > daysInMonth) {
                totalSquares.append("")
            }
            else {
                totalSquares.append(String(count - startingSpaces))
            }
            count = count + 1
        }
        
        monthLabel.text = CalendarAssistant().monthString(date: selectedDate) + " " + CalendarAssistant().yearString(date: selectedDate)
        
        collectionView.reloadData()
    }
    
    
    @IBAction func previousMonth(_ sender: Any) {
        
        selectedDate = CalendarAssistant().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        
        selectedDate = CalendarAssistant().plusMonth(date: selectedDate)
        setMonthView()
    }
}
