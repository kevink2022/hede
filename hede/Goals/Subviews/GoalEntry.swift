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
import Domain

struct GoalEntry: View {
    @Environment(\.repository) private var repository

    private let goal: DailyGoal
    private let date: Date
    private let existingResult: DailyGoalResult?
    @State private var newResult: GoalResult?
    
    var body: some View {
        GoalResultEntry(
            promptResult: existingResult ?? goal.asResult(on: date)
            , existingResult: existingResult
            , newResult: $newResult
        )
        
        .onChange(of: newResult) { oldValue, newValue in
            if let newValue = newValue {
                Task {
                    await repository.goals.save(
                        [goal.complete(date: date, result: newValue)]
                        , message: "Logged Goal: \(goal.label)"
                    )
                }
            } else if let existingResult = existingResult {
                Task {
                    await repository.goals.delete([existingResult])
                }
            }
        }
    }
    
    init(_ goal: DailyGoal, on date: Date) {
        self.goal = goal
        self.date = date
        
        if let existingResult = goal.result(on: date) {
            self.existingResult = existingResult
            self.newResult = existingResult.result
        } else {
            self.existingResult = nil
            self.newResult = nil
        }
    }
//    
//    init(_ result: DailyGoalResult) {
//        self.goal = result.dailyGoal
//        self.existingResult = result
//        self.newResult = nil
//    }
}


struct GoalResultEntry: View {
    private let existingResult: DailyGoalResult?
    private let promptResult: DailyGoalResult
    
    @Binding private var newResult: GoalResult?
    
    @State private var count: Int
    @State private var integer: Int?
    @State private var double: Double?
    
    @FocusState private var focused: Bool

    
    var body: some View {
            switch promptResult.result {
            case .completion(let steps, let result):
                Self.Layout(
                    label: promptResult.label
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
                        label: promptResult.label
                    ) {
                        NullNumberField(integer: $integer, prompt: String(result))
                            .fixedSize()
                            .focused($focused)
                    }
                }
                
                .task { integer = existingResult?.result.countResult }
                .onChange(of: integer) { oldValue, newValue in
                    if let newValue = newValue {
                        newResult = .count(goals: goals, result: newValue)
                    } else {
                        newResult = nil
                    }
                }
                
            case .number(let goals, let result):
                Button {
                    focused = true
                } label: {
                    Self.Layout(
                        label: promptResult.label
                    ) {
                        NullNumberField(double: $double, prompt: String(result))
                            .fixedSize()
                            .focused($focused)
                    }
                }
                
                .task { double = existingResult?.result.numberResult }
                .onChange(of: double) { oldValue, newValue in
                    if let newValue = newValue {
                        newResult = .number(goals: goals, result: newValue)
                    } else {
                        newResult = nil
                    }
                }
                
            case .routine(/*let routine, */_, let result):
                Self.Layout(
                    label: promptResult.label
                ) {
                    Text(String(describing: result))
                }
                
            }
    }
    
    init(
        promptResult: DailyGoalResult
        , existingResult: DailyGoalResult?
        , newResult: Binding<GoalResult?>
    ) {
        self.promptResult = promptResult
        self.existingResult = existingResult
        self._newResult = newResult
        
        self.count = 0
        self.integer = nil
        self.double = nil
        
        // initialize scaffolding
 /*
        guard let existingResult = existingResult else {
            self.count = 0
            self.integer = nil
            self.double = nil
            return
        }
  */
            
//        switch existingResult.result {
//        case .completion(_, let result): self.count = result
//        case .count(_, let result): self.integer = result 
//        case .number(_, let result): self.double = result
//        case .routine(_, /*let result*/_): break
//        }
//        
        
        
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
