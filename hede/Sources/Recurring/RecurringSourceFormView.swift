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
                Task { await eventManager.createRecurring(from: form) }
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
            } footer: {
                if showHelp {
                    Text("When the automatically scheduled tasks repeats from. If reapeating from completion, the new date is based off when the task is completed. If repeating from scheduled, the new date is based off when the task was originally scheduled.")
                }
            }
            
            TimeDurationFormEntry(
                duration: $form.spacing
                , valid: $form.spacingValid
                , prePopValue: ""
                , prePopInterval: .weeks
                , showHelp: showHelp
            )
            
            if !form.isEditing {
                Section {
                    Toggle("Previously Completed?", isOn: $form.didCompletePreviously)
                    
                    if form.didCompletePreviously {
                        DatePicker("", selection: $form.lastCompletedInput)
                    }
                } header: {
                    Text("Last Completed")
                } footer: {
                    if showHelp {
                        Text("")
                    }
                }
            }
            
            Toggle("Show Help", isOn: Binding(
                get: { self.showHelp },
                set: { newValue in
                    withAnimation {
                        self.showHelp = newValue
                    }
                })
            )
        }
        .listStyle(.inset)
    }
}

@Observable
class RecurringSourceForm {
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
    
    var lastCompleted: Date? { didCompletePreviously ? lastCompletedInput : nil }
    var didCompletePreviously: Bool
    var lastCompletedInput: Date
    
    init() {
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
        
        self.didCompletePreviously = false
        self.lastCompletedInput = Date.now
        
        self.isEditing = false
    }
//    /// This is for editing
//    init(source: RecurringSource) {
//        self.label = source.label
//        self.description = source.description ?? String.null
//    }
    
    let isEditing: Bool
    
    var canSave: Bool {
        label != .null
        && appointmentDurationValid
        && spacingValid
    }
}

#Preview {
    RecurringSourceFormView()
}


