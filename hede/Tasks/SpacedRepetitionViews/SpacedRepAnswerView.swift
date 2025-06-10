//
//  SpacedRepAnswerView.swift
//  hede
//
//  Created by Kevin Kelly on 6/9/25.
//

import SwiftUI
import Domain
import DomainUI

struct SpacedRepAnswerView: View {
    
    @Binding private var review: AnySpacedRepetitionContext?
    
    private let algorithm: AnySpacedRepetition
    private let state: AnySpacedRepetitionContext?
    
    @State private var ankiReview: AnkiFSRS.Review?
    
    var body: some View {
        switch algorithm.code {
        
        case .linear(let algorithm):
            LargeButton {
                review = AnySpacedRepetitionContext(LinearSpacedRepetition.Review(date: .now))
            } label: {
                Text("Complete Task")
            }
        
        case .ankiFSRS_5(let algorithm):
            AnkiAnswerView(
                algorithm: algorithm
                , state: state?.data as? AnkiFSRS.State
                , review: $ankiReview
            )
            .onChange(of: ankiReview) { oldValue, newValue in
                guard let ankiReview = ankiReview else { review = nil; return }
                review = AnySpacedRepetitionContext(ankiReview)
            }
            
        default: EmptyView()
        }
        

    }
    
    init(
        algorithm: AnySpacedRepetition
        , state: AnySpacedRepetitionContext?
        , review: Binding<AnySpacedRepetitionContext?>
    ) {
        self.algorithm = algorithm
        self.state = state
        self._review = review
        self.ankiReview = nil
    }
}

struct AnkiAnswerView: View {
    
    @Binding private var review: AnkiFSRS.Review?
    
    private let algorithm: AnkiFSRS
    private let state: AnkiFSRS.State?
    private let baseDate: Date
    
    var body: some View {
        VStack {
            LargeButton {
                review = AnkiFSRS.Review(grade: .easy, date: baseDate)
            } label: {
                VStack {
                    Text("Easy")
                    Text("(\(simulate(grade: .easy).nextReview.shortFormat))")
                }
            }
            
            LargeButton {
                review = AnkiFSRS.Review(grade: .good, date: baseDate)
            } label: {
                VStack {
                    Text("Good")
                    Text("(\(simulate(grade: .good).nextReview.shortFormat))")
                }
            }
            
            LargeButton {
                review = AnkiFSRS.Review(grade: .hard, date: baseDate)
            } label: {
                VStack {
                    Text("Hard")
                    Text("(\(simulate(grade: .hard).nextReview.shortFormat))")
                }
            }
            
            LargeButton {
                review = AnkiFSRS.Review(grade: .forgot, date: baseDate)
            } label: {
                VStack {
                    Text("Forgot")
                    Text("(\(simulate(grade: .forgot).nextReview.shortFormat))")
                }
            }
        }
    }
    
    init(
        algorithm: AnkiFSRS
        , state: AnkiFSRS.State?
        , review: Binding<AnkiFSRS.Review?>
    ) {
        self.algorithm = algorithm
        self.state = state
        self._review = review
        self.baseDate = .now
    }
    
    private func simulate(grade: AnkiSRS.Grade) -> (nextReview: Date, newState: AnkiFSRS.State) {
        let review = AnkiFSRS.ReviewContext(
            grade: grade
            , date: baseDate
        )
        
        return algorithm.nextReview(
            state: state
            , review: review
        )
    }
}

#Preview {
    SpacedRepAnswerView(algorithm: AnySpacedRepetition(AnkiFSRS()), state: nil, review: .constant(nil))
//    AnkiAnswerView(algorithm: AnkiFSRS(), state: nil)
}
