//
//  GoalScreen.swift
//  hede
//
//  Created by Kevin Kelly on 3/8/25.
//

import SwiftUI
import DomainUI

import Models

struct GoalScreen: View {
    @Environment(\.navigator) private var navigator

    private let goal: DailyGoal
    private var results: [DailyGoalResult] { goal.dailyGoalResults }
    
    var body: some View {
        List {
            if let description = goal.description {
                VStack(alignment: .leading) {
                    Text(description)
                        .padding(.top, 2)
                }
            }
            
            Section("Details") {
                DetailRow(label: "Config", value: goal.config.label)
                DetailRow(label: "Type", value: goal.type.rawValue)
                DetailRow(label: "Active", value: String(goal.active))
            }

            Section("Archive") {
                ForEach(results) { result in
                    DetailRow(label: result.label, value: result.date.formatted())
                }
            }
        }
        .listStyle(.inset)
        .navigationTitle(goal.label)
        
        .toolbar {
            Button {
                navigator.presentSheet(GoalFormView(goal))
            } label: {
                Image(systemName: SI.edit)
            }
        }
    }
    
    init(
        _ goal: DailyGoal
    ) {
        self.goal = goal
    }
}
