//
//  CalendarAssistant.swift
//  SeniorSignal
//
//  Created by Christopher Anastasis on 12/1/23.
//

import Foundation
import UIKit

class CalendarAssistant {
    
    let calendar = Calendar.current
    
    // Ex: Given a date in December, return a date in January
    func plusMonth (date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    // Ex: Given a date in August, return a date in July
    func minusMonth (date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func monthString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"  // Returns month in text
        return dateFormatter.string(from: date)
    }
    
    func yearString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"  // Returns year as a number
        return dateFormatter.string(from: date)
    }
    
    // Returns amount of days in any given month
    func daysInMonth (date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    // Ex: Given the 25th of December, it will return 25
    func dayOfMonth (date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth (date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay (date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
}
