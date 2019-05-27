//
//  DateExtension.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import Foundation

enum DateFormat {
    
    case defaultDateTimeUS
    case defaultDateTimeUK
    case defaultDateUS
    case defaultDateUK
    case time24HrsWithSeconds
    case time24HrsWithoutSeconds
    case time12HrsWithSeconds
    case time12HrsWithoutSeconds
    case ddMMyyyyTime12HrsWithoutSecondsWithDashSpace
    case MMMMdd
    case MMMdd
    case dd
    case monthNumeric1Digit
    case monthNumeric2Digits
    case year2Digits
    case year4Digits
    case uniqueString
    case dateChatAT
    case EEE
    case EEEE
    case yyyyMMddHHmmssWithDashSpaceColon
    
    var value: String {
        switch self {
        case .defaultDateTimeUS:                                return "MM-dd-yyyy HH:mm:ss"
        case .defaultDateTimeUK:                                return "dd-MM-yyyy HH:mm:ss"
        case .defaultDateUS:                                    return "MM-dd-yyyy"
        case .defaultDateUK:                                    return "dd-MM-yyyy"
        case .time24HrsWithSeconds:                             return "HH:mm:ss"
        case .time24HrsWithoutSeconds:                          return "HH:mm"
        case .time12HrsWithSeconds:                             return "hh:mm:ss a"
        case .time12HrsWithoutSeconds:                          return "hh:mm a"
        case .ddMMyyyyTime12HrsWithoutSecondsWithDashSpace:     return "dd-MM-yyyy hh:mm a"
        case .MMMMdd:                                           return "MMMM dd"
        case .MMMdd:                                            return "MMM dd"
        case .dd:                                               return "dd"
        case .monthNumeric1Digit:                               return "M"
        case .monthNumeric2Digits:                              return "MM"
        case .year2Digits:                                      return "yy"
        case .year4Digits:                                      return "yyyy"
        case .uniqueString:                                     return "ddMMyyyyHHmmssSSSS"
        case .dateChatAT:                                       return "dd/MM/yyyy HH:mm:ss"
        case .EEE:                                              return "EEE"
        case .EEEE:                                             return "EEEE"
        case .yyyyMMddHHmmssWithDashSpaceColon:                 return "yyyy-MM-dd HH:mm:ss"
        }
    }
    
}

extension Date {
    
    static var dateFormatter: DateFormatter {
        let tempDateFormatter = DateFormatter.init()
        tempDateFormatter.locale = Locale.current
        tempDateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return tempDateFormatter
    }
    
    static func date(fromString stringDate: String?, dateFormat: DateFormat, isUTC: Bool = false) -> Date? {
        if ((stringDate?.count ?? 0) <= 0) {
            return nil
        }
        let dateFormatter = Date.dateFormatter
        dateFormatter.dateFormat = dateFormat.value
        if isUTC == true {
            dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        }
        let date = dateFormatter.date(from: stringDate!)
        return date
    }
    
    static func stringDate(fromDate date: Date?, dateFormat: DateFormat, isUTC: Bool = false) -> String? {
        if date == nil {
            return nil
        }
        let dateFormatter = Date.dateFormatter
        dateFormatter.dateFormat = dateFormat.value
        if isUTC == true {
            dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        }
        let stringDate = dateFormatter.string(from: date!)
        return stringDate
    }
    
    static func stringDate(fromString stringDate: String?, sourceDateFormat: DateFormat, destinationDateFormat: DateFormat) -> String? {
        let tempDate = Date.date(fromString: stringDate, dateFormat: sourceDateFormat)
        let finalStringData = Date.stringDate(fromDate: tempDate, dateFormat: destinationDateFormat)
        return finalStringData
    }
    
    static func date(fromTimestamp timestamp: Double?) -> Date? {
        if timestamp == nil {
            return nil
        }
        let date = Date.init(timeIntervalSince1970: timestamp!)
        return date
    }
    
    static func stringDate(fromTimestamp timestamp: Double?, dateFormat: DateFormat) -> String? {
        if timestamp == nil || timestamp == 0 {
            return nil
        }
        let date = Date.init(timeIntervalSince1970: timestamp!)
        return Date.stringDate(fromDate: date, dateFormat: dateFormat, isUTC: true)
    }
    
}

extension TimeInterval {
    
    init(fromTimestamp timestamp: Double) {
        var stringTimestamp = timestamp.string
        if stringTimestamp.contains(".") {
            stringTimestamp = stringTimestamp.components(separatedBy: ".").first ?? stringTimestamp
        }
        if stringTimestamp.count > 10 {
            var multipler: Double = 1
            let additional = stringTimestamp.count - 10
            for _ in 1...additional {
                multipler = multipler * 10
            }
            self = (timestamp / multipler)
            return
        }
        self = timestamp
    }
    
    init(fromDate date: Date) {
        let stringTimeInterval = date.timeIntervalSince1970.string
        if stringTimeInterval.contains(".") {
            let timeInterval = stringTimeInterval.components(separatedBy: ".").first!
            self = timeInterval.toDouble()
        } else {
            self = stringTimeInterval.toDouble()
        }
    }
    
    static func current(isUTC: Bool = false, withBufferTime bufferTime: Double = 0) -> TimeInterval {
        if isUTC == true {
            let date = Date.init()
            let stringDate = Date.stringDate(fromDate: date, dateFormat: DateFormat.defaultDateTimeUS)
            if let currentUTCDate = Date.date(fromString: stringDate, dateFormat: DateFormat.defaultDateTimeUS, isUTC: isUTC) {
                var timeInterval = TimeInterval.init(fromDate: currentUTCDate)
                timeInterval = timeInterval + bufferTime
                return timeInterval
            }
        }
        var timeInterval = TimeInterval.init(fromDate: Date.init())
        timeInterval = timeInterval + bufferTime
        return timeInterval
    }
    
}

