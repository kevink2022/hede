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
        
        static let bold = Font.system(
            .body
            , design: standard
            , weight: .bold
        )
        
        static let light = Font.system(
            .subheadline
            , design: standard
            , weight: .light
        )
        
        static let rowTitle = bold
        static let rowSubtitle = light
        
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
        
        static let largeSymbol = Font.system(
            .largeTitle
            , design: standard
            , weight: .bold
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
        
        static let flashcards = "rectangle.fill.on.rectangle.angled.fill"
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
    
    static let listStyle: InsetListStyle = .inset
}

/// String Representations of enums, need to be localized

extension RecurrencePattern {
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

extension Int {
    var ordinalSuffix: String {
        if (11...13).contains(self % 100) {
            return "th"
        } else {
            switch self % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
    
    var ordinal: String { "\(self)\(ordinalSuffix)" }
}

extension Date {
    var shortFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/Y"
        let dateStr = dateFormatter.string(from: self)
        return "\(dateStr)"
    }
    
    var longFormat: String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, MMMM d"
        var dateStr = dateFormatter.string(from: self)
        
        let day = Calendar.current.component(.day, from: self)
        dateStr += day.ordinalSuffix
        
        dateFormatter.dateFormat = ", yyyy"
        dateStr += dateFormatter.string(from: self)
        
        return dateStr
    }
}

#Preview {
    ContentView()
//        .environment(\.repository, PreviewMocks.repository)
//        .environment(\.eventManager, PreviewMocks.eventManager)
        .environment(\.repository, PreviewMocks.mockRepository)
        .environment(\.eventManager, PreviewMocks.mockEventManager)
}




