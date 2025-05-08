//
//  AllDailyGoalListsScreen.swift
//  hede
//
//  Created by Kevin Kelly on 3/11/25.
//

import SwiftUI
import DomainUI
import Models

struct AllDailyGoalListsScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    private var lists: [DailyGoalList] { repository.goals.dailyGoalLists }
    
    var body: some View {
        List {
            ForEach(lists) { list in
                NavigationLink {
                    DailyListScreen(list)
                } label: {
                    VStack(alignment: .leading) {
                        Text(list.label)
                            .font(F.rowTitle)
                        WeekdayWeekPicker(list.weekdays)
                    }
                }
                .foregroundStyle(.primary)
            }
        }
        .listStyle(.inset)
        .navigationTitle("Daily Lists")
        .toolbar {
            NavigationLink {
                DailyListScreen()
            } label: {
                Image(systemName: SI.add)
            }
        }
    }
}

#Preview {
    AllDailyGoalListsScreen()
        .environment(\.repository, PreviewMocks.mockRepository)
        .environment(\.eventManager, PreviewMocks.mockEventManager)
}
