//
//  AnySourceScreen.swift
//  hede
//
//  Created by Kevin Kelly on 2/9/25.
//

import SwiftUI
import DomainUI

import Models
import Database

struct AnySourceScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.eventManager) private var eventManager
    @Environment(\.repository) private var repository
    
    private let source: AnyTaskSource
    
    private var tasks: [AnyTask] {
        source.tasksLink // repository.tasks.tasks.filter { $0.source == source.id }
    }
    
    private var archived: [AnyTask] {
        tasks.filter { $0.isCompleted }
    }
    
    private var open: [AnyTask] {
        tasks.filter { !$0.isCompleted }
    }
    
    var body: some View {
        List {
            if let description = source.description {
                VStack(alignment: .leading) {
                    Text(description)
                        .padding(.top, 2)
                }
            }
            
            Section("Open Tasks") {
                ForEach(open) { open in
                    DetailRow(label: open.label, value: open.scheduled.dateLabel)
                }
            }
            
            Section("Archive") {
                ForEach(archived) { archived in
                    DetailRow(label: archived.label, value: archived.completed?.formatted() ?? "")
                }
            }
            
            switch source.code {
            case .toDo(_): EmptyView()
            case .recurring(_): EmptyView()
            }
        }
        .navigationTitle(source.label)
        .listStyle(.inset)
                    
        .toolbar {
            Button {
                switch source.code {
                case .toDo(_):
                    guard
                        let source = source.data as? ToDoSource
                        , let lastTask = open.first?.data as? ToDoTask
                    else { return }
                    
                    navigator.presentSheet(ToDoSourceFormView(
                        source: source
                        , lastTask: lastTask
                    ))
                    
                case .recurring(_):
                    guard
                        let source = source.data as? RecurringSource
                        , let lastTask = open.first?.data as? RecurringTask
                    else { return }
                    
                    navigator.presentSheet(RecurringSourceFormView(
                        source: source
                        , lastTask: lastTask
                    ))
                }
                
            } label: {
                Image(systemName: SI.edit)
            }
            
            Button {
                
            } label: {
                Image(systemName: SI.delete)
            }
        }
    }
    
    init(_ source: AnyTaskSource) {
        self.source = source
    }
}
