//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/1/24.
//

import Foundation

public enum TimeDuration: Codable, Equatable {
    case minutes(Int)
    case hours(Int)
    case days(Int)
    case weeks(Int)
    case months(Int)
    case years(Int)
}

extension TimeDuration {
    public var value: Int {
        switch self {
        case .minutes(let value)
            , .hours(let value)
            , .days(let value)
            , .weeks(let value)
            , .months(let value)
            , .years(let value): return value
        }
    }
    
    /// The value actually used in the calculation. Weeks are calculated as 7 days, so their value is multiplied.
    internal var computationalValue: Int {
        switch self {
        case .minutes(let value)
            , .hours(let value)
            , .days(let value)
            , .months(let value)
            , .years(let value): return value
            
        case .weeks(let value): return value*7
        }
    }
    
    /// The calander compnent of the duration used in calculations. Weeks are calculated as 7 days, so they use days.
    internal var component: Calendar.Component {
        switch self {
        case .minutes(_): .minute
        case .hours(_): .hour
        case .days(_): .day
        case .weeks(_): .day
        case .months(_): .month
        case .years(_): .year
        }
    }
}

extension Date {
    public func adding(_ duration: TimeDuration, using calendar: Calendar = .current) -> Date? {
        return calendar.date(byAdding: duration.component, value: duration.computationalValue, to: self)
    }
    
    public func subtracting(_ duration: TimeDuration, using calendar: Calendar = .current) -> Date? {
        return calendar.date(byAdding: duration.component, value: -(duration.computationalValue), to: self)
    }
}

