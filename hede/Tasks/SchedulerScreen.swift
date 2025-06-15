//
//  SchedulerScreen.swift
//  hede
//
//  Created by Kevin Kelly on 6/1/25.
//

import SwiftUI
import DomainUI

import Models
import Database

struct SchedulerScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.eventManager) private var eventManager
    @Environment(\.repository) private var repository
    
    private let scheduler: HedeScheduler
    
    private var tasks: [HedeTask] { scheduler.tasks }
    private var archived: [HedeTask] { tasks.filter { $0.isComplete } }
    private var open: [HedeTask] { tasks.filter { !$0.isComplete } }
    
    var body: some View {
        List {
            if let description = scheduler.description {
                VStack(alignment: .leading) {
                    Text(description)
                        .padding(.top, 2)
                }
            }
            
            if let lastTask = open.last {
                Section {
                    NavigationLink {
                        SchedulerFormView(scheduler: scheduler, lastTask: lastTask)
                    } label: {
                        Label("Edit Task", systemImage: SI.edit)
                    }
                }
            }
            
            Section("Open Tasks") {
                ForEach(open) { open in
                    DetailRow(label: open.label, value: open.scheduled.dateLabel)
                }
            }
            
            Section("Completed Tasks") {
                ForEach(archived) { archived in
                    DetailRow(label: archived.label, value: archived.completed?.formatted() ?? "")
                }
            }
        }
        .navigationTitle(scheduler.label)
        .listStyle(.inset)
                    
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: SI.delete)
            }
        }
    }
    
    init(_ scheduler: HedeScheduler) {
        self.scheduler = scheduler
    }
}

extension HedeScheduler {
    func screen() -> SchedulerScreen { SchedulerScreen(self) }
//    func listView() -> some View { Text(self.label) }
}



