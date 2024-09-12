//
//  TasksScreen.swift
//  hede
//
//  Created by Kevin Kelly on 9/11/24.
//

import SwiftUI

fileprivate typealias C = ViewConstants.Colors
fileprivate typealias F = ViewConstants.Fonts
fileprivate typealias T = ViewConstants.Text
fileprivate typealias V = ViewConstants
fileprivate typealias SI = ViewConstants.SystemImages

struct TasksScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    var body: some View {
        @Bindable var navigator = navigator

        NavigationStack(path: $navigator.sources) {
            ScrollView {
                
                HStack {
                    Text(T.tasks)
                        .font(F.screenTitle)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                
                LazyVStack {
                    ForEach(repository.tasks) { task in
                        Box(
                            color: task.scheduled.color
                            , topRight: {
                                Text(task.scheduled.dateTimeLabel)
                                    .font(F.boxSmall)
                            }
                            , bottomLeft: {
                                BoxText(task.label)
                            }
                        )
                        
                    }
                }
                .padding(V.boxInternalPadding)
            }
        }
    }
}

#Preview {
    TasksScreen()
        .environment(\.repository, PreviewMocks.mockRepository)
}

