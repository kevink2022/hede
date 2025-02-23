//
//  TimeDurationFormEntry.swift
//  hede
//
//  Created by Kevin Kelly on 9/12/24.
//

import SwiftUI
import Models
import Domain

struct TimeDurationFormEntry: View {
    
    @Binding private var duration: TimeDuration
    @Binding private var valid: Bool
    private let prePopValue: String?
    private let prePopInterval: TimeDuration.Interval?
    private let showHelp: Bool
    
    var body: some View {
        Section {
            TimeDurationPicker(duration: $duration, valid: $valid, prePopValue: prePopValue, prePopInterval: prePopInterval)
        } header: {
            Text("Time Between Tasks")
        } footer: {
            if showHelp {
                Text("The time duration between when a task is reapeated from and when the next task is automatically scheduled.")
            }
        }
    }
    
    init(
        duration: Binding<TimeDuration>
        , valid: Binding<Bool> = .constant(true)
        , prePopValue: String? = nil
        , prePopInterval: TimeDuration.Interval? = nil
        , showHelp: Bool = false
    ) {
        self._duration = duration
        self._valid = valid
        self.prePopValue = prePopValue
        self.prePopInterval = prePopInterval
        self.showHelp = showHelp
    }
}

//#Preview {
//    TimeDurationFormEntry()
//}
