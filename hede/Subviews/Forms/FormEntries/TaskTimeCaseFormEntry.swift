//
//  TaskTimeCaseFormEntry.swift
//  hede
//
//  Created by Kevin Kelly on 9/12/24.
//

import SwiftUI
import Models

struct TaskTimeCaseFormEntry: View {
    
    @Binding private var taskTimeCase: TaskTime.Case
    @Binding private var duration: TimeDuration
    @Binding private var valid: Bool
    private var showHelp: Bool
    
    var body: some View {
        FormEntry(showHelp: false) {
            Picker("", selection: $taskTimeCase) {
                ForEach(TaskTime.Case.allCases, id: \.self) { type in
                    Text(type.label)
                }
            }
              
            if taskTimeCase == .appointment {
                TimeDurationPicker(duration: $duration, valid: $valid, prePopValue: "", prePopInterval: .hours)
            }
        } label: {
            Text("Task Type")
        } help: {
            
                Text("Select the type of task: \n1. \(TaskTime.Case.appointment.description) \n2. \(TaskTime.Case.deadline.description) \n3. \(TaskTime.Case.task.description) \n4. \(TaskTime.Case.reminder.description)")
        }
    }
    
    init(
        taskTimeCase: Binding<TaskTime.Case>
        , duration: Binding<TimeDuration>
        , valid: Binding<Bool> = .constant(true)
        , showHelp: Bool = false
    ) {
        self._taskTimeCase = taskTimeCase
        self._duration = duration
        self._valid = valid
        self.showHelp = showHelp
    }
}

//#Preview {
//    TaskTimeCaseFormEntry()
//}
