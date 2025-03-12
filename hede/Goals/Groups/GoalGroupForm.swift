//
//  GoalGroupForm.swift
//  hede
//
//  Created by Kevin Kelly on 3/9/25.
//

import SwiftUI
import Models

import DomainUI

struct GoalGroupFormView: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
//    @Environment(\.editMode) private var editMode
    
    @State private var form: GoalGroupForm
    
    private var goalsToAdd: [DailyGoal] {
        repository.goals.dailyGoals.filter { !form.goals.contains($0) }
    }
//    private var isEditing: Bool { editMode?.wrappedValue.isEditing == true }

    var body: some View {
        Form {
            Button {
                Task { await eventManager.saveGoalGroup(from: form) }
                navigator.dismissSheet()
            } label: {
                ZStack {
                    Text("Save Goal Group")
                    Color(.clear)
                }
            }
            .disabled(!form.canSave)
            
            FormEntry {
                TextField("", text: $form.label)
            } label: {
                Text("Label")
            }
            
            FormEntry {
                NullTextEditor(text: $form.description)
            } label: {
                Text("Description")
            }
            
            Section("Goals") {
                ForEach(form.goals) { goal in
                    Text(goal.label)
                        .onDrag {
                            return NSItemProvider(object: goal.label as NSString)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                form.goals.removeAll { $0 == goal }
                            } label: {
                                Image(systemName: "minus")
                            }
                            .tint(.red)
                        }
                }
                .onMove { indices, newOffset in
                    form.goals.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
            
            Section("Add Goals") {
                ForEach(goalsToAdd) { goal in
                    Button {
                        form.goals.append(goal)
                    } label: {
                        Label(goal.label, systemImage: SI.add)
                    }
                }
            }
        }
    }

    init() {
        self.form = GoalGroupForm()
    }
    
    init(_ group: DailyGoalListSection) {
        self.form = GoalGroupForm(group)
    }
}

@Observable
final class GoalGroupForm {
    let base: DailyGoalListSection?
    
    var label: String
    var description: String?
    
    var goals: [DailyGoal]
    var active: Bool
    
    var isNew: Bool { base == nil }
    
    var canSave: Bool {
        label != .null
    }
    
    init() {
        self.base = nil
        
        self.label = ""
        self.description = nil
        self.active = true
        
        self.goals = []
    }
    
    init(_ group: DailyGoalListSection) {
        self.base = group
        
        self.label = group.label
        self.description = group.description
        self.active = group.active
        
        self.goals = group.dailyGoals
    }
    
    func create() -> DailyGoalListSection? {
        guard canSave else { return nil }
        
        if let base = base {
            return base.edit(
                goals: goals
                , label: label
                , description: description
                , active: active
            )
        } else {
            return DailyGoalListSection.new(
                goals: goals
                , label: label
                , description: description
            )
        }
    }
}

#Preview {
    GoalGroupEditableScreen(PreviewMocks.habits)
        .environment(\.repository, PreviewMocks.mockRepository)
        .environment(\.eventManager, PreviewMocks.mockEventManager)
}
