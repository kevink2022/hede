import XCTest
@testable import Models

final class ModelsTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}

internal class Intervals {
    static let gmtCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        return calendar
    }()
    
    static let mar_1_2001_timestamp: Double = 983404800
    
    static let feb_1_2001_timestamp: Double = 980985600
    static let apr_1_2001_timestamp: Double = 986083200
    
    static let mar_1_2002_timestamp: Double = 1014940800
    static let mar_1_2003_timestamp: Double = 1046476800
   

    static let feb_29_2004_timestamp: Double = 1078012800
    
    static let jan_30_2004_timestamp: Double = 1075420800
    static let mar_29_2004_timestamp: Double = 1080518400
    
    static let feb_28_2003_timestamp: Double = 1046390400
    static let feb_28_2005_timestamp: Double = 1109548800
    
    
    static let second_interval: Double = 1
    static let minute_interval: Double = second_interval * 60
    static let hour_interval: Double = minute_interval * 60
    static let day_interval: Double = hour_interval * 24
    static let week_interval: Double = day_interval * 7
}

internal class TestValues {
    static let time = Date(timeIntervalSince1970: Intervals.mar_1_2001_timestamp)
    static let time_2 = time.adding(.hours(1))!
    static let time_3 = time.adding(.days(1))!
    
    static let testLabel = "Test Label"
    static let testDescription = "Test Description"
    static let testLabel_2 = "Test Label 2"
    static let testDescription_2 = "Test Description 2"
    
    static let category = Key.new()
    static let pause_1 = Key.new()
    static let pause_2 = Key.new()
    
    static let pauses = [pause_1, pause_2]
}

/// Some tests to consider

/// - Domain
///     - Checking each time duration component
///     - Checking each task time
///     - Checking each task time type
///
///
/// - Generic tasks
///     - Calling `generateNew()` on generic
///     - Calling `complete()` on generic
///
///
/// - Todo tasks
///     - Create task
///     - Edit task
///     - Complete task
///     - Discard task
///
/// - Reccurring Task
///     - Create task
///         - No initial
///         - Initial
///     - Edit task
///     - Complete task (new task is created)
///     - Discard task
