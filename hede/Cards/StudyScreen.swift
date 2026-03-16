//
//  StudyScreen.swift
//  hede
//
//  Created by Kevin Kelly on 6/18/25.
//

import SwiftUI
import DomainUI
import Models
import Domain
import Database

struct StudyScreen: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.repository) private var repository
    
//    @State private var session: StudySession
    private let reviews: [FlashcardReview]
    private var session: StudySession? { repository.tasks.studySession }
    private var review: FlashcardReview? { session?.nextReview }
    @State private var front: Bool = true
    @State private var buttonsDisabled: Bool = true
    @State private var initialized: Bool = false
    @State private var completedCount: Int = 0
    
    var body: some View {
        if let session = session {
            ZStack {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { tap() }
                
                VStack {
                    if let review = session.nextReview {
                        HStack {
                            Text(review.deck.deckPath)
                                .font(.footnote).opacity(0.5)
                            
                            Spacer()
                            
                            Text("Completed: \(session.completedCount)")
                                .font(.footnote).opacity(0.5)
                        }
                        
                        HStack {
                            Spacer()
                            Text("Remaining: \(session.remainingCount)")
                                .font(.footnote).opacity(0.5)
                        }
                        
                        Divider()
                            .padding(.bottom, 0)
                        
                        ScrollView {
                            Spacer()
                            
                            CardElementGroupView(front == true ? review.card.front : review.card.back)
                                .onTapGesture { tap() }
                            
                            Spacer()
                        }
                        .onTapGesture { tap() }
                        .padding(0)
                        
                        Divider()
                            .padding(.top, 0)
                        
                        CardStudyButton(review, session: session)
                            .frame(height: 150)
                            .disabled(buttonsDisabled)
                        
                    } else {
                        Text("Completed \(session.completedCount) reviews!")
                            .font(.title)
                            .onAppear {
                                completedCount = session.completedCount
                                Task { await repository.tasks.endStudySession() }
                            }
                    }
                }
                .padding()
            }
            .onChange(of: session.nextReview) {
                front = true
                buttonsDisabled = true
            }
            
            .toolbar {
                Button {
                    Task { await session.undo() }
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                }
                
                Menu {
                    Button {
                        completedCount = session.completedCount
                        Task { await repository.tasks.endStudySession() }
                    } label: {
                        Label("End Session", systemImage: "square.and.arrow.down")
                    }
                    
                    Button(role: .destructive) {
                        completedCount = 0
                        Task { await repository.tasks.cancelStudySession() }
                    } label: {
                        Label("Cancel Session", systemImage: SI.delete)
                    }
                    
                    
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        } else {
            if completedCount > 0 {
                Text("Completed \(completedCount) reviews!")
                    .font(.title)
                    
            } else {
                Text("Session Canceled.")
                    .font(.title)
                    .onAppear { initialize() }
            }
        
        }
        
    }
    
    private func tap() {
        front.toggle()
        buttonsDisabled = false
    }
    
    private func initialize() {
        guard !initialized else { return }
        repository.tasks.newStudySession(reviews)
        initialized = true
    }
    
    init(_ reviews: [FlashcardReview]) { self.reviews = reviews }
}

struct CardStudyButton: View {
    @Environment(\.eventManager) private var eventManager
    
    private let cardReview: FlashcardReview
    private let session: StudySession
    private var task: HedeTask { cardReview.task }
    @State private var reviewContext: AnySpacedRepetitionContext? = nil
    
    var body: some View {
        if let algorithm = cardReview.card.scheduler.algorithm {
            SpacedRepAnswerView(algorithm: algorithm, state: task.state, review: $reviewContext)
                .onChange(of: reviewContext) { oldValue, newValue in
                    guard let reviewContext = reviewContext else { return }
                    Task { await session.complete(review: cardReview, context: reviewContext) }
                }
        }
        
        else { Text("ERROR: No Spaced Repetition Algorithm") }
    }
    
    init(
        _ review: FlashcardReview
        , session: StudySession
    ) {
        self.cardReview = review
        self.session = session
    }
    
    private func complete(_ task: HedeTask, with review: AnySpacedRepetitionContext? = nil) {
        Task { await eventManager.complete(task, with: review) }
    }
}

#Preview {
    StudyScreen(PreviewMocks.reviews)
        .environment(\.repository, PreviewMocks.mockRepository)
}
