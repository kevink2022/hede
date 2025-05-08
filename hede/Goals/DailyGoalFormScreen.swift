//
//  DailyGoalFormScreen.swift
//  hede
//
//  Created by Kevin Kelly on 3/4/25.
//

import SwiftUI
import DomainUI
import Models

struct DailyGoalFormScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    private var goalList: DailyGoalList {
        repository.goals.dailyGoalLists.first { $0.weekdays.contains(day.weekday) } ?? .null
    }
    
    private var sections: [DailyGoalListSection] {
        goalList.sections
    }
    
    @FocusState private var focused
    @State private var day: Date = .today
    
    var body: some View {
        @Bindable var navigator = navigator
        
        VStack {
            if goalList == DailyGoalList.null {
                NoContentMessage(message: "No List for Today.")
            }
            
            NavigationStack(path: $navigator.sources) {
                List {
                    Section(goalList.label) { }
                    ForEach(sections) { section in
                        Section(section.label) {
                            ForEach(section.dailyGoals) { goal in
                                GoalEntry(goal, on: day)
                                    .focused($focused)
                            }
                        }
                    }
                }
                .id(day)
                .listStyle(.inset)
                .navigationTitle("Daily Goals")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Dismiss") { focused = false }
                    }
                }
            }
            
            // Date Bar
            VStack(spacing: 0) {
                Divider()

                ZStack {
                    HStack {
                        Spacer()
                        
                        Button { goToLastDay() } label: {
                            Image(systemName: "chevron.left")
                        }
                        
                        Spacer()
                        
                        Text(day.longFormat)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Button { goToNextDay() } label: {
                            Image(systemName: "chevron.right")
                        }
                        
                        Spacer()
                    }
                    
                }
                .frame(minHeight: 50)
                .highPriorityGesture(
                    DragGesture().onEnded { value in
                        let offset = value.translation.width
                        let velocity = abs(value.predictedEndTranslation.width - value.translation.width)

                        let velocityTrigger: CGFloat = 100
                        let swipeLeft = offset > 0 && velocity > velocityTrigger
                        let swipeRight = offset < 0 && velocity > velocityTrigger

                        if swipeRight { goToNextDay() }
                        else if swipeLeft { goToLastDay() }
                    }
                )

                Divider()
            }
        }
    }
    
    private func goToNextDay() {
        day = day.adding(.days(1)) ?? day
    }
    
    private func goToLastDay() {
        day = day.subtracting(.days(1)) ?? day
    }
}

#Preview {
    DailyGoalFormScreen()
        .environment(\.repository, PreviewMocks.mockRepository)
        .environment(\.eventManager, PreviewMocks.mockEventManager)
}


