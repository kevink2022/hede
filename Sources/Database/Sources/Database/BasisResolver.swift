//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/4/24.
//

import Foundation
import Models
import Assemblages

internal final class BasisResolver<T: Basis> {
    
    private let currentBasis: DataBasis
    
    internal init(_ currentBasis: T) {
        self.currentBasis = currentBasis.basis
    }
    
    /// Commit new models to the basis, adding, updating, and deleting them.
    internal func commit(_ assertionSet: KeySet<Assertion>) -> T {
        let newBasis = MutableBasis(currentBasis)
        
        assertionSet.forEach { assertion in
            switch assertion.assertCode {
            case .delete(let data):
                
                // Tasks
                if let data = newBasis.hedeTaskSet[data.id] { newBasis.hedeTaskSet.remove(data) }
                else if let data = newBasis.hedeSchedulerSet[data.id] { newBasis.hedeSchedulerSet.remove(data) }
                else if let data = newBasis.hedeTagSet[data.id] { newBasis.hedeTagSet.remove(data) }
                
                // Cards
                else if let data: Flashcard = newBasis.cardSet[data.id] { newBasis.cardSet.remove(data) }
                else if let data: FlashcardReview = newBasis.cardReviewSet[data.id] { newBasis.cardReviewSet.remove(data) }
                else if let data = newBasis.deckSet[data.id] { newBasis.deckSet.remove(data) }
                
                // Goals
                else if let data = newBasis.dailyGoalSet[data.id] { newBasis.dailyGoalSet.remove(data) }
                else if let data = newBasis.dailyGoalResultSet[data.id] { newBasis.dailyGoalResultSet.remove(data) }
                else if let data = newBasis.dailyGoalListSet[data.id] { newBasis.dailyGoalListSet.remove(data) }
                else if let data = newBasis.dailyGoalListSectionSet[data.id] { newBasis.dailyGoalListSectionSet.remove(data) }
                else if let data = newBasis.routineSet[data.id] { newBasis.routineSet.remove(data) }
                else if let data = newBasis.routineStepSet[data.id] { newBasis.routineStepSet.remove(data) }
                else if let data = newBasis.routineResultSet[data.id] { newBasis.routineResultSet.remove(data) }
                else if let data = newBasis.routineStepResultSet[data.id] { newBasis.routineStepResultSet.remove(data) }
              
            // Tasks
            case .hedeTask(let data): newBasis.hedeTaskSet.update(with: data)
            case .hedeScheduler(let data): newBasis.hedeSchedulerSet.update(with: data)
            case .hedeTag(let data): newBasis.hedeTagSet.update(with: data)
                
            // Cards
            case .flashcard(let data): newBasis.cardSet.update(with: data)
            case .flashcardReview(let data): newBasis.cardReviewSet.update(with: data)
            case .flashcardDeck(let data): newBasis.deckSet.update(with: data)
                
            // Goals
            case .dailyGoal(let data): newBasis.dailyGoalSet.update(with: data)
            case .dailyGoalResult(let data): newBasis.dailyGoalResultSet.update(with: data)
            case .dailyGoalList(let data): newBasis.dailyGoalListSet.update(with: data)
            case .dailyGoalListSection(let data): newBasis.dailyGoalListSectionSet.update(with: data)
            case .routine(let data): newBasis.routineSet.update(with: data)
            case .routineStep(let data): newBasis.routineStepSet.update(with: data)
            case .routineResult(let data): newBasis.routineResultSet.update(with: data)
            case .routineStepResult(let data): newBasis.routineStepResultSet.update(with: data)
            }
        }
        
        
        return T(newBasis)
    }
}
