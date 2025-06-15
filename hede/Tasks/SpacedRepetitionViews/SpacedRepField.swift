//
//  SpacedRepField.swift
//  hede
//
//  Created by Kevin Kelly on 6/9/25.
//

import SwiftUI
import Domain
import DomainUI

// We're going to restrict spacing to just the fsrs algo for now.

struct SpacedRepField: View {
    
    @Binding private var algorithm: AnySpacedRepetition?
    
    @State private var repeats: Bool
    @State private var pattern: RepetitionPattern
    
    @State private var linearSpacing: TimeDuration
    @State private var desiredRetention: Double
    
    
    var body: some View {
        Toggle("Repeating Task?", isOn: $repeats)
        
            .onChange(of: repeats) { oldValue, newValue in
                if newValue == false { algorithm = nil }
                else { algorithm = buildAlgorithm() }
            }
        
            .onChange(of: pattern) { oldValue, newValue in
                algorithm = buildAlgorithm()
            }
        
            .onChange(of: linearSpacing) { oldValue, newValue in
                algorithm = buildAlgorithm()
            }
        
        if repeats {
            Picker("Algorithm", selection: $pattern) {
                ForEach(RepetitionPattern.allCases, id: \.self) { Text($0.rawValue) }
            }
            
            switch pattern {
            case .linear: TimeDurationPicker(duration: $linearSpacing)
            case .spaced: EmptyView()
            }
        }
        
    }
    
    private func buildAlgorithm() -> AnySpacedRepetition {
        switch pattern {
        case .linear:
            AnySpacedRepetition(LinearSpacedRepetition(
                spacing: linearSpacing
            ))
            
        case .spaced:
            AnySpacedRepetition(AnkiFSRS(
                desiredRetention: desiredRetention
            ))
        }
    }
    
    init(
        algorithm: Binding<AnySpacedRepetition?>
    ) {
        self._algorithm = algorithm
        
        self.repeats = false
        self.pattern = .linear
        self.linearSpacing = .days(1)
        self.desiredRetention = 0.9
        
        guard let algorithm = algorithm.wrappedValue else { return }
        
        self.repeats = true
        
        switch algorithm.code {
        case .linear(let algorithm):
            self.linearSpacing = algorithm.spacing
        case .ankiFSRS_5(let algorithm):
            self.pattern = .spaced
            self.desiredRetention = algorithm.desiredRetention
        default: break
        }
        
    }
}

private enum RepetitionPattern: String, CaseIterable {
    case linear = "Linear"
    case spaced = "Spaced"
}

#Preview {
    SpacedRepField(algorithm: .constant(nil))
}
