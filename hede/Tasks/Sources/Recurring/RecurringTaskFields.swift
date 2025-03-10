//
//  RecurringTaskFields.swift
//  hede
//
//  Created by Kevin Kelly on 9/23/24.
//

import SwiftUI
import DomainUI

import Models

struct RecurringTaskFields: View {
    
    private let task: RecurringTask
    
    var body: some View {
        DetailRow(label: "Recurring Rate:", value: "\(task.sourceLink.spacing.value) \(task.sourceLink.spacing.interval.label)")
    }

    
    init(_ task: RecurringTask) {
        self.task = task
    }
}

#Preview {
    RecurringTaskFields(PreviewMocks.recurring_1.initialTask)
        .environment(\.repository, PreviewMocks.mockRepository)
}
