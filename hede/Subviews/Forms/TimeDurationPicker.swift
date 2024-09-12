//
//  TimeDurationPicker.swift
//  hede
//
//  Created by Kevin Kelly on 9/12/24.
//

import SwiftUI
import Models

struct TimeDurationPicker: View {
    
    @Binding private var duration: TimeDuration
    @Binding private var valid: Bool
    
    @State private var spacingValueInput: String
    @State private var spacingInterval: TimeDuration.Interval
    private let prePopValue: String?
    private let prePopInterval: TimeDuration.Interval?
    
    var body: some View {
        HStack {
            TextField("Number of", text: $spacingValueInput)
                .keyboardType(.numberPad)
                .frame(width: 100)
            
            Picker("", selection: $spacingInterval) {
                ForEach(TimeDuration.Interval.allCases, id: \.self) { interval in
                    Text(interval.label)
                }
            }
        }
        
        .onChange(of: spacingInterval) { updateDuration() }
        .onChange(of: spacingValueInput) { updateDuration() }
        .onAppear {
            spacingValueInput = prePopValue ?? String(duration.value)
            spacingInterval = prePopInterval ?? duration.interval
            valid = nil == Int(spacingValueInput) ? false : true
        }
    }
    
    private func updateDuration() {
        guard let value = Int(spacingValueInput) else {
            valid = false
            return
        }
        duration = TimeDuration(interval: spacingInterval, value: value)
        valid = true
    }
    
    init(
        duration: Binding<TimeDuration>
        , valid: Binding<Bool> = .constant(true)
        , prePopValue: String? = nil
        , prePopInterval: TimeDuration.Interval? = nil
    ) {
        self._duration = duration
        self._valid = valid
        self.prePopValue = prePopValue
        self.prePopInterval = prePopInterval
        self.spacingValueInput = ""
        self.spacingInterval = .weeks
    }
}


#Preview {
    TimeDurationPicker(duration: .constant(.weeks(1)))
}
