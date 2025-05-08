//
//  GoalResultPicker.swift
//  hede
//
//  Created by Kevin Kelly on 3/9/25.
//

import SwiftUI
import DomainUI
import Models
import Assemblages

struct GoalResultPicker: View {
    @Binding private var goalResult: GoalResult.Config?
    @State private var variant: GoalResult.Config.Variant
    @State private var stepVariant: GoalResult.Steps.Variant
    
    @State private var stepCount: Int?
    @State private var countGoals: [Int]
    @State private var numberGoals: [Double]
   
    var body: some View {
            Picker("", selection: $variant) {
                ForEach(GoalResult.Config.Variant.allCases, id: \.self) { variant in
                    Text(variant.rawValue)
                }
            }
             
            switch variant {
            case .completion:
                    HStack {
                        NullNumberField(integer: $stepCount, prompt: "steps")
                            .fixedSize()
                        
                        Picker("", selection: $stepVariant) {
                            ForEach(GoalResult.Steps.Variant.allCases, id: \.self) { stepVariant in
                                Text(stepVariant.rawValue)
                            }
                        }
                    }
                    
                    .onChange(of: stepCount) { oldValue, newValue in
                        if let newValue = newValue {
                            goalResult = .completion(steps: {
                                switch stepVariant {
                                case .linear: .linear(steps: newValue)
                                case .fibbonaci: .fibbonaci(steps: newValue)
                                }
                            }())
                        }
                    }
                    
                    .onChange(of: stepVariant) { oldValue, newValue in
                        switch newValue {
                        case .linear: goalResult = .completion(steps: .linear(steps: goalResult?.stepCount ?? 2))
                        case .fibbonaci: goalResult = .completion(steps: .fibbonaci(steps: goalResult?.stepCount ?? 2))
                        }
                    }
                                
            case .count:
                    NumberArrayField(integers: $countGoals)
                        .onChange(of: countGoals) { oldValue, newValue in
                            goalResult = .count(goals: SortedSet<Int>(newValue))
                        }
                
            case .number:
                    NumberArrayField(doubles: $numberGoals)
                        .onChange(of: numberGoals) { oldValue, newValue in
                            goalResult = .number(goals: SortedSet<Double>(newValue))
                        }

            case .routine:
                EmptyView()
            }
    }
    
    init(
        _ goalResult: Binding<GoalResult.Config?>
    ) {
        self._goalResult = goalResult
        let goalResult = goalResult.wrappedValue
        self.variant = goalResult?.variant ?? .completion
        self.stepVariant = goalResult?.stepVariant ?? .linear
        self.stepCount = goalResult?.stepCount ?? 2
        self.countGoals = goalResult?.countGoals ?? []
        self.numberGoals = goalResult?.numberGoals ?? []
    }
}

#Preview {
    GoalResultPicker(.constant(nil))
}

