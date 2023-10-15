//
//  Extension+DateFormatter.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 10.10.2023.
//

import Foundation

extension DateFormatter {
    
    static func dateFormatterFromStringToDate(_ dateInString: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: dateInString) ?? Date()
        return date
    }
    
    static func dateFormatterFromDateToString(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    static func formatterRoundingToNearestHour(from dateInString: String, format: String) -> String {
        let date = self.dateFormatterFromStringToDate(dateInString, format: "yyyy-MM-dd HH:mm")
        return self.dateFormatterFromDateToString(date, format: format)
    }
    
    static func currentDateIn(_ timeZone: String, format: String) -> String {
        guard let citiesTimeZone = TimeZone(identifier: timeZone) else { return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = citiesTimeZone
        dateFormatter.dateFormat = format
        let currentDate = dateFormatter.string(from: Date())
        return currentDate
    }
    
    static func currentDayAndMonth(from dateInString: String, format: String) -> String {
        let date = self.dateFormatterFromStringToDate(dateInString, format: "yyyy-MM-dd")
        return self.dateFormatterFromDateToString(date, format: format)
    }
}
