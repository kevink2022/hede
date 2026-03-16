//
//  StudySession.swift
//  Database
//
//  Created by Kevin Kelly on 7/2/25.
//

import Foundation
import Models
import Assemblages
import Storage
import Combine
import Domain

@Observable
public class StudySession {
    private let transactor: Transactor<[FlashcardReview], StudySessionState>
    private var cancellables: Set<AnyCancellable> = []
    var state: StudySessionState
    
    init(_ reviews: [FlashcardReview]) {
        self.state = StudySessionState(reviews)
        self.transactor = Transactor<[FlashcardReview], StudySessionState>(
            key: StorageKey(namespace: "Flashcards", key: "ActiveSession", version: 0)
            , basePost: StudySessionState(reviews)
            , inMemory: true
            , coreCommit: ({ reviews, state in state.commit(reviews) })
        )
        
        self.transactor.publisher
            .sink { [weak self] state in
                guard let self = self else { return }
                self.state = state}
            .store(in: &cancellables)
    }
    
    func exportReviews() -> [FlashcardReview] { state.export }
    func erase() async { try? await transactor.eraseAll() }
    
    public func complete(review: FlashcardReview, context: AnySpacedRepetitionContext) async {
        let completed = review.complete(at: .now, review: context)
        let newReview = completed.card.nextReview(from: completed)
        await transactor.commit(transaction: [completed, newReview].compactMap{ $0 })
    }
    
    public func undo() async { await transactor.undo() }
    public var nextReview: FlashcardReview? { state.nextReview }
    public var completedCount: Int { state.completed.count }
    public var remainingCount: Int { state.toReview.count + state.repeated.count }
}

struct StudySessionState {
    /// Initial set of reviews remaning
    let toReview: KeySet<FlashcardReview>
    /// Completed reviews
    let completed: KeySet<FlashcardReview>
    /// New reviews to be completed in a later session
    let new: KeySet<FlashcardReview>
    /// New reviews that need to be completed in this session
    let repeated: KeySet<FlashcardReview>
    
    let nextReview: FlashcardReview?
    
    var unreviewed: [FlashcardReview] { toReview.values + repeated.values }
    var export: [FlashcardReview] { completed.values + new.values + repeated.values }
    
    init(_ reviews: [FlashcardReview]) {
        self.toReview = KeySet<FlashcardReview>(reviews)
        self.completed = []
        self.new = []
        self.repeated = []
        self.nextReview = reviews.randomElement()
    }
    
    init(toReview: KeySet<FlashcardReview>, completed: KeySet<FlashcardReview>, new: KeySet<FlashcardReview>, repeated: KeySet<FlashcardReview>, nextReview: FlashcardReview?) {
        self.toReview = toReview
        self.completed = completed
        self.new = new
        self.repeated = repeated
        self.nextReview = nextReview
    }
    
    func commit(_ reviews: [FlashcardReview]) -> StudySessionState {
        let sameSessionReviewBuffer = TimeInterval(20000) // If 'forgot'
        
        let newCompleted = reviews.filter { $0.isComplete }
        
        let newReviewInFuture = reviews.filter {
            !$0.isComplete && $0.scheduled.start.timeIntervalSinceNow > sameSessionReviewBuffer
        }
        
        let newReviewInSesion = reviews.filter {
            !$0.isComplete && $0.scheduled.start.timeIntervalSinceNow < sameSessionReviewBuffer
        }
        
        let toReview = self.toReview.filter { !newCompleted.map(\.id).contains($0.id) }
        
        let repeated = self.repeated
            .updating(with: newReviewInSesion)
            .filter { !newCompleted.map(\.id).contains($0.id) }
        
        let nextReview = (toReview.values + repeated.values).randomElement()

        return .init(
            toReview: toReview
            , completed: self.completed.updating(with: newCompleted)
            , new: self.new.updating(with: newReviewInFuture)
            , repeated: repeated
            , nextReview: nextReview
        )
    }
}
