//
//  RecurringTaskFields.swift
//  hede
//
//  Created by Kevin Kelly on 9/23/24.
//

import SwiftUI
import Models

struct RecurringTaskFields: View {
    @Environment(\.repository) private var repository
    
    private let task: RecurringTask
    private var source: RecurringSource {
        repository.tasks.taskSources([task.source]).first?.data as? RecurringSource ?? .null
    }
    
    var body: some View {
        DetailRow(label: "Recurring Rate:", value: "\(source.spacing.value) \(source.spacing.interval.label)")
    }

    
    init(_ task: RecurringTask) {
        self.task = task
    }
}

#Preview {
    RecurringTaskFields(PreviewMocks.recurring_1.initialTask)
        .environment(\.repository, PreviewMocks.mockRepository)
}
