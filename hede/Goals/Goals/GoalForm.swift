//
//  GoalForm.swift
//  hede
//
//  Created by Kevin Kelly on 3/8/25.
//

import SwiftUI
import DomainUI

import Models

struct GoalFormView: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    
    @State private var form: GoalForm
    
    var body: some View {
        Form {
            Button {
                Task { await eventManager.saveGoal(from: form) }
                navigator.dismissSheet()
            } label: {
                ZStack {
                    Text("Save Daily Goal")
                    Color(.clear)
                }
            }
            .disabled(!form.canSave)
            
            LabelFormEntry(label: $form.label)
            
            FormEntry {
                NullTextField(text: $form.description, prompt: "Description")
            } label: {
                Text("Description")
            }
            
            FormEntry {
                GoalResultPicker($form.config)
            } label: {
                Text("Goal Configuration")
            }
            
            FormEntry {
                Picker("", selection: $form.type) {
                    ForEach(GoalType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
            } label: {
                Text("Goal Type")
            }
        }
    }
    
    init(
        _ goal: DailyGoal? = nil
    ) {
        if let goal = goal { self.form = GoalForm(goal) }
        else { self.form = GoalForm() }
    }
}

@Observable
final class GoalForm {
    let base: DailyGoal?
    
    var label: String
    var description: String?
    
    var config: GoalResult.Config?
    var type: GoalType
    var active: Bool
    
    var isNew: Bool { base == nil }
    
    var canSave: Bool {
        label != .null
        && config != nil
    }
    
    init() {
        self.base = nil
        self.label = ""
        self.description = nil
        self.config = .completion(steps: .linear(steps: 2))
        self.type = .neutral
        self.active = true
    }
    
    init(_ base: DailyGoal) {
        self.base = base
        self.label = base.label
        self.description = base.description
        self.config = base.config
        self.type = base.type
        self.active = base.active
    }
    
    func create() -> DailyGoal? {
        guard let config = self.config else { return nil }
        
        if let base = base {
            return base.edit(
                label: self.label
                , description: self.description
                , config: config
                , type: self.type
                , active: self.active
            )
        } else {
            return DailyGoal.new(
                label: self.label
                , description: self.description
                , config: config
                , type: self.type
            )
        }
    }
}

#Preview {
//    GoalFormView()
    GoalFormView(PreviewMocks.cleanApartment)
}
