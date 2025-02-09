//
//  RecurringTaskScreen.swift
//  hede
//
//  Created by Kevin Kelly on 9/23/24.
//

import SwiftUI
import Models

struct RecurringTaskScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.eventManager) private var eventManager
    @Environment(\.repository) private var repository
    
    private let task: RecurringTask
    private var source: RecurringSource {
        repository.taskSources([task.source]).first?.source as? RecurringSource ?? .null
    }
    
    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(task.label)
//                    .font(F.screenTitle)
//                
//                if let description = source.description {
//                    Text(description)
//                }
//                
//                Text(task.scheduled.dateTimeLabel)
//                
//                Spacer()
//                
//                LargeButton {
//                    Task { await eventManager.complete(AnyTask(task)) }
//                    navigator.home.toRoot()
//                } label: {
//                    HStack {
//                        Spacer()
//                        
//                        Label("Complete", systemImage: SI.complete)
//                            .font(F.screenTitle)
//                            .padding(V.boxInternalPadding)
//                    }
//                }
//                .foregroundStyle(.green)
//                .frame(maxHeight: 70)
//            }
//            
//            Spacer()
//        }
//        .padding(V.standardPadding)
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                if let description = source.description {
                    VStack(alignment: .leading) {
                        Text(description)
                            .padding(.top, 2)
                    }
                }
                
                Divider()
                
//                taskDetailRow(label: "Source:", value: task.source.uuidString)
                taskDetailRow(label: "Scheduled:", value: task.scheduled.start.formatted())
                Divider()
                taskDetailRow(label: "Completed:", value: task.completed?.formatted() ?? "Not Completed")
                Divider()
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(task.label)
                    
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: SI.edit)
            }
            
            Button {
                
            } label: {
                Image(systemName: SI.delete)
            }
        }
    }
    
    private func taskDetailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(value)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .multilineTextAlignment(.trailing)
        }
//        .padding(.vertical, 4)
    }
    
    init(_ task: RecurringTask) {
        self.task = task
    }
}

#Preview {
    RecurringTaskScreen(PreviewMocks.recurring_1.initialTask)
        .environment(\.repository, PreviewMocks.mockRepository)
}
