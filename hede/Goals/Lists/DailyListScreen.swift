//
//  DailyListScreen.swift
//  hede
//
//  Created by Kevin Kelly on 3/11/25.
//

import SwiftUI
import DomainUI

import Domain
import Models

struct DailyListScreen: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    @Environment(\.editMode) private var editMode
    
    @State private var form: DailyListForm
    
    private var isEditing: Bool { editMode?.wrappedValue.isEditing == true }
    @State private var editState: Self.EditState = .order
    @State private var searchPredicate: String = ""
    
    private var groupsToAdd: [DailyGoalListSection] {
        repository.goals.dailyGoalListSections.filter { group in
            !form.groups.contains(group) && group.label.fuzzyMatch(searchPredicate)
        }
    }
    
    var body: some View {
        WeekdayWeekPicker($form.weekdays)
            .disabled(!isEditing)
            .foregroundStyle(.primary)
        
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
                Section("Groups") {
                    ForEach(form.groups) { group in
                        NavigationLink {
                            GoalGroupEditableScreen(group)
                        } label: {
                            GoalGroupRow(group)
                        }
                    }
                }
            } else {
                Section("Manage Groups") {
                    Picker("", selection: $editState) {
                        ForEach(Self.EditState.allCases, id: \.self) { state in
                            Text(state.label)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch self.editState {
                    case .addRemove:
                        ForEach(form.groups) { group in
                            Button {
                                guard let index = form.groups.firstIndex(where: { $0.id == group.id }) else { return }
                                return withAnimation { form.groups.remove(at: index) }
                            } label: {
                                Label(group.label, systemImage: "minus")
                                    .foregroundStyle(.primary)
                            }
                        }
                        
                        Text("")
                        
                        TextField("Search", text: $searchPredicate, prompt: Text("Search"))
                            .id("searchField")
                        
                        ForEach(groupsToAdd) { group in
                            Button {
                                withAnimation { form.groups.append(group) }
                            } label: {
                                Label(group.label, systemImage: SI.add)
                                    .foregroundStyle(.primary)
                            }
                        }
                    case .order:
                        ForEach(form.groups) { group in
                            Text(group.label)
                                .onDrag {
                                    return NSItemProvider(object: group.label as NSString)
                                }
                        }
                        .onMove { indices, newOffset in
                            form.groups.move(fromOffsets: indices, toOffset: newOffset)
                        }
                    }
                }
            }
        }
        .listStyle(.inset)
        .navigationTitle(navTitle)
        .toolbar { EditButton() }
        
        .onChange(of: isEditing) { oldValue, newValue in
            if newValue == false && form.canSave {
                Task { await eventManager.saveGoalList(from: form) }
            }
        }
    }
    
    private var navTitle: String { (isEditing ? "Editing: " : "") + (form.base?.label ?? "New")  }
    
    init() {
        self.form = DailyListForm()
    }
    
    init(_ list: DailyGoalList) {
        self.form = DailyListForm(list)
    }
    
    private enum EditState: String, CaseIterable {
        case order = "Order Groups"
        case addRemove = "Add/Remove Groups"
        
        var label: String { self.rawValue }
    }
}

@Observable
class DailyListForm {
    let base: DailyGoalList?
    
    var label: String
    var description: String?
    var weekdays: [Weekday]
    var groups: [DailyGoalListSection]
    
    var isNew: Bool { base == nil }
     
    var canSave: Bool {
        self.label != .null
    }
    
    init() {
        self.base = nil
        
        self.label = ""
        self.description = nil
        self.weekdays = []
        self.groups = []
    }
    
    init(_ base: DailyGoalList) {
        self.base = base
        
        self.label = base.label
        self.description = base.description
        self.weekdays = base.weekdays
        self.groups = base.sections
    }
    
    func create() -> DailyGoalList? {
        guard canSave else { return nil }
        
        if let base = base {
            return base.edit(
                sections: self.groups
                , label: self.label
                , description: self.description
                , weekdays: self.weekdays
            )
        } else {
            return DailyGoalList.new(
                sections: self.groups
                , label: self.label
                , description: self.description
                , weekdays: self.weekdays
            )
        }
    }
}

#Preview {
    DailyListScreen()
}
