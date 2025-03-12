//
//  GoalSectionsScreen.swift
//  hede
//
//  Created by Kevin Kelly on 3/9/25.
//

import SwiftUI
import Models

struct GoalGroupListScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    private var groups: [DailyGoalListSection] { repository.goals.dailyGoalListSections }
    
    var body: some View {
        List {
            ForEach(groups) { group in
                NavigationLink {
                    GoalGroupEditableScreen(group)
                } label: {
                    GoalGroupRow(group)
                }
                .foregroundStyle(.primary)
            }
        }
        .listStyle(.inset)
        .navigationTitle("Goal Groups")
        .toolbar {
            Button {
                navigator.presentSheet(GoalGroupFormView())
            } label: {
                Image(systemName: SI.add)
            }
        }
    }
}

struct GoalGroupRow: View {
    private let group: DailyGoalListSection
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(group.label)
                .font(F.rowTitle)
            ForEach(group.dailyGoals) { goal in
                Text(goal.label)
                    .font(F.rowSubtitle)
            }
        }
        
    }
    
    init(_ group: DailyGoalListSection) {
        self.group = group
    }
}
