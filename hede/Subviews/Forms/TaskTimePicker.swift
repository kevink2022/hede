//
//  TaskTimePicker.swift
//  hede
//
//  Created by Kevin Kelly on 9/12/24.
//

import SwiftUI
import Models

struct TaskTimePicker: View {
    @Binding private var taskTime: TaskTime
    @Binding private var valid: Bool
    
    @State private var taskTimeCase: TaskTime.Case
    @State private var start: Date
    @State private var end: Date
    
    var body: some View {
        VStack {
            Picker("", selection: $taskTimeCase) {
                ForEach(TaskTime.Case.allCases, id: \.self) { interval in
                    Text(interval.label)
                }
            }
            
            DatePicker("Start", selection: $start)
            
            if taskTimeCase == .appointment {
                DatePicker("End", selection: $end)
            }
        }
        
        .onChange(of: taskTimeCase) { updateTime() }
        .onChange(of: start) { updateTime() }
        .onChange(of: end) { updateTime() }

    }
    
    private func updateTime() {
        guard let newTime = TaskTime.new(taskTimeCase, from: start, to: end) else {
            valid = false
            return
        }
        
        valid = true
        taskTime = newTime
    }
    
    init(
        taskTime: Binding<TaskTime>
        , valid: Binding<Bool> = .constant(true)
    ) {
        self._taskTime = taskTime
        self._valid = valid
        
        self._taskTimeCase = State(initialValue: taskTime.wrappedValue.taskCase)
        self._start = State(initialValue: taskTime.wrappedValue.start)
        self._end = State(initialValue: taskTime.wrappedValue.end ?? .now)
    }
}


//#Preview {
//    TaskTimePicker()
//}
