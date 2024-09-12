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
                Text("Save Recurring Source")
            }
            .disabled(!form.canSave)
            
            LabelFormEntry(label: $form.label, showHelp: showHelp)
            
            DescriptionFormEntry(description: $form.description, showHelp: showHelp)
        }
    }
}

#Preview {
    ToDoSourceFormView()
}

class ToDoSourceForm {
    var label: String = ""
    var description: String = ""
    
    var category: TaskCategory? = nil
    var pauses: [TaskPause]? = nil
    
    var canSave: Bool {
        false
    }
}
