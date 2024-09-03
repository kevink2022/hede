//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/2/24.
//

import XCTest
@testable import Models

fileprivate typealias I = Intervals

final class TimeDurationTests: XCTestCase {
    
    func test_minutes() throws {
        let baseDate = Date(timeIntervalSince1970: I.mar_1_2001_timestamp)
        let oneEarlier = Date(timeIntervalSince1970: I.mar_1_2001_timestamp - (1 * I.minute_interval))
        let oneLater = Date(timeIntervalSince1970: I.mar_1_2001_timestamp + (1 * I.minute_interval))
        
        let oneEarlier_Calculated = baseDate.subtracting(.minutes(1), using: I.gmtCalendar)
        let oneLater_Calculated = baseDate.adding(.minutes(1), using: I.gmtCalendar)
        
        let earlyToLate_Calculated = oneEarlier.adding(.minutes(2), using: I.gmtCalendar)
        let lateToEarly_Calculated = oneLater.subtracting(.minutes(2), using: I.gmtCalendar)
        
        XCTAssertEqual(oneEarlier, oneEarlier_Calculated)
        XCTAssertEqual(oneLater, oneLater_Calculated)
        XCTAssertEqual(oneLater, earlyToLate_Calculated)
        XCTAssertEqual(oneEarlier, lateToEarly_Calculated)
    }
    
    func test_hours() throws {
        let baseDate = Date(timeIntervalSince1970: I.mar_1_2001_timestamp)
        let oneEarlier = Date(timeIntervalSince1970: I.mar_1_2001_timestamp - (1 * I.hour_interval))
        let oneLater = Date(timeIntervalSince1970: I.mar_1_2001_timestamp + (1 * I.hour_interval))
        
        let oneEarlier_Calculated = baseDate.subtracting(.hours(1), using: I.gmtCalendar)
        let oneLater_Calculated = baseDate.adding(.hours(1), using: I.gmtCalendar)
        
        let earlyToLate_Calculated = oneEarlier.adding(.hours(2), using: I.gmtCalendar)
        let lateToEarly_Calculated = oneLater.subtracting(.hours(2), using: I.gmtCalendar)
        
        XCTAssertEqual(oneEarlier, oneEarlier_Calculated)
        XCTAssertEqual(oneLater, oneLater_Calculated)
        XCTAssertEqual(oneLater, earlyToLate_Calculated)
        XCTAssertEqual(oneEarlier, lateToEarly_Calculated)
    }
    
    func test_days() throws {
        let baseDate = Date(timeIntervalSince1970: I.mar_1_2001_timestamp)
        let oneEarlier = Date(timeIntervalSince1970: I.mar_1_2001_timestamp - (1 * I.day_interval))
        let oneLater = Date(timeIntervalSince1970: I.mar_1_2001_timestamp + (1 * I.day_interval))
        
        let oneEarlier_Calculated = baseDate.subtracting(.days(1), using: I.gmtCalendar)
        let oneLater_Calculated = baseDate.adding(.days(1), using: I.gmtCalendar)
        
        let earlyToLate_Calculated = oneEarlier.adding(.days(2), using: I.gmtCalendar)
        let lateToEarly_Calculated = oneLater.subtracting(.days(2), using: I.gmtCalendar)
        
        XCTAssertEqual(oneEarlier, oneEarlier_Calculated)
        XCTAssertEqual(oneLater, oneLater_Calculated)
        XCTAssertEqual(oneLater, earlyToLate_Calculated)
        XCTAssertEqual(oneEarlier, lateToEarly_Calculated)
    }
    
    func test_weeks() throws {
        let baseDate = Date(timeIntervalSince1970: I.mar_1_2001_timestamp)
        let oneEarlier = Date(timeIntervalSince1970: I.mar_1_2001_timestamp - (1 * I.week_interval))
        let oneLater = Date(timeIntervalSince1970: I.mar_1_2001_timestamp + (1 * I.week_interval))
        
        let oneEarlier_Calculated = baseDate.subtracting(.weeks(1), using: I.gmtCalendar)
        let oneLater_Calculated = baseDate.adding(.weeks(1), using: I.gmtCalendar)
        
        let earlyToLate_Calculated = oneEarlier.adding(.weeks(2), using: I.gmtCalendar)
        let lateToEarly_Calculated = oneLater.subtracting(.weeks(2), using: I.gmtCalendar)
        
        XCTAssertEqual(oneEarlier, oneEarlier_Calculated)
        XCTAssertEqual(oneLater, oneLater_Calculated)
        XCTAssertEqual(oneLater, earlyToLate_Calculated)
        XCTAssertEqual(oneEarlier, lateToEarly_Calculated)
    }
    
