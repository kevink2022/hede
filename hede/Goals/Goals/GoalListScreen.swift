//
//  GoalListScreen.swift
//  hede
//
//  Created by Kevin Kelly on 3/8/25.
//

import SwiftUI
import Models

struct GoalListScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    private var goals: [DailyGoal] { repository.goals.dailyGoals }
    
    var body: some View {
        List {
            ForEach(goals) { goal in
                NavigationLink {
                    GoalScreen(goal)
                } label: {
                    Text(goal.label)
                }
                .foregroundStyle(.primary)
            }
        }
        .listStyle(.inset)
        .navigationTitle("Goals")
        .toolbar {
            Button {
                navigator.presentSheet(GoalFormView())
            } label: {
                Image(systemName: SI.add)
            }
        }
    }
}
