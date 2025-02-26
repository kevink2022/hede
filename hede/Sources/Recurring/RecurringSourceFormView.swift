//
//  RecurringSourceFormView.swift
//  hede
//
//  Created by Kevin Kelly on 9/9/24.
//

import SwiftUI
import Models
import Domain

struct RecurringSourceFormView: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator

    @State private var form = RecurringSourceForm()
    @State private var showHelp = false
    
    var body: some View {
        Form {
            Button {
                if form.isNew {
                    Task { await eventManager.createRecurring(from: form) }
                } else {
                    Task { await eventManager.editRecurring(from: form) }
                }
                navigator.dismissSheet()
            } label: {
                ZStack {
                    Text("Save Recurring Source")
                    Color(.clear)
                }
            }
            .disabled(!form.canSave)
            
            LabelFormEntry(label: $form.label, showHelp: showHelp)
            
            DescriptionFormEntry(description: $form.description, showHelp: showHelp)
            
            TaskTimeCaseFormEntry(
                taskTimeCase: $form.taskCase
                , duration: $form.appointmentDuration
                , valid: $form.appointmentDurationValid
                , showHelp: showHelp
            )
            
            Section {
                Picker("", selection: $form.recurrenceType) {
                    ForEach(RecurrenceType.allCases, id: \.self) { type in
                        Text(type.label)
                    }
                }
            } header: {
                Text("Repeat from")
            }
            
            TimeDurationFormEntry(
                duration: $form.spacing
                , valid: $form.spacingValid
                , prePopValue: form.spacingPrePop
                , prePopInterval: form.spacingPrePopInterval
                , showHelp: showHelp
            )
            
            if form.isNew {
                FormEntry {
                    NullDatePicker(date: $form.lastCompleted, label: "Completed")
                }
            }
            
            Section {
                DetailRow(label: "Next Due Date", value: form.nextDueDate.formatted())
            }
        }
        .listStyle(.inset)
    }
    
    init(
        source: RecurringSource? = nil
        , lastTask: RecurringTask? = nil
    ) {
        if let source = source, let lastTask = lastTask {
            self._form = State(initialValue: RecurringSourceForm(
                source: source
                , lastTask: lastTask
            ))
        } else {
            self._form = State(initialValue: RecurringSourceForm())
        }
    }
}

@Observable
class RecurringSourceForm {
    let source: RecurringSource?
    let lastTask: RecurringTask?
    
    var label: String
    var description: String
    
    var taskType: TaskTime.Pattern
    var appointmentDuration: TimeDuration
    var appointmentDurationValid: Bool
    var taskCase: TaskTime.Case {
        didSet {
            if .appointment != taskCase {
                appointmentDurationValid = true
            }
        }
    }
    
    var recurrenceType: RecurrenceType
    
    var spacing: TimeDuration
    var spacingValid: Bool
    
    var category: TaskCategory?
    var pauses: [TaskPause]?
    
    var lastCompleted: Date?
    
    // For create new
    init() {
        self.source = nil
        self.lastTask = nil
        
        self.label = ""
        self.description = ""
        
        self.taskType = .task
        self.appointmentDuration = .hours(1)
        self.appointmentDurationValid = true
        self.taskCase = .task
        
        self.recurrenceType = .fromComplete
        
        self.spacing = .weeks(1)
        self.spacingValid = true
        
        self.category = nil
        self.pauses = nil
        
        self.lastCompleted = nil
    }
    
    // For edit
    init(source: RecurringSource, lastTask: RecurringTask) {
        self.source = source
        self.lastTask = lastTask
        
        self.label = source.label
        self.description = source.description ?? String.null
        
        self.taskType = lastTask.scheduled.pattern
        self.appointmentDuration = .hours(1) // fix?? do i care??
        self.appointmentDurationValid = true
        self.taskCase = lastTask.scheduled.taskCase
        
        self.recurrenceType = source.type
        
        self.spacing = source.spacing
        self.spacingValid = true
        
        self.category = nil
        self.pauses = nil
        
        self.lastCompleted = nil
    }
    
    var isNew: Bool { source == nil }
    
    var nextDueDate: Date {
        if isNew {
            let base = lastCompleted ?? .now
            return base.adding(spacing) ?? .null
        }
        
        else {
            guard
                let source = source
                , let lastTask = lastTask else
            { return .null }
            
            return lastTask.scheduled.start
                .subtracting(source.spacing)?
                .adding(self.spacing) ??
                .null
        }
    }
    
    var canSave: Bool {
        label != .null
        && appointmentDurationValid
        && spacingValid
    }
    
    var spacingPrePop: String {
        if isNew { return "" }
        else { return String(source?.spacing.value ?? 0) }
    }
    
    var spacingPrePopInterval: TimeDuration.Interval {
         source?.spacing.interval ?? .weeks
    }
}

#Preview {
    RecurringSourceFormView(
        source: PreviewMocks.recurring_2.source
        , lastTask: PreviewMocks.recurring_2.initialTask
    )
}


