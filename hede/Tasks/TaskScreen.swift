//
//  TaskScreen.swift
//  hede
//
//  Created by Kevin Kelly on 6/1/25.
//

import SwiftUI
import DomainUI

import Models

struct TaskScreen: View {
    
    private let task: HedeTask
    
    @Environment(\.navigator) private var navigator
    @Environment(\.eventManager) private var eventManager
    
    var body: some View {
        List {
            if let description = task.scheduler.description {
                VStack(alignment: .leading) {
                    Text(description)
                        .padding(.top, 24)
                }
            }
                            
            DetailRow(label: "Scheduled:", value: task.scheduled.start.formatted())
                            
            DetailRow(label: "Completed:", value: task.completed?.formatted() ?? "Not Completed")
            
        }
        .navigationTitle(task.label)
        .listStyle(.inset)
                    
        .toolbar {
            Button {
                navigator.here.navigateTo(task.scheduler)
            } label: {
                Image(systemName: SI.edit)
            }
            
            Button {
                
            } label: {
                Image(systemName: SI.delete)
            }
        }
    }
    
    init(_ task: HedeTask) {
        self.task = task
    }
}

#Preview {
    TaskScreen((PreviewMocks.tasks[1]))
        .environment(\.repository, PreviewMocks.mockRepository)
}
