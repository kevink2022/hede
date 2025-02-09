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
    
    @State private var form = ToDoSourceForm()
    @State private var showHelp = false
    
    var body: some View {
        Form {
            Button {
                Task { await eventManager.createToDo(from: form) }
                navigator.dismissSheet()
            } label: {
                Text("Save Task Source")
            }
            .disabled(!form.canSave)
            
            LabelFormEntry(label: $form.label, showHelp: showHelp)
            
            DescriptionFormEntry(description: $form.description, showHelp: showHelp)
            
            TaskTimeFormEntry(taskTime: $form.taskTime, showHelp: showHelp)
        }
    }
}

#Preview {
    ToDoSourceFormView()
}

@Observable
class ToDoSourceForm {
    var label: String = ""
    var description: String = ""
    
    var category: TaskCategory? = nil
    var pauses: [TaskPause]? = nil
    
    var taskTime: TaskTime = .task(.now)
    var start: Date = .now
    var end: Date = .now.adding(.hours(1)) ?? .now
    
    
    var canSave: Bool {
        label != .null
    }
}
