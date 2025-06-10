//
//  SchedulerFormView.swift
//  hede
//
//  Created by Kevin Kelly on 6/3/25.
//

import SwiftUI
import Observation
import Models
import Domain
import DomainUI
import Database

struct SchedulerFormView: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    
    @State var form: SchedulerForm
    
    var body: some View {
        Form {
            Section {
                Button {
                    Task { await eventManager.save(from: form) }
                    navigator.dismissSheet()
                } label: {
                    ZStack {
                        Text("Save Task")
                        Color(.clear)
                    }
                }
            }
            
            TextField("Label", text: $form.label)
            
            NullTextField(text: $form.description, label: "Description", prompt: "Description")
            
            TaskTimePicker(taskTime: $form.startOn)
            
            if form.editing {
                Toggle("Is Active?", isOn: $form.active)
            }
            
            Section("Repetition") {
                SpacedRepField(algorithm: $form.algorithm)
                
                if form.algorithm != nil {
                    Picker("Repeat From", selection: $form.recurrencePattern) {
                        ForEach(RecurrencePattern.allCases, id: \.self) { Text($0.label) }
                    }
                }
            }
            
            Section("Tags") {
                TagEntryField(tags: $form.tags)
            }
        }
        .listStyle(.inset)
    }
    
    init(
        scheduler: HedeScheduler
        , lastTask: HedeTask
    ) {
        self.form = SchedulerForm(
            source: scheduler
            , lastTask: lastTask
        )
    }
    
    init() { self.form = SchedulerForm() }
    private init(form: SchedulerForm) { self.form = form }
}

@Observable
class SchedulerForm {
    let scheduler: HedeScheduler?
    let lastTask: HedeTask?
    
    var label: String
    var description: String?
    var active: Bool
    var tags: Set<HedeTag>
    var algorithm: AnySpacedRepetition?
    var recurrencePattern: RecurrencePattern
    var startOn: TaskTime
    
    var editing: Bool { scheduler != nil }
    var valid: Bool { label != .null }
    
    init() {
        self.scheduler = nil
        self.lastTask = nil
        self.label = ""
        self.description = nil
        self.active = true
        self.tags = []
        self.algorithm = nil
        self.recurrencePattern = .fromComplete
        self.startOn = TaskTime.task(.now)
    }
    
    init(
        source: HedeScheduler
        , lastTask: HedeTask
    ) {
        self.scheduler = source
        self.lastTask = lastTask
        self.label = source.label
        self.description = source.description
        self.active = source.active
        self.tags = Set(source.tags)
        self.algorithm = source.algorithm
        self.recurrencePattern = source.recurrencePattern
        self.startOn = lastTask.scheduled
    }
}


#Preview {
    SchedulerFormView()
        .listStyle(.inset)
}
