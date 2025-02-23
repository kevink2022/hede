//
//  NullDatePicker.swift
//  hede
//
//  Created by Kevin Kelly on 2/20/25.
//

import SwiftUI
import Models

struct NullDatePicker: View {
    @Binding private var date: Date?
    private let label: String
    
    @State private var isSet: Bool
    @State private var displayDate: Date

    var body: some View {
        VStack {
            Toggle(isOn: $isSet) {
                Text("Set \(label)?")
            }
            
            if isSet {
                DatePicker(label, selection: $displayDate)
            }
        }
        
        .onChange(of: isSet) { updateDate() }
        .onChange(of: displayDate) { updateDate() }
    }
    
    func updateDate() {
        if isSet { date = displayDate }
        else { date = nil }
    }
    
    init(
        date: Binding<Date?>
        , label: String = "Date"
    ) {
        self._date = date
        self.label = label
        
        self._displayDate = State(initialValue: date.wrappedValue ?? Date.now)
        self._isSet = State(initialValue: date.wrappedValue != nil)
    }
}
