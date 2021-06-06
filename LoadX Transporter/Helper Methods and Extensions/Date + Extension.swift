//
//  Date + Extension.swift
//  LoadX Transporter
//
//  Created by CTS Move on 30/05/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

public extension TimeZone {
    static let UTC = TimeZone(identifier: "UTC")!
}

public extension Date{
    
    /** Convenience static method on Date class to construct a Date object from a supplied String.
    
     - Important: The date must be provided using timezone "UTC"
    - Parameters:
      - dateString: The string defining the date
      - format: Format of the provided date. Optional. Default is "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    - Returns: Data object constructed from the supplied string and format. Returns nill if the provided string is not valid according to the provided format.
     */
    static func date(fromString dateString: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", timeZone: TimeZone = TimeZone.UTC) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        return date
    }
    /**
     Convenience method to get `String` representation of `Date` object according to the provided string format.
     
     - Parameter format: Format in which the string is expected. Optional. Default is "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
     - Returns: `String` representation of the `Date`
     */
    func string(format:String="yyyy-MM-dd'T'HH:mm:ss.SSSZ", timezone: TimeZone = TimeZone.UTC) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timezone
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        return dateFormatter.string(from: self)
    }
    
    /// Convenience method to convert difference of date from a specific date in terms of Difference String.
    ///
    /// - Parameter date: Date from which the time difference is required
    /// - Returns: String representing difference between the two dates
    func offsetFrom(date: Date) -> String {
        let unitFlags:Set<Calendar.Component> = [.year,.month ,.day, .hour, .minute, .second]
        let difference = Calendar.current.dateComponents(unitFlags, from: self,to:date)
        
        let minutes = "\(difference.minute!)m" + " "
        let hours = "\(difference.hour!)h" + " " + minutes
        let days = "\(difference.day!)d" + " " + hours
        let month = "\(difference.month!)M" + " " + days
        
        if difference.month! > 0  { return month}
        if difference.day!   > 0 { return days }
        if difference.hour!  > 0 { return hours }
        if difference.minute! > 0 { return minutes }
        return ""
    }
    
    /// Returns the number of Calender units intervals from another date.
    ///
    /// - Parameters:
    ///   - unit: The Calender unit for which number of intervals are required. E.g: Calender.Component.day or Calender.Component.minute
    ///   - fromDate: The date from which the interval is required
    /// - Returns: The number of unit intervals from the provided date
    func offsetBy(unit: Calendar.Component, fromDate:Date) -> Int{
        let unitFlags:Set<Calendar.Component> = [unit]
        let difference = Calendar.current.dateComponents(unitFlags, from: fromDate, to: self)
        
        var result:Int!
        switch unit {
        case .year:
            result = difference.year ?? 0
        case .month:
            result = difference.month ?? 0
        case .day:
            result = difference.day ?? 0
        case .hour:
            result = difference.hour ?? 0
        case .minute:
            result = difference.minute ?? 0
        case .second:
            result = difference.second ?? 0
        case .nanosecond:
            result = difference.second ?? 0
        default:
            result = 0
        }
        
        return result
    }
    
    /// Returns a date formatter string with UTC timezone
    var utcValue: String {
        let dateFormater = DateFormatter()
        dateFormater.calendar = Calendar.current
        dateFormater.timeZone = TimeZone(abbreviation: "UTC")
        let currentTimeString = dateFormater.string(from: self)
        return currentTimeString
    }
    
    /// Returns string for current time
    static var timeStamp: String {
        let date = Date().timeIntervalSince1970
        return "\(date)"
    }
    
    func comapreTime(date: Date) -> ComparisonResult {
        let currentSecs = secondsSinceBeginningOfDay(date: self)
        let otherSecs = secondsSinceBeginningOfDay(date: date)
        if currentSecs < otherSecs {
            return .orderedAscending
        }else if currentSecs > otherSecs {
            return .orderedDescending
        }else {
            return .orderedSame
        }
    }
    private func secondsSinceBeginningOfDay(date: Date) -> Int {
        let component = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hours = (component.hour ?? 0) * 3600
        let min = (component.minute ?? 0) * 60
        return hours + min
    }
}
 extension Date{
    /// Check if date is in future.
    ///
    ///     Date(timeInterval: 100, since: Date()).isInFuture -> true
    ///
    public var isInFuture: Bool {
        return self > Date()
    }
    
    
    /// Check if date is in past.
    ///
    ///     Date(timeInterval: -100, since: Date()).isInPast -> true
    ///
    public var isInPast: Bool {
        return self < Date()
    }
    
    /// Check if date is within today.
    ///
    ///     Date().isInToday -> true
    ///
    public var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    public func getDateFrom(dateStyle: DateStyle, timezone: TimeZone = .current) -> String {
        let dateFormate = DateFormatter()
        
        //Stop converting date to other language
        dateFormate.locale = Locale(identifier: "en_US_POSIX")

        dateFormate.timeZone = timezone
        switch dateStyle {
        case .short:
            dateFormate.dateStyle = .short
        case .shortTime:
            dateFormate.timeStyle = .short
        case .dateWithMonthName:
            dateFormate.dateFormat = "dd MMM"
            return dateFormate.string(from: self)
        default:
            dateFormate.dateStyle = .full
        }
        let formattedDate = dateFormate.string(from: self)
        return formattedDate
    }
    
    public func getDateComponents() -> (hour:Int, minutes: Int, seconds: Int){
        var calendar = Calendar.current
        calendar.timeZone = .UTC
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let seconds = calendar.component(.second, from: self)
        print("hours = \(hour):\(minutes):\(seconds)")
        return (hour, minutes, seconds)
    }
    
}
public enum DateStyle: Int {

    case short = 1// 11/23/20
    case shortTime = 2 // 3:30 Pm
    case dateWithMonthName =  3// 5 july

//    case medium = 2
//
//    case long = 3
//
//    case full = 4
    
}
