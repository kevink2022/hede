//
//  DailyGoalFormScreen.swift
//  hede
//
//  Created by Kevin Kelly on 3/4/25.
//

import SwiftUI
import Models

struct DailyGoalFormScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    private var goalList: DailyGoalList { repository.goals.dailyGoalLists.first ?? DailyGoalList.null }
    private var sections: [DailyGoalListSection] { repository.goals.dailyGoalListSections }
    private var goals: [DailyGoal] { repository.goals.dailyGoals }
    
    var body: some View {
        @Bindable var navigator = navigator

        NavigationStack(path: $navigator.sources) {
            List {
                ForEach(sections) { section in
                    Section(section.label) {
                        ForEach(section.dailyGoals) { goal in
                            GoalEntry(goal)
                        }
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Daily Goals")
        }
    }
}

#Preview {
    DailyGoalFormScreen()
        .environment(\.repository, PreviewMocks.mockRepository)
        .environment(\.eventManager, PreviewMocks.mockEventManager)
}


