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
                if let data = newBasis.taskSet[data.id] { newBasis.taskSet.remove(data) }
                else if let data = newBasis.taskSourceSet[data.id] { newBasis.taskSourceSet.remove(data) }
                else if let data = newBasis.categorySet[data.id] { newBasis.categorySet.remove(data) }
                else if let data = newBasis.pauseSet[data.id] { newBasis.pauseSet.remove(data) }
                
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
            case .task(let data): newBasis.taskSet.update(with: data)
            case .source(let data): newBasis.taskSourceSet.update(with: data)
            case .category(let data): newBasis.categorySet.update(with: data)
            case .pause(let data): newBasis.pauseSet.update(with: data)
            
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
