//
//  TaskTimeFormEntry.swift
//  hede
//
//  Created by Kevin Kelly on 9/12/24.
//

import SwiftUI
import Models

struct TaskTimeFormEntry: View {
    @Binding private var taskTime: TaskTime
    @Binding private var valid: Bool
    private let showHelp: Bool
    
    var body: some View {
        Section {
            TaskTimePicker(taskTime: $taskTime, valid: $valid)
        } header: {
            Text("Schedule Time")
        } footer: {
            if showHelp {
                Text("Help")
            }
        }
    }
    
    init(
        taskTime: Binding<TaskTime>
        , valid: Binding<Bool> = .constant(true)
        , showHelp: Bool = false
    ) {
        self._taskTime = taskTime
        self._valid = valid
        self.showHelp = showHelp
    }
}

//#Preview {
//    TaskTimeFormEntry()
//}
