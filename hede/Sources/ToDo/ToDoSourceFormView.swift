//
//  ToDoSourceForm.swift
//  hede
//
//  Created by Kevin Kelly on 9/12/24.
//

import SwiftUI
import Models

struct ToDoSourceFormView: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    
    @State private var form: ToDoSourceForm
    @State private var showHelp = false
    
    var body: some View {
        Form {
            Button {
                if form.isNew {
                    Task { await eventManager.createToDo(from: form) }
                } else {
                    Task { await eventManager.editToDo(from: form) }
                }
                navigator.dismissSheet()
            } label: {
                Text("Save Task Source")
            }
            .disabled(!form.canSave)
            
            LabelFormEntry(label: $form.label, showHelp: showHelp)
            
            DescriptionFormEntry(description: $form.description, showHelp: showHelp)
            
            TaskTimeFormEntry(taskTime: $form.taskTime, showHelp: showHelp)
            
            if !form.isNew {
                FormEntry {
                    NullDatePicker(date: $form.completed, label: "Completed")
                }
            }
        }
    }
    
    init(
        source: ToDoSource? = nil
        , lastTask: ToDoTask? = nil
    ) {
        if let source = source, let lastTask = lastTask {
            self._form = State(initialValue: ToDoSourceForm(
                source: source
                , lastTask: lastTask
            ))
        } else {
            self._form = State(initialValue: ToDoSourceForm())
        }
    }
}

#Preview {
    ToDoSourceFormView(
        source: PreviewMocks.toDo_2.source
        , lastTask: PreviewMocks.toDo_2.initialTask
    )
}

@Observable
class ToDoSourceForm {
    let source: ToDoSource?
    let lastTask: ToDoTask?
    
    var label: String
    var description: String
    
    var category: TaskCategory?
    var pauses: [TaskPause]?
    
    var taskTime: TaskTime
    var start: Date
    var end: Date
    
    var completed: Date?
    
    var canSave: Bool { label != .null }
    var isNew: Bool { source == nil }
    
    // For create new
    init() {
        self.source = nil
        self.lastTask = nil
        
        self.label = ""
        self.description = ""
        
        self.category  = nil
        self.pauses = nil
        
        self.taskTime = .task(.now)
        self.start = .now
        self.end = .now.adding(.hours(1)) ?? .now
        
        self.completed = nil
    }
    
    // For edit
    init(source: ToDoSource, lastTask: ToDoTask) {
        self.source = source
        self.lastTask = lastTask
        
        self.label = source.label
        self.description = source.description ?? String.null
        
        self.category = nil
        self.pauses = nil
        
        self.taskTime = lastTask.scheduled
        self.start = lastTask.scheduled.start
        self.end = lastTask.scheduled.end ?? .now
        
        self.completed = lastTask.completed
    }
}
