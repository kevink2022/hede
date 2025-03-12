//
//  GoalGroupEditableScreen.swift
//  hede
//
//  Created by Kevin Kelly on 3/10/25.
//

import Foundation
import SwiftUI
import Models

import DomainUI

struct GoalGroupEditableScreen: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    @Environment(\.editMode) private var editMode
    
    @State private var form: GoalGroupForm
    
    private var isEditing: Bool { editMode?.wrappedValue.isEditing == true }
    @State private var editState: Self.EditState = .orderGoals
    @State private var searchPredicate: String = ""
    
    private var goalsToAdd: [DailyGoal] {
        repository.goals.dailyGoals.filter { goal in
            !form.goals.contains(goal) && goal.label.fuzzyMatch(searchPredicate)
        }
    }
    
    var body: some View {
        List {
            if isEditing {
                Section("Label") {
                    TextField("", text: $form.label, prompt: Text("Label"))
                }
                
                Section("Description") {
                    NullTextEditor(text: $form.description, prompt: "Description")
                }
            } else if let description = form.description {
                VStack(alignment: .leading) {
                    Text(description)
                        .padding(.top, 2)
                }
            }
            
            if !isEditing {
                Section("Goals") {
                    ForEach(form.goals) { goal in
                        
                        NavigationLink {
                            GoalScreen(goal)
                        } label: {
                            Text(goal.label)
                        }
                    }
                }
            } else {
                Section("Manage Goals") {
                    
                    Picker("", selection: $editState) {
                        ForEach(Self.EditState.allCases, id: \.self) { state in
                            Text(state.label)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch self.editState {
                        
                    case .addRemoveGoals:
                        ForEach(form.goals) { goal in
                            Button {
                                guard let index = form.goals.firstIndex(where: { $0.id == goal.id }) else { return }
                                return withAnimation { form.goals.remove(at: index) }
                            } label: {
                                Label(goal.label, systemImage: "minus")
                                    .foregroundStyle(.primary)
                            }
                        }
                        
                        Text("")
                        
                        TextField("Search", text: $searchPredicate, prompt: Text("Search"))
                            .id("searchField")
                        
                        ForEach(goalsToAdd) { goal in
                            Button {
                                withAnimation { form.goals.append(goal) }
                            } label: {
                                Label(goal.label, systemImage: SI.add)
                                    .foregroundStyle(.primary)
                            }
                        }
                        
                    case .orderGoals:
                        ForEach(form.goals) { goal in
                            Text(goal.label)
                                .onDrag {
                                    return NSItemProvider(object: goal.label as NSString)
                                }
                        }
                        .onMove { indices, newOffset in
                            form.goals.move(fromOffsets: indices, toOffset: newOffset)
                        }
                    }
                }
            }
        }
        .listStyle(.inset)
        .navigationTitle(navTitle)
        .toolbar {
            EditButton()
        }
        
        .onChange(of: isEditing) { oldValue, newValue in
            if newValue == false && form.canSave {
                Task { await eventManager.saveGoalGroup(from: form) }
            }
        }
    }
    
    private var navTitle: String { (isEditing ? "Editing: " : "") + (form.base?.label ?? "New")  }
    
    init(_ group: DailyGoalListSection) {
        self.form = GoalGroupForm(group)
    }
        
    private enum EditState: String, CaseIterable {
        case orderGoals = "Order Goals"
        case addRemoveGoals = "Add/Remove Goal"
        
        var label: String { self.rawValue }
    }
}
