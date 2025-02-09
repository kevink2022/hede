//
//  RecurringSourceFormView.swift
//  hede
//
//  Created by Kevin Kelly on 9/9/24.
//

import SwiftUI
import Models

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
                Text("Save Recurring Source")
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
            
            Toggle("Show Help", isOn: Binding(
                get: { self.showHelp },
                set: { newValue in
                    withAnimation {
                        self.showHelp = newValue
                    }
                })
            )
        }
    }
}

@Observable
class RecurringSourceForm {
    var label: String = ""
    var description: String = ""
    
    var taskType: TaskTime.Pattern = .task
    var appointmentDuration: TimeDuration = .hours(1)
    var appointmentDurationValid: Bool = true
    var taskCase: TaskTime.Case = .task {
        didSet {
            if .appointment != taskCase {
                appointmentDurationValid = true
            }
        }
    }
    
    var recurrenceType: RecurrenceType = .fromComplete
    
    var spacing: TimeDuration = .weeks(1)
    var spacingValid: Bool = true
    
    var category: TaskCategory? = nil
    var pauses: [TaskPause]? = nil
    
    var lastCompleted: Date? { didCompletePreviously ? lastCompletedInput : nil }
    var didCompletePreviously: Bool = false
    var lastCompletedInput: Date = Date.now
    
    init() {}
    
    var canSave: Bool {
        label != .null
        && appointmentDurationValid
        && spacingValid
    }
}

#Preview {
    RecurringSourceFormView()
}


