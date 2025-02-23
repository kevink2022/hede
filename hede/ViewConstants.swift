//
//  ViewConstants.swift
//  hede
//
//  Created by Kevin Kelly on 9/8/24.
//

import SwiftUI
import Models
import Domain

/// All of the typealiases used for `ViewConstants` in the system.
///
/// They will be included as fileprivate in each file they're used, similar to an import. Having global 1-2 character
/// types is bad practice, but they are useful with that are spread out. This achieves a good balance.

internal typealias A = ViewConstants.Animations
internal typealias C = ViewConstants.Colors
internal typealias F = ViewConstants.Fonts
internal typealias T = ViewConstants.Text
internal typealias V = ViewConstants
internal typealias SI = ViewConstants.SystemImages

/// The collection of all constants used in the UI.
struct ViewConstants {
    /// Any Text displayed by the UI.
    ///
    /// Should be replaced with localized strings in the future, but this will simplify that transition.
    struct Text {
        static let home = "Home"
        static let settings = "Settings"
        static let calendar = "Calendar"
        static let sources = "Sources"
        static let search = "Search"
        
        static let tasks = "Tasks"
        static let taskSources = "Task Sources"
        static let addSource = "Add Source"
        
        static let toDo = "To Do"
        static let toDoTasks = "To Do Tasks"
        static let toDoSources = "To Do Sources"
        static let toDoSourcesNoContent = "No To Do Task Sources."
        
        static let recurring = "Recurring"
        static let recurringTasks = "Recurring Tasks"
        static let recurringSources = "Recurring Sources"
        static let recurringSourcesNoContent = "No Recurring Task Sources."
    }
    
    /// Any Font displayed by the UI.
    struct Fonts {
        private static let standard = Font.Design.default

        static let body = Font.system(
            .body
            , design: standard
            , weight: .heavy
        )
        
        static let screenTitle = Font.system(
            .largeTitle
            , design: standard
            , weight: .heavy
        )
        
        static let screenTitleSmaller = Font.system(
            .title
            , design: standard
            , weight: .heavy
        )
        
        static let boxSmall = Font.system(
            .title3
            , design: standard
            , weight: .regular
        )
        
        static let boxLarge = Font.system(
            .title2
            , design: standard
            , weight: .heavy
        )
        
        static let largeButtonText = Font.system(
            .title3
            , design: standard
            , weight: .semibold
        )
        
        static let largeSymbol = Font.system(
            .largeTitle
            , design: standard
            , weight: .bold
        )
        
        static let semiLargeSymbol = Font.system(
            .title
            , design: standard
            , weight: .bold
        )
        
        static let emptyScreenInformational = Font.system(
            .title2
            , design: standard
            , weight: .semibold
        )
        
    }
    
    /// Any Animation used by the UI.
    struct Animations { 
        static let standard: Animation = .default
    }
    
    /// Any System Image used by the UI.
    struct SystemImages { 
        static let add = "plus"
        static let remove = "minus"
        static let delete = "trash"
        static let edit = "square.and.pencil"
        static let complete = "checkmark"
        
        static let home = "house"
        static let settings = "gear"
        static let calendar = "calendar"
        static let sources = "list.clipboard"
        static let search = "sparkle.magnifyingglass"
        
        static let toDo = "checkmark.circle"
        static let recurring = "clock"
    }
    
    /// Any Color used by the UI
    struct Colors {
        // Ugh this conflicts with constants.
        static let appointment = Color.red
        static let deadline = Color.yellow
        static let task = Color.blue
        static let reminder = Color.gray
        
        static let toDo = Color.blue
        static let reccurring = Color.green
    }
    
    static let standardPadding: CGFloat = 8
    
    static let boxCorner: CGFloat = 10
    static let boxOpacity: CGFloat = 0.6
    static let boxTextOpacity: CGFloat = 0.6
    static let boxExternalPadding: CGFloat = 6
    static let boxInternalPadding: CGFloat = standardPadding

    static let buttonCornerRadius: CGFloat = 12
    
    static let noContentMessageOpacity: CGFloat = 0.4
    static let noContentBottomPadding: CGFloat = 54
    
    static let listStyle: InsetListStyle = .inset
}

/// String Representations of enums, need to be localized

extension TimeDuration.Interval {
    var label: String {
        switch self {
        case .minutes: "Minutes"
        case .hours: "Hours"
        case .days: "Days"
        case .weeks: "Weeks"
        case .months: "Months"
        case .years:  "Years"
        }
    }
}

extension RecurrenceType {
    var label: String {
        switch self {
        case .fromComplete: "Last Completed"
        case .fromScheduled: "Last Scheduled"
        }
    }
    
    var description: String {
        switch self {
        case .fromComplete: "The next task will be scheduled the set time after the task is completed."
        case .fromScheduled: "The next task will be scheduled the set time after the task is scheduled."
        }
    }
}

extension TaskTime.Case {
    var label: String {
        switch self {
        case .appointment: "Appointment"
        case .deadline: "Deadline"
        case .task: "Task"
        case .reminder: "Reminder"
        }
    }
    
    var description: String {
        switch self {
        case .appointment: "A task or event with a set start and end time."
        case .deadline: "A task that must get done by a certain time."
        case .task: "A task with no deadline, but requires some action to complete."
        case .reminder: "A task or event that requires no action."
        }
    }
}

extension TaskTime {
    var color: Color {
        switch self {
        case .appointment(_, _): ViewConstants.Colors.appointment
        case .deadline(_): ViewConstants.Colors.deadline
        case .task(_): ViewConstants.Colors.task
        case .reminder(_): ViewConstants.Colors.reminder
        }
    }
    
    var dateTimeLabel: String { "\(self.dateLabel) - \(self.timeLabel)" }
    
    var dateLabel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"

        switch self {
        case .appointment(let start, _):
            let dateStr = dateFormatter.string(from: start)
            return "\(dateStr)"
            
        case .deadline(let date), .task(let date), .reminder(let date):
            let dateStr = dateFormatter.string(from: date)
            return "\(dateStr)"
        }
    }
    
    var timeLabel: String {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale.current
        timeFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "j:mm", options: 0, locale: timeFormatter.locale)
        
        switch self {
        case .appointment(let start, let end):
            let startTime = timeFormatter.string(from: start)
            let endTime = timeFormatter.string(from: end)
            return "\(startTime)-\(endTime)"
            
        case .deadline(let date), .task(let date), .reminder(let date):
            let time = timeFormatter.string(from: date)
            return "\(time)"
        }
    }
}

#Preview {
    ContentView()
//        .environment(\.repository, PreviewMocks.repository)
//        .environment(\.eventManager, PreviewMocks.eventManager)
        .environment(\.repository, PreviewMocks.mockRepository)
        .environment(\.eventManager, PreviewMocks.mockEventManager)
}

