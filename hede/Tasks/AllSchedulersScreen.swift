//
//  AllSchedulersScreen.swift
//  hede
//
//  Created by Kevin Kelly on 6/1/25.
//
import SwiftUI
import DomainUI

import Models

struct AllSchedulersScreen: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    var body: some View {
        List {
            
            ForEach(repository.tasks.hedeSchedulers) { scheduler in
                NavigationLink {
                    SchedulerScreen(scheduler)
                } label: {
                    Text(scheduler.label)
                }
            }
        }
        .listStyle(.inset)
        .navigationTitle("Task Schedulers")
        
        .toolbar {
            Button {
                navigator.presentSheet(RecurringSourceFormView())
            } label: {
                Image(systemName: SI.add)
            }
        }
        
        if repository.tasks.recurringSources.isEmpty {
            NoContentMessage(message: T.recurringSourcesNoContent) {
                navigator.presentSheet(RecurringSourceFormView())
            } label: {
                Label(T.addSource, systemImage: SI.add)
            }

        }
    }
}

#Preview {
    RecurringSourcesScreen()
        .environment(PreviewMocks.repository)
//        .environment(PreviewMocks.mockRepository)
        .tint(C.reccurring)
}
