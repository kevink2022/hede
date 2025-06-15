//
//  TaskScreen.swift
//  hede
//
//  Created by Kevin Kelly on 6/1/25.
//

import SwiftUI
import DomainUI

import Models
import Domain

struct TaskScreen: View {
    
    private let task: HedeTask
    
    @Environment(\.navigator) private var navigator
    @Environment(\.eventManager) private var eventManager
    
    var body: some View {
        
        VStack {
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
            
            Spacer()
            
            TaskCompletionButton(task)
                .padding(.horizontal, V.standardPadding)
        }
        .navigationTitle(task.label)
        .listStyle(.inset)
                    
        .toolbar {
            Button {
                navigator.navigateTo(task.scheduler)
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

struct TaskCompletionButton: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    
    private let task: HedeTask
    @State private var review: AnySpacedRepetitionContext?
    
    var body: some View {
        if let algorithm = task.scheduler.algorithm {
            SpacedRepAnswerView(algorithm: algorithm, state: task.state, review: $review)
                .onChange(of: review) { oldValue, newValue in
                    complete(task, with: newValue)
                    navigator.navigateBack()
                }
        }
        
        else {
            LargeButton {
                complete(task)
                navigator.navigateBack()
            } label: {
                Label("Complete Task", systemImage: SI.complete)
            }

        }
    }
    
    init(_ task: HedeTask) {
        self.task = task
        self.review = nil
    }
    
    private func complete(_ task: HedeTask, with review: AnySpacedRepetitionContext? = nil) {
        Task { await eventManager.complete(task, with: review) }
    }
}

extension HedeTask {
    func screen() -> TaskScreen { TaskScreen(self) }
}
