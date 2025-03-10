//
//  GoalEntry.swift
//  hede
//
//  Created by Kevin Kelly on 3/8/25.
//

import SwiftUI
import DomainUI

import Models
import Database

struct GoalEntry: View {
    @Environment(\.repository) private var repository

    private let goal: DailyGoal
    private let existingResult: DailyGoalResult?
    private var result: DailyGoalResult { existingResult ?? goal.asResult }
    @State private var newResult: GoalResult?
    
    var body: some View {
        GoalResultEntry(
            currentResult: result
            , newResult: $newResult
        )
        
        .onChange(of: newResult) { oldValue, newValue in
            if let newValue = newValue {
                Task {
                    print("Saved Daily: \(newValue)")
                    await repository.goals.save(
                        [goal.complete(date: result.date, result: newValue)]
                        , message: "Logged Goal: \(result.label)"
                    )
                }
            } else {
                Task {
                    print("Deleted Daily: \(result.label)")
                    await repository.goals.delete([result])
                }
            }
        }
    }
    
    init(_ goal: DailyGoal) {
        self.goal = goal
        self.existingResult = nil
        self.newResult = nil
    }
    
    init(_ result: DailyGoalResult) {
        self.goal = result.dailyGoal
        self.existingResult = result
        self.newResult = nil
    }
}


struct GoalResultEntry: View {
    private let goalResult: DailyGoalResult
    
    @Binding private var newResult: GoalResult?
    
    @State private var count: Int = 0
    @State private var integer: Int? = nil
    @State private var double: Double? = nil

    @State private var string: String = "0"
    @FocusState private var focused: Bool

    
    var body: some View {
            switch goalResult.result {
            case .completion(let steps, let result):
                Self.Layout(
                    label: goalResult.label
                ) {
                    ShapeFillButton(
                        count: $count
                        , steps: steps.count
                    )
                    .frame(width: 20)
                }
                
                .task { count = result }
                .onChange(of: count) { oldValue, newValue in
                    if newValue > 0 && newValue != result {
                        newResult = .completion(steps: steps, result: newValue)
                    } else {
                        newResult = nil
                    }
                }
                
            case .count(let goals, let result):
                Button {
                    focused = true
                } label: {
                    Self.Layout(
                        label: goalResult.label
                    ) {
                        NullNumberField(integer: $integer, prompt: String(result))
                            .fixedSize()
                            .focused($focused)
                    }
                }
                
                .onChange(of: integer) { oldValue, newValue in
                    if let newValue = newValue {
                        newResult = .count(goals: goals, result: newValue)
                    } else {
                        newResult = nil
                    }
                }
                
            case .number(let goals, let result):
                Self.Layout(
                    label: goalResult.label
                ) {
                    NullNumberField(double: $double, prompt: String(result))
                        .fixedSize()
                        .focused($focused)
                }
                
                .onChange(of: double) { oldValue, newValue in
                    if let newValue = newValue {
                        newResult = .number(goals: goals, result: newValue)
                    } else {
                        newResult = nil
                    }
                }
                
            case .routine(/*let routine, */_, let result):
                Self.Layout(
                    label: goalResult.label
                ) {
                    Text(String(describing: result))
                }
                
            }
    }
    
    init(
        currentResult: DailyGoalResult,
        newResult: Binding<GoalResult?>
    ) {
        self.goalResult = currentResult
        self._newResult = newResult
    }
    
    private struct Layout<Content: View>: View {
        private let label: String
        private let content: () -> Content
        
        var body: some View {
            HStack {
                Text(label)
                Spacer()
                content()
            }
        }
        
        init(
            label: String
            , content: @escaping () -> Content
        ) {
            self.label = label
            self.content = content
        }
    }
}
