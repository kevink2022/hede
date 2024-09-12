//
//  SourcesScreen.swift
//  hede
//
//  Created by Kevin Kelly on 9/8/24.
//

import SwiftUI

fileprivate typealias C = ViewConstants.Colors
fileprivate typealias F = ViewConstants.Fonts
fileprivate typealias T = ViewConstants.Text
fileprivate typealias V = ViewConstants
fileprivate typealias SI = ViewConstants.SystemImages

struct SourcesScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        @Bindable var navigator = navigator
        
        NavigationStack(path: $navigator.sources) {
            ScrollView {
                
                HStack {
                    Text(T.taskSources)
                        .font(F.screenTitle)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                
                BoxGrid {
                    NavigationLink {
                        ToDoSourcesScreen()
                            .tint(C.toDo)
                    } label: {
                        Box(
                            color: C.toDo,
                            topRight: {
                                BoxImage(systemName: SI.todo)
                            }, bottomLeft: {
                                BoxText(T.toDo)
                            }
                        )
                    }
                    .foregroundStyle(.primary)
                    
                    NavigationLink {
                        RecurringSourcesScreen()
                            .tint(C.reccurring)
                            
                    } label: {
                        Box(
                            color: C.reccurring,
                            topRight: {
                                BoxImage(systemName: SI.recurring)
                            }, bottomLeft: {
                                BoxText(T.recurring)
                            }
                        )
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }
}

#Preview {
    SourcesScreen()
        .environment(\.repository, PreviewMocks.mockRepository)
}

