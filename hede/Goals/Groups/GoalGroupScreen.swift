//
//  GoalGroupScreen.swift
//  hede
//
//  Created by Kevin Kelly on 3/9/25.
//

import SwiftUI
import Models

struct GoalGroupScreen: View {
    @Environment(\.navigator) private var navigator
//    @Environment(\.repository) private var repository
    
    private let group: DailyGoalListSection
    
    var body: some View {
        List {
            if let description = group.description {
                VStack(alignment: .leading) {
                    Text(description)
                        .padding(.top, 2)
                }
            }
            
            ForEach(group.dailyGoals) { goal in
                NavigationLink {
                    GoalScreen(goal)
                } label: {
                    Text(goal.label)
                }
            }
        }
        .listStyle(.inset)
        .navigationTitle(group.label)
        .toolbar {
            Button {
                navigator.presentSheet(GoalGroupEditableScreen(group))
            } label: {
                Image(systemName: SI.edit)
            }
        }
    }
    
    init(_ group: DailyGoalListSection) {
        self.group = group
    }
}

