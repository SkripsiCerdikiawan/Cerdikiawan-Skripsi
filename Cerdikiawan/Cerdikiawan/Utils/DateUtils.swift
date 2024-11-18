//
//  DateUtils.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import Foundation

struct DateUtils {
    static func getDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID") // Set locale to Indonesian
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy" // Full day, date, month, and year format
        return dateFormatter.string(from: date)
    }
    
    static func getDate(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID") // Set locale to Indonesian
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy" // Full day, date, month, and year format
        return dateFormatter.date(from: string)
    }
    
    static func getTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID") // Optional, can use Indonesian locale
        dateFormatter.dateFormat = "HH:mm" // 24-hour format with hours and minutes
        return dateFormatter.string(from: date)
    }
}
