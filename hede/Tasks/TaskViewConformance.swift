//
//  TaskViewConformance.swift
//  hede
//
//  Created by Kevin Kelly on 2/8/25.
//

import SwiftUI
import Models

protocol TaskScreenCustomFieldView {
    associatedtype ViewType: View
    var taskScreenCustomFieldView: ViewType { get }
}

extension ToDoTask: TaskScreenCustomFieldView {
    var taskScreenCustomFieldView: some View {
        VStack(alignment: .leading) {
        }
    }
}