    func test_months() throws {
        let baseDate = Date(timeIntervalSince1970: I.mar_1_2001_timestamp)
        let oneEarlier = Date(timeIntervalSince1970: I.feb_1_2001_timestamp)
        let oneLater = Date(timeIntervalSince1970: I.apr_1_2001_timestamp)
        
        let baseDate_Calculated = oneEarlier
            .adding(.months(1), using: I.gmtCalendar)?
            .adding(.months(1), using: I.gmtCalendar)
        
        let oneEarlier_Calculated = baseDate.subtracting(.months(1), using: I.gmtCalendar)
        let oneLater_Calculated = baseDate.adding(.months(1), using: I.gmtCalendar)
        
        let earlyToLate_Calculated = oneEarlier.adding(.months(2), using: I.gmtCalendar)
        let lateToEarly_Calculated = oneLater.subtracting(.months(2), using: I.gmtCalendar)
        
        XCTAssertEqual(oneLater, baseDate_Calculated)
        XCTAssertEqual(oneEarlier, oneEarlier_Calculated)
        XCTAssertEqual(oneLater, oneLater_Calculated)
        XCTAssertEqual(oneLater, earlyToLate_Calculated)
        XCTAssertEqual(oneEarlier, lateToEarly_Calculated)
    }
    
    func test_years() throws {
        let baseDate = Date(timeIntervalSince1970: I.mar_1_2002_timestamp)
        let oneEarlier = Date(timeIntervalSince1970: I.mar_1_2001_timestamp)
        let oneLater = Date(timeIntervalSince1970: I.mar_1_2003_timestamp)
        
        let oneEarlier_Calculated = baseDate.subtracting(.years(1), using: I.gmtCalendar)
        let oneLater_Calculated = baseDate.adding(.years(1), using: I.gmtCalendar)
        
        let earlyToLate_Calculated = oneEarlier.adding(.years(2), using: I.gmtCalendar)
        let lateToEarly_Calculated = oneLater.subtracting(.years(2), using: I.gmtCalendar)
        
        XCTAssertEqual(oneEarlier, oneEarlier_Calculated)
        XCTAssertEqual(oneLater, oneLater_Calculated)
        XCTAssertEqual(oneLater, earlyToLate_Calculated)
        XCTAssertEqual(oneEarlier, lateToEarly_Calculated)
    }
    
    func test_months_leap() throws {
        let baseDate = Date(timeIntervalSince1970: I.feb_29_2004_timestamp)
        let oneEarlier = Date(timeIntervalSince1970: I.jan_30_2004_timestamp)
        let oneLater = Date(timeIntervalSince1970: I.mar_29_2004_timestamp)
        
        // Test for jumping to leap (30->29)
        let baseDate_Calculated = oneEarlier.adding(.months(1), using: I.gmtCalendar)
        
        let oneEarlier_Calculated = baseDate
            .subtracting(.months(1), using: I.gmtCalendar)?
            .adding(.days(1), using: I.gmtCalendar)
                
        let oneLater_Calculated = baseDate.adding(.months(1), using: I.gmtCalendar)
        
        let earlyToLate_Calculated = oneEarlier
            .adding(.months(2), using: I.gmtCalendar)?
            .subtracting(.days(1), using: I.gmtCalendar)
        
        let lateToEarly_Calculated = oneLater
            .subtracting(.months(2), using: I.gmtCalendar)?
            .adding(.days(1), using: I.gmtCalendar)
        
        XCTAssertEqual(baseDate, baseDate_Calculated)
        XCTAssertEqual(oneEarlier, oneEarlier_Calculated)
        XCTAssertEqual(oneLater, oneLater_Calculated)
        XCTAssertEqual(oneLater, earlyToLate_Calculated)
        XCTAssertEqual(oneEarlier, lateToEarly_Calculated)
    }
    
    func test_years_leap() throws {
        let baseDate = Date(timeIntervalSince1970: I.feb_29_2004_timestamp)
        let oneEarlier = Date(timeIntervalSince1970: I.feb_28_2003_timestamp)
        let oneLater = Date(timeIntervalSince1970: I.feb_28_2005_timestamp)
        
        let oneEarlier_Calculated = baseDate.subtracting(.years(1), using: I.gmtCalendar)
        // Test jumping from leap (29->28)
        let oneLater_Calculated = baseDate.adding(.years(1), using: I.gmtCalendar)
        
        let earlyToLate_Calculated = oneEarlier.adding(.years(2), using: I.gmtCalendar)
        let lateToEarly_Calculated = oneLater.subtracting(.years(2), using: I.gmtCalendar)
        
        XCTAssertEqual(oneEarlier, oneEarlier_Calculated)
        XCTAssertEqual(oneLater, oneLater_Calculated)
        XCTAssertEqual(oneLater, earlyToLate_Calculated)
        XCTAssertEqual(oneEarlier, lateToEarly_Calculated)
    }
}
