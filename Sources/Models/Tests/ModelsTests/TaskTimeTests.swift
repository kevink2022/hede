//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/2/24.
//

import XCTest
@testable import Models

fileprivate typealias I = Intervals

final class TaskTimeTests: XCTestCase {
    
    func test_newFromType() throws {
        let start = Date(timeIntervalSince1970: I.mar_1_2001_timestamp)
        let twoHoursLater = start.adding(.hours(2), using: I.gmtCalendar)
        
        let task = TaskTime.new(.task, from: start)
        let appointment = TaskTime.new(.appointment(.hours(2)), from: start)
        
        let taskStart = task.start
        let taskEnd = task.end
        let appointmentStart = appointment.start
        let appointmentEnd = appointment.end
        
        XCTAssertEqual(start, taskStart)
        XCTAssertEqual(nil, taskEnd)
        XCTAssertEqual(start, appointmentStart)
        XCTAssertEqual(twoHoursLater, appointmentEnd)
    }
    
    func test_newFromTime() throws {
        let oldStart = Date(timeIntervalSince1970: I.mar_1_2001_timestamp)
        let newStart = Date(timeIntervalSince1970: I.mar_1_2002_timestamp)
        let twoHoursLater = newStart.adding(.hours(2), using: I.gmtCalendar)

        let oldTask = TaskTime.new(.task, from: oldStart)
        let oldAppointment = TaskTime.new(.appointment(.hours(2)), from: oldStart)
        
        let newTask = oldTask.new(from: newStart)
        let newAppointment = oldAppointment.new(from: newStart)
        
        let taskStart = newTask.start
        let taskEnd = newTask.end
        let appointmentStart = newAppointment.start
        let appointmentEnd = newAppointment.end
        
        XCTAssertEqual(newStart, taskStart)
        XCTAssertEqual(nil, taskEnd)
        XCTAssertEqual(newStart, appointmentStart)
        XCTAssertEqual(twoHoursLater, appointmentEnd)
    }
}
